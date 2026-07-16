#!/bin/bash
set -euo pipefail

# Exit early if bar config is empty
[[ -z "${ENABLED_BARS:-}" ]] && exit 0

# jq is required to edit barConfigs[] in the settings JSON
command -v jq &>/dev/null || { echo "jq required for bar settings" >&2; exit 0; }

SFILE="$HOME/.config/DankMaterialShell/settings.json"
CONDITIONS=()

# Build jq position conditions for each enabled bar (0=top, 1=bottom, 2=left, 3=right)
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

# Exit if none of the four positions matched
[[ ${#CONDITIONS[@]} -eq 0 ]] && exit 0

# Join conditions with "or" and apply — bars matching a position get visible=true, others false
IFS=" or "
jq '.barConfigs |= map(.visible = (if '"${CONDITIONS[*]}"' then true else false end))' \
    "$SFILE" > "${SFILE}.tmp" && mv "${SFILE}.tmp" "$SFILE"
unset IFS
