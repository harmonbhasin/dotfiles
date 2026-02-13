#!/bin/bash
# Blocks gh pr merge unless --squash is used, except when merging dev into main

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -qE 'gh\s+pr\s+merge'; then
  # Allow regular merge when merging the dev branch into main
  if echo "$COMMAND" | grep -qE '\bdev\b' && echo "$COMMAND" | grep -qE -- '--merge'; then
    exit 0
  fi

  # For all other merges, require --squash
  if ! echo "$COMMAND" | grep -qE -- '--squash'; then
    jq -n '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: "gh pr merge without --squash is blocked. Always use --squash unless merging dev into main (where --merge is allowed)."
      }
    }'
    exit 0
  fi
fi

exit 0
