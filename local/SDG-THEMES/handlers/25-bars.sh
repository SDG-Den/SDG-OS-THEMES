#!/bin/bash
# 25-bars.sh — Show/hide DMS bars by position
# ---------------------------------------------
# Maps position names (top, bottom, left, right) to DMS bar
# position IDs (0-3) and toggles barConfigs[].visible via jq.
#
# Only bars whose position appears in ENABLED_BARS are shown.
# All others are hidden.  Requires jq.
# ---------------------------------------------
set -euo pipefail

[[ -z "${ENABLED_BARS:-}" ]] && exit 0
command -v jq &>/dev/null || { echo "jq required for bar settings" >&2; exit 0; }

SFILE="$HOME/.config/DankMaterialShell/settings.json"
CONDITIONS=()

# Build a list of jq conditions for each enabled bar position
for bar in top bottom left right; do
    if echo "$ENABLED_BARS" | grep -qw "$bar"; then
        case "$bar" in
            top)    CONDITIONS+=(".position == 0") ;;
            bottom) CONDITIONS+=(".position == 1") ;;
            left)   CONDITIONS+=(".position == 2") ;;
            right)  CONDITIONS+=(".position == 3") ;;
        esac
    fi
done

[[ ${#CONDITIONS[@]} -eq 0 ]] && exit 0

# Join conditions with " or " and apply — any bar matching at
# least one enabled position gets visible=true, the rest false.
IFS=" or "
jq '.barConfigs |= map(.visible = (if '"${CONDITIONS[*]}"' then true else false end))' \
    "$SFILE" > "${SFILE}.tmp" && mv "${SFILE}.tmp" "$SFILE"
unset IFS
