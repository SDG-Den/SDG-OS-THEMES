#!/bin/bash
set -euo pipefail

# Exit early if no preset type was configured
[[ -z "${PRESET_TYPE:-}" ]] && exit 0

# Map preset_type to the corresponding DMS settings keys
case "$PRESET_TYPE" in
    DMS)
        dms ipc call settings set currentThemeCategory registry 2>/dev/null || true
        dms ipc call settings set currentThemeName custom 2>/dev/null || true
        dms ipc call settings set customThemeFile "$HOME/.config/DankMaterialShell/themes/$PRESET_ID/theme.json" 2>/dev/null || true
        ;;
    generic)
        dms ipc call settings set currentThemeCategory generic 2>/dev/null || true
        dms ipc call settings set currentThemeName "$PRESET_ID" 2>/dev/null || true
        ;;
    matugen)
        dms ipc call settings set currentThemeCategory dynamic 2>/dev/null || true
        dms ipc call settings set currentThemeName dynamic 2>/dev/null || true
        dms ipc call settings set matugenScheme "scheme-$PRESET_ID" 2>/dev/null || true
        ;;
    path)
        dms ipc call settings set currentThemeCategory registry 2>/dev/null || true
        dms ipc call settings set currentThemeName custom 2>/dev/null || true
        dms ipc call settings set customThemeFile "$PRESET_ID" 2>/dev/null || true
        ;;
esac

# Wait for settings to propagate, then force a full theme re-apply
sleep 0.2
dms ipc call theme toggle 2>/dev/null || true
dms ipc call theme toggle 2>/dev/null || true

# Switch to the requested light or dark mode
[[ -n "${MODE:-}" ]] && dms ipc call theme "$MODE" 2>/dev/null || true
