#!/bin/bash

unipkg install any fzf

WORKDIR="$HOME/.cache/SDG-PKG/sdg-themes"

cp -r "$WORKDIR/config/"* "$HOME/.config/"
cp -r "$WORKDIR/local/"* "$HOME/.local/"
cp -r "$WORKDIR/docs/"* "$HOME/.local/docs/"
cp -r "$WORKDIR/tips/"* "$HOME/.local/tips/"

chmod a+x "$HOME/.local/SDG-THEMES/setwallpapergroup.sh"

ls "$HOME/.config/SDG-THEMES/" | head -5
