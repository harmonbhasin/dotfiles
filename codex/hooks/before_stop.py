#!/usr/bin/env python3

import json
import sys


REMINDER = (
    "Before stopping: confirm you logged experiment results in EXPERIMENT_LOG.md "
    "if this session ran experiments, confirm you committed meaningful code/config "
    "changes when appropriate, and if work remains incomplete do one more pass "
    "instead of stopping."
)


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 0

    if payload.get("hook_event_name") != "Stop":
        return 0

    if payload.get("stop_hook_active"):
        print(json.dumps({"continue": True}))
        return 0

    print(json.dumps({"decision": "block", "reason": REMINDER}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
