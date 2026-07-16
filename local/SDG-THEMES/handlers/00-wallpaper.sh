#!/bin/bash
# 00-wallpaper.sh — Set the desktop wallpaper via DMS IPC
# -----------------------------------------------------------
# Receives WALLPAPER from the environment (absolute path).
# Sets the image, then cycles next/prev to force a refresh.
# -----------------------------------------------------------
set -euo pipefail

# Skip if no wallpaper is configured or the file doesn't exist
[[ -z "${WALLPAPER:-}" || ! -f "${WALLPAPER:-}" ]] && exit 0

dms ipc call wallpaper set "$WALLPAPER" 2>/dev/null || true
sleep 0.2
dms ipc call wallpaper next 2>/dev/null || true
dms ipc call wallpaper prev 2>/dev/null || true
