#!/bin/bash
# sdg-font-apply.sh — Applies the theme font to non-mangoWM targets
# Called from themev2.sh after mangoWM's sdg-font.conf is written
# Each target is checked for existence before modification

THEME_FONT="$1"

[ -z "$THEME_FONT" ] && { echo "sdg-font-apply: no font specified"; exit 1; }

echo "sdg-font-apply: applying font '$THEME_FONT'"

# ----- DMS (DankMaterialShell) -----
if command -v dms >/dev/null 2>&1; then
    dms ipc call settings set fontFamily "$THEME_FONT" 2>/dev/null
    dms ipc call settings set monoFontFamily "$THEME_FONT" 2>/dev/null
    echo "sdg-font-apply: applied font to DMS"
fi

# ----- Ghostty -----
GHOSTTY_CONF="$HOME/.config/ghostty/config"
if [ -f "$GHOSTTY_CONF" ]; then
    if grep -q "^font-family\s*=" "$GHOSTTY_CONF" 2>/dev/null; then
        sed -i "s/^font-family\s*=.*/font-family = $THEME_FONT/" "$GHOSTTY_CONF"
    else
        echo "font-family = $THEME_FONT" >> "$GHOSTTY_CONF"
    fi
    echo "sdg-font-apply: applied font to Ghostty"
fi

# ----- VSCode (code-oss or code) -----
for CODE_BIN in code-oss code; do
    if command -v "$CODE_BIN" >/dev/null 2>&1; then
        VSCODE_DIR="$HOME/.config/$CODE_BIN/User"
        VSCODE_SETTINGS="$VSCODE_DIR/settings.json"
        if [ -f "$VSCODE_SETTINGS" ]; then
            python3 -c "
import json, sys
try:
    with open('$VSCODE_SETTINGS') as f:
        s = json.load(f)
except:
    s = {}
s['editor.fontFamily'] = '$THEME_FONT'
with open('$VSCODE_SETTINGS', 'w') as f:
    json.dump(s, f, indent=4)
" 2>/dev/null && echo "sdg-font-apply: applied font to $CODE_BIN"
        fi
    fi
done

# ----- Waybar / WayShell overlays -----
WAYSHARE_CONF="$HOME/.config/SDG-WAYSHELL-CONFIGS"
if [ -d "$WAYSHARE_CONF" ]; then
    cat > "$WAYSHARE_CONF/fonts.css" <<- EOF
	@import "./theme-overrides.css";
	* {
	    font-family: "$THEME_FONT";
	    font-weight: bold;
	}
	EOF
    echo "sdg-font-apply: wrote $WAYSHARE_CONF/fonts.css"
fi

# ----- Monocle bar -----
MONOCLE_CONF="$HOME/.config/SDG-MONOCLE"
if [ -d "$MONOCLE_CONF" ]; then
    cat > "$MONOCLE_CONF/fonts.css" <<- EOF
	@import "./theme-overrides.css";
	* {
	    font-family: "$THEME_FONT";
	    font-weight: bold;
	    font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
	}
	EOF
    echo "sdg-font-apply: wrote $MONOCLE_CONF/fonts.css"
fi
