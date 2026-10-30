#!/usr/bin/env python3
import json
import os
import platform
import signal
import subprocess
import sys
import threading
from pathlib import Path


def t3_home():
    for name in ("T3CODE_HOME", "T3_HOME"):
        value = os.environ.get(name)
        if value:
            return Path(value).expanduser()

    for path in (Path.home() / ".t3-service", Path.home() / ".t3"):
        if path.exists():
            return path
    return Path.home() / ".t3-service"


def runtime_paths():
    override = os.environ.get("AGY_ACP_SERVER")
    if override:
        server = Path(override).expanduser()
        return server, server.with_name("localharness_external")

    system = platform.system().lower()
    if system not in ("linux", "darwin"):
        raise RuntimeError(f"unsupported platform: {system}")

    machine = platform.machine().lower()
    if machine in ("x86_64", "amd64"):
        arch = "x64"
    elif machine in ("aarch64", "arm64"):
        arch = "arm64"
    else:
        raise RuntimeError(f"unsupported architecture: {machine}")

    tool_root = t3_home() / "tools" / "antigravity-acp" / f"{system}-{arch}"
    active = json.loads((tool_root / "active.json").read_text(encoding="utf-8"))
    version_dir = tool_root / "versions" / active["releaseId"]
    server_name = "agy_acp_server.par"
    return version_dir / server_name, version_dir / "localharness_external"


def load_rules():
    path = Path.home() / ".gemini" / "AGENTS.md"
    try:
        content = path.read_text(encoding="utf-8").strip()
    except FileNotFoundError:
        return ""
    except OSError as error:
        print(f"[agy-acp-rules-proxy] cannot read {path}: {error}", file=sys.stderr)
        return ""

    if not content:
        return ""
    return f"Instructions from {path}:\n\n{content}\n\n"


def inject_into_message(message, rules, injected_sessions):
    if isinstance(message, list):
        changed = False
        for item in message:
            changed = inject_into_message(item, rules, injected_sessions) or changed
        return changed
    if not isinstance(message, dict) or message.get("method") != "session/prompt":
        return False

    params = message.get("params")
    if not isinstance(params, dict):
        return False
    session_id = params.get("sessionId")
    prompt = params.get("prompt")
    if not isinstance(session_id, str) or not isinstance(prompt, list):
        return False
    if session_id in injected_sessions:
        return False

    params["prompt"] = [{"type": "text", "text": rules}, *prompt]
    injected_sessions.add(session_id)
    return True


def update_line(line, rules, injected_sessions):
    if not rules:
        return line, False
    try:
        message = json.loads(line)
    except (json.JSONDecodeError, UnicodeDecodeError):
        return line, False

    if not inject_into_message(message, rules, injected_sessions):
        return line, False
    return (json.dumps(message, ensure_ascii=False, separators=(",", ":")) + "\n").encode(), True


def run_harness(args):
    _, helper = runtime_paths()
    if not helper.is_file():
        raise RuntimeError(f"missing Antigravity helper: {helper}")
    os.execv(str(helper), [str(helper), *args])


def run_proxy(args):
    server, _ = runtime_paths()
    if not server.is_file() or not os.access(server, os.X_OK):
        raise RuntimeError(f"Antigravity ACP server is missing or not executable: {server}")

    rules = load_rules()
    child = subprocess.Popen([str(server), *args], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    injected_sessions = set()

    def forward_input():
        try:
            for line in sys.stdin.buffer:
                outgoing, injected = update_line(line, rules, injected_sessions)
                child.stdin.write(outgoing)
                child.stdin.flush()
                if injected:
                    print("[agy-acp-rules-proxy] injected ~/.gemini/AGENTS.md", file=sys.stderr)
        except (BrokenPipeError, OSError):
            pass
        finally:
            try:
                child.stdin.close()
            except OSError:
                pass

    def forward_output():
        for line in child.stdout:
            sys.stdout.buffer.write(line)
            sys.stdout.buffer.flush()

    def forward_signal(signum, _frame):
        try:
            child.send_signal(signum)
        except OSError:
            pass

    signal.signal(signal.SIGTERM, forward_signal)
    signal.signal(signal.SIGINT, forward_signal)
    input_thread = threading.Thread(target=forward_input, daemon=True)
    output_thread = threading.Thread(target=forward_output, daemon=True)
    input_thread.start()
    output_thread.start()
    status = child.wait()
    output_thread.join()
    return status if status >= 0 else 128 - status


def main():
    if len(sys.argv) < 2:
        print("[agy-acp-rules-proxy] expected --proxy or --harness", file=sys.stderr)
        return 127

    mode, *args = sys.argv[1:]
    try:
        if mode == "--harness":
            run_harness(args)
        elif mode == "--proxy":
            return run_proxy(args)
        else:
            raise RuntimeError("expected --proxy or --harness")
    except (OSError, RuntimeError, KeyError, json.JSONDecodeError) as error:
        print(f"[agy-acp-rules-proxy] {error}", file=sys.stderr)
        return 127
    return 0


if __name__ == "__main__":
    sys.exit(main())
