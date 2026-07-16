#!/bin/bash
set -euo pipefail

# Skip if animations not configured
[[ -z "${ANIMATIONS_ENABLED:-}" ]] && exit 0

# Enable or disable DMS animation speed and ripple effects
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
