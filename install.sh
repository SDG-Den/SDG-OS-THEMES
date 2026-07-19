#!/bin/bash

unipkg install any fzf
unipkg install any oldschool-pc-fonts

WORKDIR="$HOME/.cache/SDG-PKG/sdg-themes"
mkdir -p $HOME/.local/themes

cp -r "$WORKDIR/config/"* "$HOME/.config/"
cp -r "$WORKDIR/local/"* "$HOME/.local/"
cp -r "$WORKDIR/docs/"* "$HOME/.local/docs/"
cp -r "$WORKDIR/tips/"* "$HOME/.local/tips/"
cp -r "$WORKDIR/themes/"* "$HOME/.local/themes/"

chmod a+x "$HOME/.local/SDG-THEMES/themev2.sh"
chmod a+x "$HOME/.local/SDG-THEMES/sdgfont.sh"

sudo ln -sf $HOME/.local/SDG-THEMES/themev2.sh /usr/bin/sdgtheme
sudo ln -sf $HOME/.local/SDG-THEMES/sdgfont.sh /usr/bin/sdgfont

ls "$HOME/.config/SDG-THEMES/" | head -5
