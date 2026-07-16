#!/bin/bash
set -euo pipefail

SFILE="$HOME/.config/DankMaterialShell/settings.json"

# Set DMS UI corner radius and mangoWM compositor window radius
[[ -n "${CORNER_RADIUS:-}" ]] && dms ipc call settings set cornerRadius "$CORNER_RADIUS" 2>/dev/null || true
[[ -n "${CORNER_RADIUS:-}" ]] && dms ipc call settings set mangoLayoutRadiusOverride "$CORNER_RADIUS" 2>/dev/null || true

# jq is required for per-bar settings (DMS IPC can't write array values)
command -v jq &>/dev/null || {
    [[ -n "${BORDER_THICKNESS:-}" || -n "${WIDGET_BORDERS:-}" ]] && echo "jq required for per-bar border settings" >&2
    exit 0
}

# Apply border thickness to every bar config + mangoWM compositor
if [[ -n "${BORDER_THICKNESS:-}" ]]; then
    jq '(.. | objects | select(has("borderThickness")) | .borderThickness) |= '"$BORDER_THICKNESS" \
        "$SFILE" > "${SFILE}.tmp" && mv "${SFILE}.tmp" "$SFILE"
    dms ipc call settings set mangoLayoutBorderSize "$BORDER_THICKNESS" 2>/dev/null || true
fi

# Toggle widget outline border on each bar
if [[ -n "${WIDGET_BORDERS:-}" ]]; then
    case "$WIDGET_BORDERS" in
        true|1|yes) VAL=true  ;;
        *)          VAL=false ;;
    esac
    jq '(.. | objects | select(has("widgetOutlineEnabled")) | .widgetOutlineEnabled) |= '"$VAL" \
        "$SFILE" > "${SFILE}.tmp" && mv "${SFILE}.tmp" "$SFILE"
fi
