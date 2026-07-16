#!/bin/bash
set -euo pipefail

# Exit early if no preset type was configured
[[ -z "${PRESET_TYPE:-}" ]] && exit 0

DMS_DIR="$HOME/.config/DankMaterialShell/themes"

# Generate matugen colors from the current wallpaper
if command -v matugen-compile &>/dev/null; then
    matugen-compile 2>/dev/null || true
fi

# Determine all four settings based on preset_type, then apply them all at once.
# The old script always set every field to avoid stale values from a previous theme.

case "$PRESET_TYPE" in
    DMS|dms|Dms)
        category="registry"
        name="custom"
        matugen_scheme="scheme-tonal-sp"
        theme_file="$DMS_DIR/$PRESET_ID/theme.json"
        ;;
    generic)
        category="generic"
        name="$PRESET_ID"
        matugen_scheme="scheme-tonal-sp"
        theme_file="$DMS_DIR/-/theme.json"
        ;;
    matugen)
        category="dynamic"
        name="dynamic"
        matugen_scheme="scheme-$PRESET_ID"
        theme_file="$DMS_DIR/-/theme.json"
        ;;
    path)
        category="registry"
        name="custom"
        matugen_scheme="scheme-tonal-sp"
        theme_file="$PRESET_ID"
        ;;
esac

dms ipc call settings set currentThemeCategory "$category" 2>/dev/null || true
dms ipc call settings set currentThemeName "$name" 2>/dev/null || true
dms ipc call settings set matugenScheme "$matugen_scheme" 2>/dev/null || true
dms ipc call settings set customThemeFile "$theme_file" 2>/dev/null || true

# Wait for settings to propagate, then force a full theme re-apply
sleep 0.2
dms ipc call theme toggle 2>/dev/null || true
dms ipc call theme toggle 2>/dev/null || true

# Switch to the requested light or dark mode
[[ -n "${MODE:-}" ]] && dms ipc call theme "$MODE" 2>/dev/null || true
