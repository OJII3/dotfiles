#!/usr/bin/env python3
"""Antigravity のフックを Langfuse の OTLP 取り込み口へ送る。

Antigravity は OTLP を直接出さないため、hooks.json の PostToolUse /
PostInvocation / Stop を span に変換して送る。フックはエージェントのループを
同期的に止めるので、送信は fork した子プロセスに任せ、親はすぐに `{}` を返す。

トークン数とモデル名はフックのペイロードに含まれない。トークン数は
`transcriptPath` の JSONL から、モデル名は同じ会話の SQLite の
`gen_metadata` から読む。どちらも Antigravity の内部形式なので、読めない
場合はその属性を落として送信を続ける。
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import json
import os
import re
import secrets
import sqlite3
import sys
import time
import urllib.request
from datetime import datetime
from pathlib import Path

EVENTS = ("PostToolUse", "PostInvocation", "Stop")
TAIL_BYTES = 8 * 1024 * 1024
MODEL_PATTERN = re.compile(rb"(?:gemini|claude|gpt|o[0-9])-[a-z0-9][a-z0-9.\-]{1,}")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("event", choices=EVENTS)
    parser.add_argument("--endpoint", required=True)
    parser.add_argument("--public-key-file", required=True)
    parser.add_argument("--secret-key-file", required=True)
    return parser.parse_args()


def read_secret(path: str) -> str:
    with open(path, encoding="utf-8") as handle:
        return handle.read().strip()


def read_transcript(path: object) -> list[dict]:
    """transcript の末尾だけを読む。先頭の行は途中で切れている可能性がある。"""
    if not isinstance(path, str) or not path:
        return []
    try:
        with open(path, "rb") as handle:
            handle.seek(0, os.SEEK_END)
            size = handle.tell()
            handle.seek(max(0, size - TAIL_BYTES))
            data = handle.read()
    except OSError:
        return []

    lines = data.splitlines()
    if size > TAIL_BYTES and lines:
        lines = lines[1:]

    entries = []
    for line in lines:
        try:
            entries.append(json.loads(line))
        except (json.JSONDecodeError, UnicodeDecodeError):
            continue
    return entries


def parse_time(value: object, fallback: int) -> int:
    if not isinstance(value, str):
        return fallback
    try:
        moment = datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        return fallback
    return int(moment.timestamp() * 1_000_000_000)


def step_times(entries: list[dict], step_index: object, fallback: int) -> tuple[int, int]:
    """ステップの終了時刻と、直前のステップの終了時刻から開始時刻を求める。"""
    if not isinstance(step_index, int):
        return fallback, fallback
    for index, entry in enumerate(entries):
        if entry.get("step_index") != step_index:
            continue
        end = parse_time(entry.get("created_at"), fallback)
        start = parse_time(entries[index - 1].get("created_at"), end) if index else end
        return min(start, end), end
    return fallback, fallback


def last_planner_response(entries: list[dict]) -> tuple[int, dict] | None:
    for index in range(len(entries) - 1, -1, -1):
        if entries[index].get("type") == "PLANNER_RESPONSE":
            return index, entries[index]
    return None


def conversation_db(transcript_path: object) -> Path | None:
    if not isinstance(transcript_path, str) or not transcript_path:
        return None
    parts = Path(transcript_path).parts
    try:
        index = parts.index("brain")
    except ValueError:
        return None
    acp_dir = Path(*parts[:index])
    if acp_dir.name != "antigravity-acp" or index + 1 >= len(parts):
        return None
    return acp_dir / "conversations" / f"{parts[index + 1]}.db"


def model_from_db(transcript_path: object, invocation_num: object) -> str | None:
    """会話 DB の gen_metadata から、その呼び出しのモデル名を拾う。

    gen_metadata の行はモデル呼び出しごとに 1 行で、idx は
    invocationNum - 1 に対応する。data は protobuf なので、モデル名は
    印字可能な文字列として現れるものを数えて選ぶ。
    """
    if not isinstance(invocation_num, int):
        return None
    db = conversation_db(transcript_path)
    if db is None:
        return None
    try:
        connection = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
        try:
            row = connection.execute(
                "select data from gen_metadata where idx = ?", (invocation_num - 1,)
            ).fetchone()
        finally:
            connection.close()
    except sqlite3.Error:
        return None
    if not row:
        return None

    names = [match.decode() for match in MODEL_PATTERN.findall(row[0])]
    if not names:
        return None
    return max(set(names), key=lambda name: (names.count(name), len(name)))


def generation_details(
    payload: dict, entries: list[dict], now: int
) -> tuple[str | None, dict, int, int]:
    model = payload.get("modelName") or payload.get("model")
    usage: dict[str, int | None] = {}
    start = end = now

    found = last_planner_response(entries)
    if found is not None:
        index, entry = found
        usage = {
            "input": entry.get("input_tokens"),
            "output": entry.get("output_tokens"),
            "cache_read": entry.get("cache_read_tokens"),
        }
        end = parse_time(entry.get("created_at"), now)
        start = parse_time(entries[index - 1].get("created_at"), end) if index else end

    if not isinstance(model, str) or not model:
        model = model_from_db(payload.get("transcriptPath"), payload.get("invocationNum"))

    return model, usage, min(start, end), end


def attribute(key: str, value: object) -> dict:
    if isinstance(value, bool):
        return {"key": key, "value": {"boolValue": value}}
    if isinstance(value, int):
        return {"key": key, "value": {"intValue": str(value)}}
    if isinstance(value, float):
        return {"key": key, "value": {"doubleValue": value}}
    return {"key": key, "value": {"stringValue": str(value)}}


def build_span(event: str, payload: dict) -> dict:
    conversation = payload.get("conversationId") or "unknown"
    workspaces = payload.get("workspacePaths")
    workspace = workspaces[0] if isinstance(workspaces, list) and workspaces else None

    now = time.time_ns()
    entries = read_transcript(payload.get("transcriptPath"))
    trace_name = f"antigravity/{Path(workspace).name}" if workspace else "antigravity"
    attributes = [
        attribute("gen_ai.conversation.id", conversation),
        attribute("langfuse.session.id", conversation),
        attribute("langfuse.trace.name", trace_name),
        attribute("antigravity.hook.event", event),
    ]
    if workspace:
        attributes.append(attribute("antigravity.workspace", workspace))

    error = payload.get("error")

    if event == "PostToolUse":
        tool = (payload.get("toolCall") or {}).get("name") or payload.get("toolName") or "unknown"
        start, end = step_times(entries, payload.get("stepIdx"), now)
        name = f"execute_tool {tool}"
        kind = 1
        attributes += [
            attribute("gen_ai.operation.name", "execute_tool"),
            attribute("gen_ai.tool.name", tool),
            attribute("langfuse.observation.type", "span"),
        ]
    elif event == "PostInvocation":
        model, usage, start, end = generation_details(payload, entries, now)
        name = f"chat {model}" if model else "chat"
        kind = 3
        attributes += [
            attribute("gen_ai.operation.name", "chat"),
            attribute("gen_ai.provider.name", "gcp.gemini"),
            attribute("langfuse.observation.type", "generation"),
        ]
        if model:
            attributes.append(attribute("gen_ai.request.model", model))
            attributes.append(attribute("langfuse.observation.model.name", model))
        total_input = None
        if usage.get("input") is not None:
            # Langfuse は input_tokens から cache_read_input_tokens を引いて
            # 非キャッシュ入力を求める。Antigravity の input_tokens は
            # キャッシュ分を含まないので、ここで足して総入力として送る。
            total_input = int(usage["input"]) + int(usage.get("cache_read") or 0)
            attributes.append(attribute("gen_ai.usage.input_tokens", total_input))
        if usage.get("output") is not None:
            attributes.append(attribute("gen_ai.usage.output_tokens", int(usage["output"])))
        if usage.get("cache_read") is not None:
            attributes.append(
                attribute("gen_ai.usage.cache_read_input_tokens", int(usage["cache_read"]))
            )
        if total_input is not None and usage.get("output") is not None:
            attributes.append(
                attribute("gen_ai.usage.total_tokens", total_input + int(usage["output"]))
            )
    else:
        start = end = now
        name = "session end"
        kind = 1
        attributes += [
            attribute("gen_ai.operation.name", "invoke_agent"),
            attribute("langfuse.observation.type", "span"),
        ]
        if payload.get("terminationReason"):
            attributes.append(
                attribute("antigravity.termination_reason", payload["terminationReason"])
            )

    span = {
        "traceId": hashlib.sha256(conversation.encode()).hexdigest()[:32],
        "spanId": secrets.token_hex(8),
        "name": name,
        "kind": kind,
        "startTimeUnixNano": str(start),
        "endTimeUnixNano": str(end),
        "attributes": attributes,
    }
    if error:
        span["status"] = {"code": 2, "message": str(error)[:200]}
        attributes.append(attribute("error.type", str(error)[:200]))
    return span


def send(args: argparse.Namespace, span: dict) -> None:
    token = base64.b64encode(
        f"{read_secret(args.public_key_file)}:{read_secret(args.secret_key_file)}".encode()
    ).decode()
    body = json.dumps(
        {
            "resourceSpans": [
                {
                    "resource": {"attributes": [attribute("service.name", "antigravity")]},
                    "scopeSpans": [
                        {
                            "scope": {"name": "antigravity.hooks", "version": "1"},
                            "spans": [span],
                        }
                    ],
                }
            ]
        }
    ).encode()
    request = urllib.request.Request(
        f"{args.endpoint.rstrip('/')}/v1/traces",
        data=body,
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Basic {token}",
            "x-langfuse-ingestion-version": "4",
        },
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=10):
        pass


def main() -> int:
    args = parse_args()
    try:
        raw = sys.stdin.read()
        payload = json.loads(raw) if raw.strip() else {}
    except (json.JSONDecodeError, UnicodeDecodeError):
        payload = {}

    # フックは同期で呼ばれるため、送信は孫プロセスへ切り離す。孫は標準出力を
    # 閉じないとフックの呼び出し元が EOF を待ち続ける。
    try:
        pid = os.fork()
    except OSError:
        pid = -1

    if pid == 0:
        os.setsid()
        if os.fork() == 0:
            try:
                os.closerange(0, 3)
                send(args, build_span(args.event, payload))
            except Exception:
                pass
            finally:
                os._exit(0)
        os._exit(0)

    if pid > 0:
        try:
            os.waitpid(pid, 0)
        except OSError:
            pass

    print("{}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
