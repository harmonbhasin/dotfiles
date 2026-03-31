#!/usr/bin/env bash
# Claude Code status line: model name + context usage progress bar

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

if [ -n "$used" ]; then
  # Build a 10-char progress bar
  filled=$(printf "%.0f" "$(echo "$used / 10" | bc -l)")
  [ "$filled" -gt 10 ] && filled=10
  empty=$((10 - filled))
  bar=$(printf '%0.s#' $(seq 1 $filled) 2>/dev/null)$(printf '%0.s-' $(seq 1 $empty) 2>/dev/null)
  used_int=$(printf "%.0f" "$used")
  printf "\033[2m%s  [%s] %s%%\033[0m" "$model" "$bar" "$used_int"
else
  printf "\033[2m%s\033[0m" "$model"
fi
