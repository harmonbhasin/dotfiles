#!/usr/bin/env python3

import json
import sys


REMINDER = (
    "GOAL: maximize macro F1 - wallclock_hours/100 on 250TB in <=8h. Both accuracy "
    "and throughput are required - missing the 8h wall = DQ. "
    "Before stopping: we're on a tight deadline, so don't stop to ask for permission. "
    "(1) If you're about to suggest a next step or ask 'should I do X?', just do X "
    "instead - proceed autonomously. (2) If experiment results were produced this "
    "session, log them in EXPERIMENT_LOG.md. (3) If code changed, document it in "
    "CHANGELOG.md. (4) If `git status` shows uncommitted changes, commit them "
    "yourself (no user confirmation needed). If there's still pending work you were "
    "about to suggest, go ahead and do it, then log to EXPERIMENT_LOG.md / "
    "CHANGELOG.md and commit before stopping."
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
