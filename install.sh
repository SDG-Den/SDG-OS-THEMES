#!/bin/bash

unipkg install any fzf

WORKDIR=/home/$(whoami)/.cache/SDG-PKG/sdg-themes

mkdir -p /home/$(whoami)/.config/SDG-THEMES
cp -r $WORKDIR/config/SDG-THEMES/* /home/$(whoami)/.config/SDG-THEMES

mkdir -p /home/$(whoami)/.local/SDG-THEMES
cp -r $WORKDIR/local/SDG-THEMES/* /home/$(whoami)/.local/SDG-THEMES
chmod a+x /home/$(whoami)/.local/SDG-THEMES/setwallpapergroup.sh

mkdir -p /home/$(whoami)/.local/docs /home/$(whoami)/.local/tips
cp -r $WORKDIR/docs/* /home/$(whoami)/.local/docs
cp -r $WORKDIR/tips/* /home/$(whoami)/.local/tips

ls /home/$(whoami)/.config/SDG-THEMES/ | head -5
