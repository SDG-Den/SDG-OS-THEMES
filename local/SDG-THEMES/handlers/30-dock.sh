#!/bin/bash
# 30-dock.sh — Show/hide the DMS dock
# -------------------------------------
# Sets showDock in DMS settings and reveals/hides via dock IPC.
# -------------------------------------
set -euo pipefail

[[ -z "${DOCK_ENABLED:-}" ]] && exit 0

case "$DOCK_ENABLED" in
    true|1|yes)
        dms ipc call settings set showDock true 2>/dev/null || true
        dms ipc call dock reveal 2>/dev/null || true
        ;;
    *)
        dms ipc call settings set showDock false 2>/dev/null || true
        dms ipc call dock hide 2>/dev/null || true
        ;;
esac
