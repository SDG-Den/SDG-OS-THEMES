#!/bin/bash
set -euo pipefail

sleep 0.2
mmsg dispatch reload_config 2>/dev/null || true
notify-send "theme ${THEME_NAME:-$(basename "${THEME_DIR:-}")} applied" \
    "you may have to manually reload ghostty (ctrl+r)" 2>/dev/null || true
