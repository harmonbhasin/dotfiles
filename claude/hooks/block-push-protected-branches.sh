#!/bin/bash
# Blocks git push to main and dev branches

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -qE 'git\s+push\s+origin\s+(main|dev)(\s|$)'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Pushing directly to main or dev is blocked. Use a feature branch and open a pull request instead. Or if they have asked you to push to main or dev, ask them to do it."
    }
  }'
  exit 0
fi

exit 0
