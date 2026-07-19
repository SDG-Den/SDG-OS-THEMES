#!/bin/bash

LOCALDIR=SDG-THEMES
DOCDIR=SDG-OS-THEMES
TIPDIR=SDG-OS-THEMES

WORKDIR=$(pwd)

rm -rf "$HOME/.local/docs/$DOCDIR" "$HOME/.local/tips/$TIPDIR" "$HOME/.local/$LOCALDIR" "$HOME/.local/themes"

mkdir -p "$HOME/.local/$LOCALDIR" "$HOME/.local/themes"
cp -r "$WORKDIR/config/"* "$HOME/.config/" 2>/dev/null || true
cp -r "$WORKDIR/local/"* "$HOME/.local/"
cp -r "$WORKDIR/docs/"* "$HOME/.local/docs/"
cp -r "$WORKDIR/tips/"* "$HOME/.local/tips/"
cp -r "$WORKDIR/themes/"* "$HOME/.local/themes/"

chmod a+x "$HOME/.local/SDG-THEMES/themev2.sh" "$HOME/.local/SDG-THEMES/sdgfont.sh"

sudo ln -sf "$HOME/.local/SDG-THEMES/themev2.sh" /usr/bin/sdgtheme
sudo ln -sf "$HOME/.local/SDG-THEMES/sdgfont.sh" /usr/bin/sdgfont
