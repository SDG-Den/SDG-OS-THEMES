#!/bin/bash
set -euo pipefail

SFILE="$HOME/.config/DankMaterialShell/settings.json"

# DMS UI corner radius
[[ -n "${CORNER_RADIUS:-}" ]] && dms ipc call settings set cornerRadius "$CORNER_RADIUS" 2>/dev/null || true
# mangoWM compositor window corner radius
[[ -n "${CORNER_RADIUS:-}" ]] && dms ipc call settings set mangoLayoutRadiusOverride "$CORNER_RADIUS" 2>/dev/null || true

command -v jq &>/dev/null || {
    [[ -n "${BORDER_THICKNESS:-}" || -n "${WIDGET_BORDERS:-}" ]] && echo "jq required for per-bar border settings" >&2
    exit 0
}

if [[ -n "${BORDER_THICKNESS:-}" ]]; then
    jq '(.. | objects | select(has("borderThickness")) | .borderThickness) |= '"$BORDER_THICKNESS" \
        "$SFILE" > "${SFILE}.tmp" && mv "${SFILE}.tmp" "$SFILE"
    dms ipc call settings set mangoLayoutBorderSize "$BORDER_THICKNESS" 2>/dev/null || true
fi

if [[ -n "${WIDGET_BORDERS:-}" ]]; then
    case "$WIDGET_BORDERS" in
        true|1|yes) VAL=true  ;;
        *)          VAL=false ;;
    esac
    jq '(.. | objects | select(has("widgetOutlineEnabled")) | .widgetOutlineEnabled) |= '"$VAL" \
        "$SFILE" > "${SFILE}.tmp" && mv "${SFILE}.tmp" "$SFILE"
fi
