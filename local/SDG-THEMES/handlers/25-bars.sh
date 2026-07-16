#!/bin/bash
set -euo pipefail

# Exit early if bar config is empty
[[ -z "${ENABLED_BARS:-}" ]] && exit 0

# Bar index mapping (theme config 1-4 → DMS 0-3):
#   1 = top default    → index 0
#   2 = bottom windows → index 1
#   3 = top mac-style  → index 2
#   4 = left sidebar   → index 3

# Build array of enabled DMS indexes (1-based → 0-based)
enabled=()
IFS=',' read -ra raw <<< "$ENABLED_BARS"
for v in "${raw[@]}"; do
    v="${v//[[:space:]]/}"
    [[ "$v" =~ ^[1-4]$ ]] || continue
    enabled+=("$((v - 1))")
done

# Show/hide each bar via DMS IPC
for dms_idx in 0 1 2 3; do
    if [[ " ${enabled[*]:-} " == *" $dms_idx "* ]]; then
        dms ipc call bar reveal index "$dms_idx" 2>/dev/null || true
    else
        dms ipc call bar hide index "$dms_idx" 2>/dev/null || true
    fi
done
