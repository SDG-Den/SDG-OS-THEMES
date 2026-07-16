#!/bin/bash
set -euo pipefail

# Skip if no wallpaper path was provided or the file doesn't exist
[[ -z "${WALLPAPER:-}" || ! -f "${WALLPAPER:-}" ]] && exit 0

# Tell DMS to switch to the new wallpaper image
dms ipc call wallpaper set "$WALLPAPER" 2>/dev/null || true
sleep 0.2

# Cycle forward then back to force DMS to reload the image
dms ipc call wallpaper next 2>/dev/null || true
dms ipc call wallpaper prev 2>/dev/null || true
