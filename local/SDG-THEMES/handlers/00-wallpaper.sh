#!/bin/bash
set -euo pipefail

# Skip if no wallpaper configured or file missing
[[ -z "${WALLPAPER:-}" || ! -f "${WALLPAPER:-}" ]] && exit 0

# Set wallpaper via DMS IPC
dms ipc call wallpaper set "$WALLPAPER" 2>/dev/null || true
sleep 0.2

# Cycle next/prev to trigger DMS image refresh
dms ipc call wallpaper next 2>/dev/null || true
dms ipc call wallpaper prev 2>/dev/null || true
