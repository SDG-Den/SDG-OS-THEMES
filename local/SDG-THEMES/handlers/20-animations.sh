#!/bin/bash
set -euo pipefail

# Exit early if animations weren't configured
[[ -z "${ANIMATIONS_ENABLED:-}" ]] && exit 0

# Apply the animation toggle to DMS settings
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
