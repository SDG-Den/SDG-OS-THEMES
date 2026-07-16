#!/bin/bash
set -euo pipefail

SFILE="$HOME/.config/DankMaterialShell/settings.json"

# Set the DMS UI corner radius
[[ -n "${CORNER_RADIUS:-}" ]] && dms ipc call settings set cornerRadius "$CORNER_RADIUS" 2>/dev/null || true

# Set the mangoWM compositor window corner radius (DMS propagates this)
[[ -n "${CORNER_RADIUS:-}" ]] && dms ipc call settings set mangoLayoutRadiusOverride "$CORNER_RADIUS" 2>/dev/null || true

# Check if jq is available — required for editing per-bar settings in the JSON
command -v jq &>/dev/null || {
    [[ -n "${BORDER_THICKNESS:-}" || -n "${WIDGET_BORDERS:-}" ]] && echo "jq required for per-bar border settings" >&2
    exit 0
}

# Walk every bar config object and set its borderThickness
if [[ -n "${BORDER_THICKNESS:-}" ]]; then
    jq '(.. | objects | select(has("borderThickness")) | .borderThickness) |= '"$BORDER_THICKNESS" \
        "$SFILE" > "${SFILE}.tmp" && mv "${SFILE}.tmp" "$SFILE"

    # Also set the compositor-level window border thickness
    dms ipc call settings set mangoLayoutBorderSize "$BORDER_THICKNESS" 2>/dev/null || true
fi

# Walk every bar config object and enable/disable its widget outline
if [[ -n "${WIDGET_BORDERS:-}" ]]; then
    case "$WIDGET_BORDERS" in
        true|1|yes) VAL=true  ;;
        *)          VAL=false ;;
    esac
    jq '(.. | objects | select(has("widgetOutlineEnabled")) | .widgetOutlineEnabled) |= '"$VAL" \
        "$SFILE" > "${SFILE}.tmp" && mv "${SFILE}.tmp" "$SFILE"
fi
