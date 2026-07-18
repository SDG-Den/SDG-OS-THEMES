#!/bin/bash

FONT="$@"


# get different versions of the font:
FONTLIST=$(fc-list | cut -d: -f2)
FULLFONT=$(echo "$FONTLIST" | grep -e "$FONT" | cut -d, -f1 | head -n 1 | sed 's/^ //')
SHORTFONT=$(echo "$FONTLIST" | grep -e "$FONT" | cut -d, -f2 | head -n 1| sed 's/^ //')
STYLEFONT=$(echo "$FONTLIST" | grep -e "$FONT" | cut -d, -f3 | head -n 1| sed 's/^ //')

echo " [sdgfont] applying following font:"
echo "input: $FONT"
echo ""
echo "detected fontname (full): $FULLFONT"
echo "detected fontname (short): $SHORTFONT"
echo "detected fontname (with styles): $STYLEFONT"
echo ""


# apply to mango
cat > "$HOME/.config/mango/font-override.conf" <<- EOF

group_bar_decorate_font_desc= $FULLFONT 12
jump_label_decorate_font_desc= $FULLFONT 20

EOF


# apply to DMS

dms ipc call settings set fontFamily "$FULLFONT"
dms ipc call settings set monoFontFamily "$FULLFONT"

# apply to wayshell
RADIUS_CSS_DIR="$HOME/.config/SDG-WAYSHELL-CONFIGS"
mkdir -p "$RADIUS_CSS_DIR"
cat > "$RADIUS_CSS_DIR/font-override.css" <<- EOF
	* {
	    font-family: "$FULLFONT";
	}
	EOF
MONOCLE_CSS_DIR="$HOME/.config/SDG-MONOCLE"
if [ -d "$MONOCLE_CSS_DIR" ]; then
    cat > "$MONOCLE_CSS_DIR/font-override.css" <<- EOF
	* {
	    font-family: "$FULLFONT";
	}
	EOF
fi

# apply to ghostty
GHOSTTY_CONF="$HOME/.config/ghostty/config.ghostty"
if [ -f "$GHOSTTY_CONF" ]; then
    if grep -q "^font-family\s*=" "$GHOSTTY_CONF" 2>/dev/null; then
        sed -i "s/^font-family\s*=.*/font-family = $FULLFONT/" "$GHOSTTY_CONF"
    else
        echo "font-family = $FULLFONT" >> "$GHOSTTY_CONF"
    fi
fi

# apply to vscode
VSCODE_CONF="$HOME/.config/Code - OSS/User/settings.json"
if [ -f "$VSCODE_CONF" ]; then
    if grep -q "\"editor.fontFamily\":" "$VSCODE_CONF"; then
        sed -i "s/\"editor.fontFamily\": \".*\"/\"editor.fontFamily\": \"\'$FULLFONT\', monospace\"/" "$VSCODE_CONF"
        echo "vscode applied"
    fi
fi

# apply to gtk
gsettings set org.gnome.desktop.interface font-name "$FULLFONT"

# apply to firefox

MOZ_DIR="$HOME/.config/mozilla/firefox"
MOZ_PROFILE=$(cat $MOZ_DIR/profiles.ini | grep -e "^Default=.*" | cut -d= -f2)
MOZ_USERFILE="$MOZ_DIR/$MOZ_PROFILE/user.js"
if [ -f "$MOZ_USERFILE" ]; then
    if grep -q "user_pref(\"font.name.monospace.x-western\"," "$MOZ_USERFILE"; then
        sed -i "s/user_pref(\"font.name.monospace.x-western\", \".*\");/s/user_pref(\"font.name.monospace.x-western\", \"$FULLFONT\");" "$MOZ_USERFILE"
    fi
    if grep -q "user_pref(\"font.name.sans-serif.x-western\"," "$MOZ_USERFILE"; then
        sed -i "s/user_pref(\"font.name.sans-serif.x-western\", \".*\");/s/user_pref(\"font.name.sans-serif.x-western\", \"$FULLFONT\");" "$MOZ_USERFILE"
    fi
    if grep -q "user_pref(\"font.name.serif.x-western\"," "$MOZ_USERFILE"; then
        sed -i "s/user_pref(\"font.name.serif.x-western\", \".*\");/s/user_pref(\"font.name.serif.x-western\", \"$FULLFONT\");" "$MOZ_USERFILE"
    fi
else
    cat > "$MOZ_USERFILE" <<- EOF
user_pref("font.name.monospace.x-western", "$FULLFONT");
user_pref("font.name.sans-serif.x-western", "$FULLFONT");
user_pref("font.name.serif.x-western", "$FULLFONT");
EOF



