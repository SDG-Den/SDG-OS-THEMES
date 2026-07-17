#!/bin/bash

WORKDIR="$HOME/.cache/SDG-PKG/sdg-themes"
mkdir -p $HOME/.local/themes
rm -rf "$HOME/.local/SDG-THEMES"
cp -r "$WORKDIR/local/"* "$HOME/.local/"

rm -rf "$HOME/.local/docs/SDG-THEMES" "$HOME/.local/tips/SDG-OS-THEMES"
cp -r "$WORKDIR/docs/"* "$HOME/.local/docs/"
cp -r "$WORKDIR/tips/"* "$HOME/.local/tips/"

rm -rf "$HOME/.local/themes/SDG-THEMES" "$HOME/.local/themes/SDG-THEMES-BRANDS/" "$HOME/.local/themes/SDG-THEMES-DESTINY" "$HOME/.local/themes/SDG-THEMES-FUN"
cp -r "$WORKDIR/themes/"* "$HOME/.local/themes/"
sudo ln -sf $HOME/.local/SDG-THEMES/themev2.sh /usr/bin/sdgtheme

chmod a+x "$HOME/.local/SDG-THEMES/setwallpapergroup.sh"
