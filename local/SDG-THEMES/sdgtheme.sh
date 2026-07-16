#!/bin/bash
# sdgtheme — apply a theme: wallpaper + colors + bars + frame

SELECTED="$1"; WP_DIR="$HOME/.local/themes"
WP_GROUPS=""
for CAT in $(ls "$WP_DIR" -1 2>/dev/null); do
    for THEME in $(ls "$WP_DIR/$CAT" -1 2>/dev/null); do
        WP_GROUPS="$WP_GROUPS
$CAT/$THEME"
    done
done
if [[ -z "$SELECTED" ]]; then
    SELECTED=$(echo "$WP_GROUPS" | fzf --layout=reverse)
    [[ -z "$SELECTED" ]] && exit 0
else
    SELECTED=$(echo "$WP_GROUPS" | grep -m1 "/${1}$")
    [[ -z "$SELECTED" ]] && { echo "theme '$1' not found"; exit 1; }
fi
echo "$SELECTED"

T="$WP_DIR/$SELECTED"
WALL=$(ls "$T" | grep -v ".conf" | head -1)
which matugen-compile 2>/dev/null && matugen-compile
dms ipc call wallpaper set "$T/$WALL"
sleep 0.2
dms ipc call wallpaper next; dms ipc call wallpaper prev

# parse config — works for both v1 (wallpaper.conf) and v2 (theme.conf)
C=""; U=""; M=""; MODE=""; P=""; ENABLED_BARS=""
if [[ -f "$T/wallpaper.conf" ]]; then
    C=$(grep '^Theme_Category:' "$T/wallpaper.conf" | cut -d: -f2 | xargs)
    U=$(grep '^Generic_Color:'  "$T/wallpaper.conf" | cut -d: -f2 | xargs)
    M=$(grep '^Matugen:'         "$T/wallpaper.conf" | cut -d: -f2 | xargs)
    MODE=$(grep '^Mode:'         "$T/wallpaper.conf" | cut -d: -f2 | xargs)
    P=$(grep '^Preset:'          "$T/wallpaper.conf" | cut -d: -f2 | xargs)
elif [[ -f "$T/theme.conf" ]]; then
    CFG=$(sed -n '/^\[Colors\]/,/^\[/{/^\[/d;p}' "$T/theme.conf")
    C=$(echo "$CFG" | grep '^preset_type' | cut -d= -f2 | xargs)
    U=$(echo "$CFG" | grep '^preset_identifier' | cut -d= -f2 | xargs)
    MODE=$(echo "$CFG" | grep '^mode' | cut -d= -f2 | xargs)
    BCFG=$(sed -n '/^\[Bars\]/,/^\[/{/^\[/d;p}' "$T/theme.conf")
    ENABLED_BARS=$(echo "$BCFG" | grep '^enabled_bars' | cut -d= -f2 | xargs)
fi

# map category → DMS settings
case "$C" in
    dynamic|auto)  cat="dynamic"; name="dynamic"; sch="scheme-$M"; file="$HOME/.config/DankMaterialShell/themes/-/theme.json" ;;
    registry|custom|DMS|dms) cat="registry"; name="custom"; sch="scheme-tonal-sp"; file="$HOME/.config/DankMaterialShell/themes/$U/theme.json" ;;
    generic|color) cat="generic"; name="$U"; sch="scheme-tonal-sp"; file="$HOME/.config/DankMaterialShell/themes/-/theme.json" ;;
    matugen)       cat="dynamic"; name="dynamic"; sch="scheme-$U"; file="$HOME/.config/DankMaterialShell/themes/-/theme.json" ;;
esac
dms ipc call settings set currentThemeCategory "$cat"
dms ipc call settings set currentThemeName "$name"
dms ipc call settings set matugenScheme "$sch"
dms ipc call settings set customThemeFile "$file"

sleep 0.2
dms ipc call theme toggle; dms ipc call theme toggle; dms ipc call theme "$MODE"

# bars 1-4 → DMS index 0-3, bar 5 = frame
if [[ -n "$ENABLED_BARS" ]]; then
    FRAME=false; BAR_IDX=""
    IFS=',' read -ra B <<< "$ENABLED_BARS"
    for V in "${B[@]}"; do
        V="${V// /}"
        case "$V" in
            5) FRAME=true ;;
            1|2|3|4) BAR_IDX="$BAR_IDX $((V - 1))" ;;
        esac
    done
    for I in 0 1 2 3; do
        if [[ " $BAR_IDX " == *" $I "* ]]; then dms ipc call bar reveal index "$I"
        else dms ipc call bar hide index "$I"; fi
    done
    if $FRAME; then dms ipc call settings set frameEnabled true
    else dms ipc call settings set frameEnabled false; fi
fi

sleep 0.2; mmsg dispatch reload_config
notify-send "theme $SELECTED applied"
echo "done"
