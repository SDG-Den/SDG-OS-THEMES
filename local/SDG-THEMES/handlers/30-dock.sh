#!/bin/bash
set -euo pipefail

# Skip if dock config is empty
[[ -z "${DOCK_ENABLED:-}" ]] && exit 0

# Show or hide the dock via DMS settings + IPC
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
