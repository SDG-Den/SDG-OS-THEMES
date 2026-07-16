#!/bin/bash
# 15-borders.sh — Set corner radius, bar borders, and widget outlines
# --------------------------------------------------------------------
# Controls three visual layers:
#   1. DMS UI corner radius (global) + mangoWM compositor corners
#   2. Per-bar border thickness via jq + mangoWM compositor border size
#   3. Per-bar widget outline (border around individual bar widgets)
#
# Per-bar settings require jq to edit barConfigs[] in settings.json
# since DMS IPC can't set array/object values directly.
# --------------------------------------------------------------------
set -euo pipefail

SFILE="$HOME/.config/DankMaterialShell/settings.json"

# DMS UI corner radius — affects panels, popups, menus
[[ -n "${CORNER_RADIUS:-}" ]] && dms ipc call settings set cornerRadius "$CORNER_RADIUS" 2>/dev/null || true
# mangoWM compositor window corner radius — DMS propagates this automatically
[[ -n "${CORNER_RADIUS:-}" ]] && dms ipc call settings set mangoLayoutRadiusOverride "$CORNER_RADIUS" 2>/dev/null || true

command -v jq &>/dev/null || {
    [[ -n "${BORDER_THICKNESS:-}" || -n "${WIDGET_BORDERS:-}" ]] && echo "jq required for per-bar border settings" >&2
    exit 0
}

# Per-bar border thickness — applies to every bar config in the array
if [[ -n "${BORDER_THICKNESS:-}" ]]; then
    jq '(.. | objects | select(has("borderThickness")) | .borderThickness) |= '"$BORDER_THICKNESS" \
        "$SFILE" > "${SFILE}.tmp" && mv "${SFILE}.tmp" "$SFILE"
    # Compositor-level window border (mangoWM borderpx)
    dms ipc call settings set mangoLayoutBorderSize "$BORDER_THICKNESS" 2>/dev/null || true
fi

# Per-bar widget outline toggle — border drawn around each widget
if [[ -n "${WIDGET_BORDERS:-}" ]]; then
    case "$WIDGET_BORDERS" in
        true|1|yes) VAL=true  ;;
        *)          VAL=false ;;
    esac
    jq '(.. | objects | select(has("widgetOutlineEnabled")) | .widgetOutlineEnabled) |= '"$VAL" \
        "$SFILE" > "${SFILE}.tmp" && mv "${SFILE}.tmp" "$SFILE"
fi
