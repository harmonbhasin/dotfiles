#!/usr/bin/env bash
# Claude Code status line: model name + context usage progress bar

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
out_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
api_ms=$(echo "$input" | jq -r '.cost.total_api_duration_ms // empty')

tps=""
if [ -n "$out_tokens" ] && [ -n "$api_ms" ] && [ "$api_ms" -gt 0 ]; then
  tps=$(printf "%.1f" "$(echo "scale=3; $out_tokens * 1000 / $api_ms" | bc -l)")
fi

tps_suffix=""
[ -n "$tps" ] && tps_suffix=$(printf "  %s tok/s" "$tps")

if [ -n "$used" ]; then
  # Build a 10-char progress bar
  filled=$(printf "%.0f" "$(echo "$used / 10" | bc -l)")
  [ "$filled" -gt 10 ] && filled=10
  empty=$((10 - filled))
  bar=$(printf '%0.s#' $(seq 1 $filled) 2>/dev/null)$(printf '%0.s-' $(seq 1 $empty) 2>/dev/null)
  used_int=$(printf "%.0f" "$used")
  printf "\033[2m%s  [%s] %s%%%s\033[0m" "$model" "$bar" "$used_int" "$tps_suffix"
else
  printf "\033[2m%s%s\033[0m" "$model" "$tps_suffix"
fi
