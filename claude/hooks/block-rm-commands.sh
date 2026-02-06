#!/bin/bash
# Blocks rm and rmdir commands

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -qE '(^|\s|;|&&|\|\|)(rm|rmdir)\s'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "The rm and rmdir commands are blocked by a pre-tool-use hook. Ask the human to do this."
    }
  }'
  exit 0
fi

exit 0
