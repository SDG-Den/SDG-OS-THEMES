#!/bin/bash
set -euo pipefail

[[ -z "${ENABLED_BARS:-}" ]] && exit 0
command -v jq &>/dev/null || { echo "jq required for bar settings" >&2; exit 0; }

SFILE="$HOME/.config/DankMaterialShell/settings.json"
CONDITIONS=()

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

IFS=" or "
jq '.barConfigs |= map(.visible = (if '"${CONDITIONS[*]}"' then true else false end))' \
    "$SFILE" > "${SFILE}.tmp" && mv "${SFILE}.tmp" "$SFILE"
unset IFS
