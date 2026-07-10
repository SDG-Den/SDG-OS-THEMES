#!/bin/bash

WORKDIR="$HOME/.cache/SDG-PKG/sdg-themes"

rm -rf "$HOME/.local/SDG-THEMES"
cp -r "$WORKDIR/local/"* "$HOME/.local/"

rm -rf "$HOME/.local/docs/SDG-THEMES" "$HOME/.local/tips/SDG-OS-THEMES"
cp -r "$WORKDIR/docs/"* "$HOME/.local/docs/"
cp -r "$WORKDIR/tips/"* "$HOME/.local/tips/"

chmod a+x "$HOME/.local/SDG-THEMES/setwallpapergroup.sh"
