#!/bin/bash
# 05-colors.sh — Apply DMS theme colors
# ---------------------------------------
# Maps the 4 preset types (DMS / generic / matugen / path) to
# the corresponding DMS settings keys, then forces a theme
# toggle and switches to the requested light/dark mode.
# ---------------------------------------
set -euo pipefail

[[ -z "${PRESET_TYPE:-}" ]] && exit 0

# preset_type  preset_identifier  →  DMS settings
# ───────────  ─────────────────     ──────────────────────
# DMS          nord                 registry + customThemeFile
# generic      coral                generic + currentThemeName
# matugen      vibrant              dynamic + matugenScheme
# path         /custom/theme.json   registry + customThemeFile (literal path)
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

# Toggle theme twice to force a full re-apply, then switch mode
sleep 0.2
dms ipc call theme toggle 2>/dev/null || true
dms ipc call theme toggle 2>/dev/null || true
[[ -n "${MODE:-}" ]] && dms ipc call theme "$MODE" 2>/dev/null || true
