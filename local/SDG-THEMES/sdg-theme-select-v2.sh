#!/bin/bash

set -euo pipefail

# Resolve the directory this script lives in
SELF_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── Paths ──────────────────────────────────────────────────

# Directories to scan for theme subdirectories
THEME_DIRS=(
    "$HOME/.local/themes"
    "$HOME/.local/share/sdg-themes/modules"/*/themes
    "$HOME/.config/SDG-THEMES"
)

# Directory for extra user-provided handler scripts
USER_HANDLER_DIR="$HOME/.config/SDG-THEMES/handlers.d"

# Pre/post hook directories — run before/after all handlers
PRE_HOOK_DIR="$HOME/.config/SDG-THEMES/pre"
POST_HOOK_DIR="$HOME/.config/SDG-THEMES/post"

# ─── Helpers ────────────────────────────────────────────────

# Run every *.sh in a directory, sorted alphabetically
run_scripts_in() {
    local dir="$1"
    mkdir -p "$dir"
    while IFS= read -r -d '' f; do
        bash "$f"
    done < <(find "$dir" -maxdepth 1 -name '*.sh' -type f -print0 | sort -z)
}

# Reload mangoWM and send a desktop notification
reload_and_notify() {
    sleep 0.2
    mmsg dispatch reload_config 2>/dev/null || true
    notify-send "theme ${THEME_NAME:-$(basename "${THEME_DIR:-}")} applied" \
        "you may have to manually reload ghostty (ctrl+r)" 2>/dev/null || true
}

# Print key=value lines from a single INI section
parse_ini_section() {
    local file="$1" section="$2"
    awk -v s="[$section]" '
        $0 == s { in_section=1; next }
        /^\[.*\]/ && in_section { exit }
        in_section && /^[^#;]/ && /=/ {
            split($0, a, "=")
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", a[1])
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", a[2])
            print a[1] "=" a[2]
        }
    ' "$file"
}

# ─── Discovery ──────────────────────────────────────────────

# Return all available themes as "source/name|/path/to/theme"
discover_themes() {
    local results=()
    for base in "${THEME_DIRS[@]}"; do
        [[ -d "$base" ]] || continue
        local source_name
        source_name=$(basename "$base")
        for dir in "$base"/*/; do
            [[ -f "$dir/theme.conf" ]] || [[ -f "$dir/wallpaper.conf" ]] || continue
            local theme_name
            theme_name=$(basename "$dir")
            results+=("$source_name/$theme_name|$dir")
        done
    done
    printf '%s\n' "${results[@]}"
}

# ─── Menu ───────────────────────────────────────────────────

# Open fzf to pick a theme, showing config preview
show_menu() {
    local theme_list="$1"
    local selected_raw
    selected_raw=$(echo "$theme_list" | fzf --layout=reverse \
        --with-nth=1 --delimiter='|' \
        --preview='cfg={2}/theme.conf; [ -f "$cfg" ] && head -20 "$cfg" || echo "legacy wallpaper.conf only"')
    echo "${selected_raw#*|}"
}

# ─── Parser ─────────────────────────────────────────────────

# Read the config file and populate global vars for every field
parse_config() {
    local theme_dir="$1"
    local cfg_file="$theme_dir/theme.conf"

    if [[ -f "$cfg_file" ]]; then
        # Parse v2 INI config — extract each section
        local raw

        raw=$(parse_ini_section "$cfg_file" Theme)
        eval "$raw" 2>/dev/null || true
        THEME_NAME="${name:-}"
        THEME_DESC="${description:-}"
        WALLPAPER="${wallpaper:-}"

        raw=$(parse_ini_section "$cfg_file" Colors)
        eval "$raw" 2>/dev/null || true
        PRESET_TYPE="${preset_type:-}"
        PRESET_ID="${preset_identifier:-}"
        MODE="${mode:-}"

        raw=$(parse_ini_section "$cfg_file" Fonts)
        eval "$raw" 2>/dev/null || true
        FONT_FAMILY="${family:-}"

        raw=$(parse_ini_section "$cfg_file" Borders)
        eval "$raw" 2>/dev/null || true
        BORDER_THICKNESS="${thickness:-}"
        CORNER_RADIUS="${corner_radius:-}"
        WIDGET_BORDERS="${widget_borders:-}"

        raw=$(parse_ini_section "$cfg_file" Bars)
        eval "$raw" 2>/dev/null || true
        ENABLED_BARS="${enabled_bars:-}"

        raw=$(parse_ini_section "$cfg_file" Animations)
        eval "$raw" 2>/dev/null || true
        ANIMATIONS_ENABLED="${enabled:-}"

        raw=$(parse_ini_section "$cfg_file" Dock)
        eval "$raw" 2>/dev/null || true
        DOCK_ENABLED="${enabled:-}"

    elif [[ -f "$theme_dir/wallpaper.conf" ]]; then
        # Fall back to v1 wallpaper.conf — read 5 flat fields
        local wc="$theme_dir/wallpaper.conf"
        local tc gk mg mo pr
        tc=$(grep -e "^Theme_Category:" "$wc" | cut -d: -f2 | xargs)
        gk=$(grep -e "^Generic_Color:" "$wc" | cut -d: -f2 | xargs)
        mg=$(grep -e "^Matugen:" "$wc" | cut -d: -f2 | xargs)
        mo=$(grep -e "^Mode:" "$wc" | cut -d: -f2 | xargs)
        pr=$(grep -e "^Preset:" "$wc" | cut -d: -f2 | xargs)

        # v1 themes don't have v2-only fields — blank them all
        WALLPAPER=""
        FONT_FAMILY=""
        BORDER_THICKNESS=""
        CORNER_RADIUS=""
        WIDGET_BORDERS=""
        ENABLED_BARS=""
        ANIMATIONS_ENABLED=""
        DOCK_ENABLED=""
        THEME_NAME=""
        THEME_DESC=""
        MODE="$mo"

        # Translate v1 Theme_Category into v2 preset_type
        case "$tc" in
            dynamic|auto)
                PRESET_TYPE="matugen"
                PRESET_ID="$mg"
                ;;
            registry|custom)
                PRESET_TYPE="DMS"
                PRESET_ID="$pr"
                ;;
            generic|color)
                PRESET_TYPE="generic"
                PRESET_ID="$gk"
                ;;
            *)
                PRESET_TYPE=""
                PRESET_ID=""
                ;;
        esac
    fi

    # Prepend theme dir to relative wallpaper paths
    if [[ -n "$WALLPAPER" && ! "$WALLPAPER" = /* ]]; then
        WALLPAPER="$theme_dir/$WALLPAPER"
    fi

    # Fall back to first image found in the theme directory
    if [[ -z "$WALLPAPER" ]]; then
        WALLPAPER=$(find "$theme_dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | head -1 || true)
    fi

    THEME_DIR="$theme_dir"
}

# ─── Main ───────────────────────────────────────────────────

main() {
    local selected

    # Build theme list from all configured directories
    local theme_list
    theme_list=$(discover_themes)
    if [[ -z "$theme_list" ]]; then
        echo "No themes found."
        exit 1
    fi

    # Select theme — either from CLI arg or interactive fzf menu
    if [[ -n "${1:-}" ]]; then
        selected=$(echo "$theme_list" | grep -m1 "/${1}$" | cut -d'|' -f2)
        if [[ -z "$selected" ]]; then
            echo "Theme '$1' not found."
            exit 1
        fi
    else
        selected=$(show_menu "$theme_list")
    fi
    [[ -n "$selected" ]] || exit 0

    echo "Selected: $(basename "$selected")"

    # Parse config and export everything for child scripts
    parse_config "$selected"
    export THEME_DIR THEME_NAME THEME_DESC
    export WALLPAPER
    export PRESET_TYPE PRESET_ID MODE
    export FONT_FAMILY
    export BORDER_THICKNESS CORNER_RADIUS WIDGET_BORDERS
    export ENABLED_BARS
    export ANIMATIONS_ENABLED
    export DOCK_ENABLED

    # Run pre hooks, then bundled handlers, then user handlers, then post hooks, then reload
    run_scripts_in "$PRE_HOOK_DIR"
    run_scripts_in "$SELF_DIR/handlers"
    run_scripts_in "$USER_HANDLER_DIR"
    run_scripts_in "$POST_HOOK_DIR"
    reload_and_notify
}

main "$@"
