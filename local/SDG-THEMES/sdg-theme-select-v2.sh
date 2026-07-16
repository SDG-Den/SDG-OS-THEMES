#!/bin/bash
# ============================================================
# sdg-theme-select-v2.sh — Theme selector for SDG-OS
# ============================================================
# Scans multiple theme directories, shows an interactive menu,
# parses the selected theme.conf, and dispatches each setting
# to handler scripts in the handlers/ directory.
#
# Modules can add themes by dropping directories under
# ~/.local/share/sdg-themes/modules/<name>/themes/<theme>/
# and extra handlers under ~/.config/SDG-THEMES/handlers.d/
#
# Pre/post hooks in ~/.config/SDG-THEMES/pre/ and
# ~/.config/SDG-THEMES/post/ wrap the dispatch phase and
# receive all parsed config values as environment variables.
# ============================================================

set -euo pipefail

# Resolve the directory where this script lives, so we can
# find the bundled handlers/ directory regardless of how
# the script was invoked.
SELF_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── Paths ──────────────────────────────────────────────────

# Theme sources in order of precedence.  Each directory is
# scanned for subdirectories that contain theme.conf or
# wallpaper.conf.
THEME_DIRS=(
    "$HOME/.local/themes"
    "$HOME/.local/share/sdg-themes/modules"/*/themes
    "$HOME/.config/SDG-THEMES"
)

# User-provided extra handlers (run after built-in handlers
# but before post hooks).
USER_HANDLER_DIR="$HOME/.config/SDG-THEMES/handlers.d"

# Hook directories — every *.sh in these gets run.
# Pre hooks execute before any handlers, post hooks after.
PRE_HOOK_DIR="$HOME/.config/SDG-THEMES/pre"
POST_HOOK_DIR="$HOME/.config/SDG-THEMES/post"

# ─── Helpers ────────────────────────────────────────────────

# Run every *.sh in a directory, sorted alphabetically.
# The numeric NN- prefix on handler filenames sets the order.
run_scripts_in() {
    local dir="$1"
    mkdir -p "$dir"
    while IFS= read -r -d '' f; do
        bash "$f"
    done < <(find "$dir" -maxdepth 1 -name '*.sh' -type f -print0 | sort -z)
}

# Reload mangoWM config and send a desktop notification.
# Called last, after all handlers and hooks have finished.
reload_and_notify() {
    sleep 0.2
    mmsg dispatch reload_config 2>/dev/null || true
    notify-send "theme ${THEME_NAME:-$(basename "${THEME_DIR:-}")} applied" \
        "you may have to manually reload ghostty (ctrl+r)" 2>/dev/null || true
}

# Extract key=value pairs from a single INI-style section.
# For example, parse_ini_section "theme.conf" "Colors" prints
#   preset_type=DMS
#   preset_identifier=nord
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

# Walk every theme directory and list all valid themes.
# Returns lines of the form "source/name|/full/path".
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

# Present the theme list via fzf.  The preview pane shows the
# first 20 lines of theme.conf (or a note for legacy themes).
show_menu() {
    local theme_list="$1"
    local selected_raw
    selected_raw=$(echo "$theme_list" | fzf --layout=reverse \
        --with-nth=1 --delimiter='|' \
        --preview='cfg={2}/theme.conf; [ -f "$cfg" ] && head -20 "$cfg" || echo "legacy wallpaper.conf only"')
    echo "${selected_raw#*|}"
}

# ─── Parser ─────────────────────────────────────────────────

# Parse theme.conf (v2) or wallpaper.conf (v1 fallback) and
# set global variables for every config field.  Variables that
# are absent in the config default to empty string, which
# signals handlers to skip.
parse_config() {
    local theme_dir="$1"
    local cfg_file="$theme_dir/theme.conf"

    if [[ -f "$cfg_file" ]]; then
        # ── v2 config ──
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
        # ── v1 fallback — map wallpaper.conf to v2 fields ──
        local wc="$theme_dir/wallpaper.conf"
        local tc gk mg mo pr
        tc=$(grep -e "^Theme_Category:" "$wc" | cut -d: -f2 | xargs)
        gk=$(grep -e "^Generic_Color:" "$wc" | cut -d: -f2 | xargs)
        mg=$(grep -e "^Matugen:" "$wc" | cut -d: -f2 | xargs)
        mo=$(grep -e "^Mode:" "$wc" | cut -d: -f2 | xargs)
        pr=$(grep -e "^Preset:" "$wc" | cut -d: -f2 | xargs)

        # v1 themes don't set any of the v2-only fields
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

        # Translate v1 categories into v2 preset_type
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

    # If wallpaper is a relative path, resolve it against the
    # theme directory.  If still empty, pick the first image
    # found in the theme directory.
    if [[ -n "$WALLPAPER" && ! "$WALLPAPER" = /* ]]; then
        WALLPAPER="$theme_dir/$WALLPAPER"
    fi
    if [[ -z "$WALLPAPER" ]]; then
        WALLPAPER=$(find "$theme_dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | head -1 || true)
    fi

    THEME_DIR="$theme_dir"
}

# ─── Main ───────────────────────────────────────────────────

main() {
    local selected

    # 1. Discover all available themes
    local theme_list
    theme_list=$(discover_themes)
    if [[ -z "$theme_list" ]]; then
        echo "No themes found."
        exit 1
    fi

    # 2. Present the interactive menu, or skip straight to a
    #    theme if one was passed as a CLI argument.
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

    # 3. Parse the theme config and export every field as an
    #    environment variable so child scripts can read them.
    parse_config "$selected"
    export THEME_DIR THEME_NAME THEME_DESC
    export WALLPAPER
    export PRESET_TYPE PRESET_ID MODE
    export FONT_FAMILY
    export BORDER_THICKNESS CORNER_RADIUS WIDGET_BORDERS
    export ENABLED_BARS
    export ANIMATIONS_ENABLED
    export DOCK_ENABLED

    # 4. Dispatch in order:
    #    pre hooks → built-in handlers → user handlers → post hooks → reload
    run_scripts_in "$PRE_HOOK_DIR"
    run_scripts_in "$SELF_DIR/handlers"
    run_scripts_in "$USER_HANDLER_DIR"
    run_scripts_in "$POST_HOOK_DIR"
    reload_and_notify
}

main "$@"
