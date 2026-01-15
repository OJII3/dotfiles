#!/usr/bin/env python3
import argparse
import os
from pathlib import Path
import tempfile

from tomlkit import dumps, parse
from tomlkit.items import InlineTable, Table


def deep_fill_missing(seed, existing):
    for key, value in existing.items():
        if key not in seed:
            seed[key] = value
            continue
        seed_value = seed[key]
        if isinstance(seed_value, (Table, InlineTable)) and isinstance(value, (Table, InlineTable)):
            deep_fill_missing(seed_value, value)


def atomic_write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp_path = tempfile.mkstemp(prefix=f"{path.name}.", suffix=".tmp", dir=path.parent)
    try:
        with os.fdopen(fd, "w", encoding="utf-8", newline="") as handle:
            handle.write(content)
        os.chmod(tmp_path, 0o600)
        os.replace(tmp_path, path)
    finally:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--seed", required=True)
    parser.add_argument("--config", required=True)
    args = parser.parse_args()

    seed_path = Path(args.seed)
    config_path = Path(args.config)

    seed_text = seed_path.read_text(encoding="utf-8")
    seed_doc = parse(seed_text)

    if not config_path.exists():
        atomic_write(config_path, seed_text)
        return 0

    existing_text = config_path.read_text(encoding="utf-8")
    existing_doc = parse(existing_text)

    deep_fill_missing(seed_doc, existing_doc)
    merged_text = dumps(seed_doc)

    if merged_text.strip() == existing_text.strip():
        os.chmod(config_path, 0o600)
        return 0

    atomic_write(config_path, merged_text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
