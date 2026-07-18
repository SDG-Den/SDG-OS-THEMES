# Overview

SDG-OS-THEMES manages visual themes through `sdgtheme`. Each theme is a directory under `~/.local/themes/<category>/<name>/` containing a wallpaper image and a `theme.conf` that defines the full look: color scheme, mode, font, bar layout, dock, frame, animations, corner radius, and fastfetch logo.

When you select a theme, the system:
1. Sets the wallpaper
2. Applies colors via Matugen (dynamic) or DMS presets
3. Sets dark/light mode
4. Configures mangoWM borders, radius, animations, font
5. Reveals/hides bars and dock
6. Enables/disables frame
7. Propagates font to DMS, Ghostty, VSCode, Waybar, Monocle
8. Generates `theme-overrides.css` for Waybar/Monocle corner radius
9. Updates fastfetch logo and config via `sdgfetch`
