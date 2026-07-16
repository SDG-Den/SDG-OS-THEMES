#!/bin/bash
set -euo pipefail

[[ -z "${WALLPAPER:-}" || ! -f "${WALLPAPER:-}" ]] && exit 0

dms ipc call wallpaper set "$WALLPAPER" 2>/dev/null || true
sleep 0.2
dms ipc call wallpaper next 2>/dev/null || true
dms ipc call wallpaper prev 2>/dev/null || true
