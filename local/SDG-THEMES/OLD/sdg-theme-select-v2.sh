#!/bin/bash

set -euo pipefail

# Toggle debug output: set DEBUG=1 to see what's being found and parsed
DEBUG="${DEBUG:-0}"

# Resolve the directory this script lives in (follows symlinks)
SELF_DIR="$(dirname "$(readlink -f "$0")")"

# ─── Paths ──────────────────────────────────────────────────

# Directories to scan for theme subdirectories
THEME_DIRS=(
    "$HOME/.local/themes"
)

# Directory for extra user-provided handler scripts
USER_HANDLER_DIR="$HOME/.config/SDG-THEMES/handlers.d"

# Pre/post hook directories — run before/after all handlers
PRE_HOOK_DIR="$HOME/.config/SDG-THEMES/pre"
POST_HOOK_DIR="$HOME/.config/SDG-THEMES/post"

# ─── Helpers ────────────────────────────────────────────────

debug() { [[ "$DEBUG" == 1 ]] && echo "[DEBUG] $*" >&2; }

# Run every *.sh in a directory, sorted alphabetically
run_scripts_in() {
    local dir="$1"
    mkdir -p "$dir"
    while IFS= read -r -d '' f; do
        debug "running: $f"
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

# Print key="value" lines from a single INI section, with values quoted for eval safety
parse_ini_section() {
    local file="$1" section="$2"
    awk -v s="[$section]" '
        $0 == s { in_section=1; next }
        /^\[.*\]/ && in_section { exit }
        in_section && /^[^#;]/ && /=/ {
            split($0, a, "=")
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", a[1])
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", a[2])
            # Strip inline comments (everything after first # or ; that follows a space or tab)
            gsub(/[[:space:]]*[#;].*$/, "", a[2])
            gsub(/[[:space:]]+$/, "", a[2])
            print a[1] "=\"" a[2] "\""
        }
    ' "$file"
}

# ─── Discovery ──────────────────────────────────────────────

# Return all available themes as "source/name|/path/to/theme"
discover_themes() {
    local results=()

    # scan a single directory for themes (one level deep)
    scan_dir() {
        local base="$1" source_name="$2"
        for dir in "$base"/*/; do
            [[ -d "$dir" ]] || continue
            local theme_name
            theme_name=$(basename "$dir")
            if [[ -f "$dir/theme.conf" ]]; then
                debug "  found v2 theme: $dir"
                results+=("$source_name/$theme_name|${dir%/}")
            elif [[ -f "$dir/wallpaper.conf" ]]; then
                debug "  found v1 theme: $dir"
                results+=("$source_name/$theme_name|${dir%/}")
            fi
        done
    }

    for base in "${THEME_DIRS[@]}"; do
        debug "checking theme base: $base"
        [[ -d "$base" ]] || { debug "  (not a directory)"; continue; }

        # If the first level contains no config files, treat subdirs as categories
        local has_direct_themes=false
        for f in "$base"/*/theme.conf "$base"/*/wallpaper.conf; do
            [[ -f "$f" ]] && { has_direct_themes=true; break; }
        done

        if $has_direct_themes; then
            scan_dir "$base" "$(basename "$base")"
        else
            # Recurse into category subdirectories
            for catdir in "$base"/*/; do
                [[ -d "$catdir" ]] || continue
                local catname
                catname=$(basename "$catdir")
                debug "  scanning category: $catname"
                scan_dir "$catdir" "$catname"
            done
        fi
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
        debug "parsing v2 config: $cfg_file"

        raw=$(parse_ini_section "$cfg_file" Theme)
        debug "  Theme: $raw"
        eval "$raw" 2>/dev/null || true
        THEME_NAME="${name:-}"
        THEME_DESC="${description:-}"
        WALLPAPER="${wallpaper:-}"
        unset name description wallpaper

        raw=$(parse_ini_section "$cfg_file" Colors)
        debug "  Colors: $raw"
        eval "$raw" 2>/dev/null || true
        PRESET_TYPE="${preset_type:-}"
        PRESET_ID="${preset_identifier:-}"
        MODE="${mode:-}"
        unset preset_type preset_identifier mode

        raw=$(parse_ini_section "$cfg_file" Fonts)
        debug "  Fonts: $raw"
        eval "$raw" 2>/dev/null || true
        FONT_FAMILY="${family:-}"
        unset family

        raw=$(parse_ini_section "$cfg_file" Borders)
        debug "  Borders: $raw"
        eval "$raw" 2>/dev/null || true
        BORDER_THICKNESS="${thickness:-}"
        CORNER_RADIUS="${corner_radius:-}"
        WIDGET_BORDERS="${widget_borders:-}"
        unset thickness corner_radius widget_borders

        raw=$(parse_ini_section "$cfg_file" Bars)
        debug "  Bars: $raw"
        eval "$raw" 2>/dev/null || true
        ENABLED_BARS="${enabled_bars:-}"
        unset enabled_bars

        raw=$(parse_ini_section "$cfg_file" Animations)
        debug "  Animations: $raw"
        eval "$raw" 2>/dev/null || true
        ANIMATIONS_ENABLED="${enabled:-}"
        unset enabled

        raw=$(parse_ini_section "$cfg_file" Dock)
        debug "  Dock: $raw"
        eval "$raw" 2>/dev/null || true
        DOCK_ENABLED="${enabled:-}"
        unset enabled

    elif [[ -f "$theme_dir/wallpaper.conf" ]]; then
        debug "parsing v1 config: $theme_dir/wallpaper.conf"

        local wc="$theme_dir/wallpaper.conf"
        local tc gk mg mo pr
        tc=$(grep -e "^Theme_Category:" "$wc" | cut -d: -f2 | xargs)
        gk=$(grep -e "^Generic_Color:" "$wc" | cut -d: -f2 | xargs)
        mg=$(grep -e "^Matugen:" "$wc" | cut -d: -f2 | xargs)
        mo=$(grep -e "^Mode:" "$wc" | cut -d: -f2 | xargs)
        pr=$(grep -e "^Preset:" "$wc" | cut -d: -f2 | xargs)

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

    debug "parsed values:"
    debug "  THEME_NAME=$THEME_NAME"
    debug "  THEME_DESC=$THEME_DESC"
    debug "  WALLPAPER=$WALLPAPER"
    debug "  PRESET_TYPE=$PRESET_TYPE  PRESET_ID=$PRESET_ID  MODE=$MODE"
    debug "  FONT_FAMILY=$FONT_FAMILY"
    debug "  BORDER_THICKNESS=$BORDER_THICKNESS  CORNER_RADIUS=$CORNER_RADIUS  WIDGET_BORDERS=$WIDGET_BORDERS"
    debug "  ENABLED_BARS=$ENABLED_BARS"
    debug "  ANIMATIONS_ENABLED=$ANIMATIONS_ENABLED"
    debug "  DOCK_ENABLED=$DOCK_ENABLED"
}

# ─── Main ───────────────────────────────────────────────────

main() {
    local selected

    # Build theme list from all configured directories
    local theme_list
    theme_list=$(discover_themes)
    if [[ -z "$theme_list" ]]; then
        echo "No themes found."
        echo "Scanned: ${THEME_DIRS[*]}"
        exit 1
    fi

    debug "available themes:"
    while IFS= read -r line; do
        debug "  ${line%|*}"
    done <<< "$theme_list"

    # Select theme — either from CLI arg or interactive fzf menu
    if [[ -n "${1:-}" ]]; then
        selected=$(echo "$theme_list" | grep -m1 "/${1}|" | cut -d'|' -f2)
        if [[ -z "$selected" ]]; then
            echo "Theme '$1' not found."
            exit 1
        fi
    else
        selected=$(show_menu "$theme_list")
        [[ -n "$selected" ]] || exit 0
    fi

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
