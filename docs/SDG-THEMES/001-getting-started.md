# Getting Started

## Keybinds

| Keybind | Action |
|---------|--------|
| SUPER+W | Open theme selector (FZF picker) |
| ALT+W | Next wallpaper in current theme group |
| ALT+SHIFT+W | Previous wallpaper in current theme group |

## CLI

```sh
sdgtheme                    # Interactive FZF picker
sdgtheme SDG-THEMES/nord    # Switch to a specific theme
sdgtheme nord               # Category-relative name works
```

## What Happens When You Switch

1. Wallpaper is set via DMS
2. `theme.conf` is sourced — all theme fields are read
3. Color scheme is applied (matugen/DMS/generic/directory)
4. Mode (dark/light), border thickness, and corner radius are set
5. mangoWM font is written to `~/.config/mango/sdg-font.conf`
6. Font is propagated to DMS, Ghostty, VSCode, Waybar, Monocle
7. Bars 0–3 are shown or hidden per `theme_bar1`–`theme_bar4`
8. Dock is revealed or hidden
9. Frame is enabled or disabled
10. Animations are enabled or disabled
11. `theme-overrides.css` is generated for Waybar/Monocle corner radius (`--theme-radius`)
12. Fastfetch logo and config are updated via `sdgfetch` (if installed)

## Cycling Within a Theme

Themes with multiple wallpapers can cycle. Pressing ALT+W/ALT+SHIFT+W cycles forward/backward.
