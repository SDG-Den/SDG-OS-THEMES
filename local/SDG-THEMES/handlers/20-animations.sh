#!/bin/bash
# 20-animations.sh — Toggle DMS animations on/off
# -------------------------------------------------
# Controls two DMS settings:
#   animationSpeed        — 0 = off, 1 = normal speed
#   enableRippleEffects   — Material You ripple click feedback
# -------------------------------------------------
set -euo pipefail

[[ -z "${ANIMATIONS_ENABLED:-}" ]] && exit 0

case "$ANIMATIONS_ENABLED" in
    true|1|yes)
        dms ipc call settings set animationSpeed 1 2>/dev/null || true
        dms ipc call settings set enableRippleEffects true 2>/dev/null || true
        ;;
    *)
        dms ipc call settings set animationSpeed 0 2>/dev/null || true
        dms ipc call settings set enableRippleEffects false 2>/dev/null || true
        ;;
esac
