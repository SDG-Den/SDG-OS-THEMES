#!/bin/bash
set -u
ROOT="/home/den/ownCloud/SDG-OS-V2/SDG-OS-THEMES/themes"

declare -A DMS_MAP=(
    [acer]=acerpredator
    [alienware]=alienware
    [AMOLED]=amoledBlack
    [aorus]=gigabyteaorus
    [catppuccin]=catppuccin
    [catppuccin-latte]=catppuccin
    [dell]=dellxps
    [everforest]=everforest
    [flexoki]=flexoki
    [framework]=framework
    [gruvbox]=gruvboxMaterial
    [hpspectre]=hpspectre
    [mac]=macbook
    [modus]=modus
    [msi-creator]=msicreator
    [msi-dragon]=msigaming
    [nord]=nord
    [omen]=hpomen
    [razer]=razer
    [retro-82]=retrobox
    [ROG]=asusrog
    [rose-pine]=rosePine
    [steamdeck]=steamDeck
    [system76]=system76
    [terminal]=terminal
    [terminal-blue]=terminal-mono
    [terminal-monochrome]=terminal-mono
    [thinkpad]=thinkpad
    [tokyo-night]=tokyoNight
    [yoga]=yoga
    [zenbook]=zenbook
)

declare -A MODE_OVERRIDES=( [snow]=light [catppuccin-latte]=light )

declare -A FONT_OVERRIDES=(
    [terminal]="Ac437 IBM EGA 8x8"
    [terminal-blue]="Ac437 IBM EGA 8x8"
    [terminal-monochrome]="Ac437 IBM EGA 8x8"
    [retro-82]="Ubuntu Nerd Font"
)

declare -A CORNER_OVERRIDES=(
    [terminal]=0 [terminal-blue]=0 [terminal-monochrome]=0 [retro-82]=0 [AMOLED]=12
)

declare -A BARS_OVERRIDES=(
    [terminal]=4 [terminal-blue]=4 [terminal-monochrome]=4
)

declare -A ANIM_OVERRIDES=(
    [terminal]=false [terminal-blue]=false [terminal-monochrome]=false
)

declare -A DOCK_OVERRIDES=( [mac]=true )

generate_config() {
    local name="$1" dir="$2"
    local dms_id="${DMS_MAP[$name]:-}"
    local preset_type="matugen" preset_id="vibrant"
    [[ -n "$dms_id" ]] && { preset_type="DMS"; preset_id="$dms_id"; }
    local mode="${MODE_OVERRIDES[$name]:-dark}"
    local font="${FONT_OVERRIDES[$name]:-JetBrainsMono Nerd Font}"
    local radius="${CORNER_OVERRIDES[$name]:-8}"
    local bars="${BARS_OVERRIDES[$name]:-1}"
    local anim="${ANIM_OVERRIDES[$name]:-true}"
    local dock="${DOCK_OVERRIDES[$name]:-false}"

    local wallpaper=""
    for ext in jpg png jpeg; do
        local img
        img=$(find "$dir" -maxdepth 1 -name "*.$ext" -type f 2>/dev/null | head -1 || true)
        if [[ -n "$img" ]]; then
            wallpaper=$(basename "$img")
            break
        fi
    done

    cat > "$dir/theme.conf" << EOF
[Theme]
name = $name
description = ${name} theme
wallpaper = ${wallpaper:-wallpaper.png}

[Colors]
preset_type = $preset_type
preset_identifier = $preset_id
mode = $mode

[Fonts]
family = $font

[Borders]
thickness = 2
corner_radius = $radius
widget_borders = false

[Bars]
enabled_bars = $bars

[Animations]
enabled = $anim

[Dock]
enabled = $dock
EOF
    echo "  $name/theme.conf  ${preset_type}/${preset_id}  bar=$bars  mode=$mode"
}

count=0
for category in "$ROOT"/*/; do
    catname=$(basename "$category")
    for themedir in "$category"*/; do
        name=$(basename "$themedir")
        # Skip v2-only dirs being merged into their v1 counterparts
        [[ "$name" == "default-v2" || "$name" == "terminal-v2" ]] && continue
        generate_config "$name" "${themedir%/}"
        ((count++)) || true
    done
done

echo "Done — ${count} theme.conf files written to repo."
