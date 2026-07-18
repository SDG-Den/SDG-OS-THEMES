#!/bin/bash

FONT="$@"


# get different versions of the font:
FONTLIST=$(fc-list | cut -d: -f2)
FULLFONT=$(echo "$FONTLIST" | grep -e "$FONT" | cut -d, -f1 | head -n 1)
SHORTFONT=$(echo "$FONTLIST" | grep -e "$FONT" | cut -d, -f2 | head -n 1)
STYLEFONT=$(echo "$FONTLIST" | grep -e "$FONT" | cut -d, -f3 | head -n 1)

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
    echo "sdg-font-apply: applied font to Ghostty"
fi

# apply to vscode


# apply to... discord? 


