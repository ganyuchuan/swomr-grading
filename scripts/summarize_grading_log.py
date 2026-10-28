#!/usr/bin/env python3
"""Summarize a JSONL grading audit log."""

from __future__ import annotations

import argparse
import json
from collections import Counter
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("log", type=Path)
    args = parser.parse_args()

    records: list[dict] = []
    with args.log.open(encoding="utf-8") as handle:
        for line_number, line in enumerate(handle, start=1):
            if not line.strip():
                continue
            try:
                records.append(json.loads(line))
            except json.JSONDecodeError as exc:
                raise SystemExit(f"{args.log}:{line_number}: invalid JSON: {exc}")

    if not records:
        print("No grading records.")
        return 0

    scores = Counter(int(record["score"]) for record in records)
    total = sum(scores.values())
    points = sum(score * count for score, count in scores.items())

    print(f"records: {total}")
    print(f"average: {points / total:.2f}")
    for score in sorted(scores):
        print(f"{score} points: {scores[score]}")

    anomalies = [
        record
        for record in records
        if int(record.get("after", -1)) != int(record.get("before", -2)) + 1
    ]
    if anomalies:
        print(f"count anomalies: {len(anomalies)}")
        for record in anomalies[:20]:
            print(
                f"  {record.get('examId', 'unknown')}: "
                f"{record.get('before')} -> {record.get('after')}"
            )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
