# Test Checklist — SDG-OS-THEMES

## Commands
- [ ] `sdgtheme <category/theme>` — applies theme (wallpaper, colors, bars, dock, frame, font, corner radius, fastfetch)
- [ ] `sdgtheme` with no args — opens FZF picker to select theme
- [ ] `sdgtheme` symlinked to `/usr/bin/sdgtheme` — works

## Theme Application
- [ ] Wallpaper displays on all monitors
- [ ] Matugen extracts colors that match the wallpaper (dynamic themes)
- [ ] DMS theme updates with new colors (registry/custom themes)
- [ ] Generic color themes apply fixed color (generic themes)
- [ ] `theme_mode` dark/light applied correctly
- [ ] `theme_border_thickness` applied to mangoWM borders
- [ ] `theme_corner_radius` applied to mangoWM and Waybar/Monocle CSS

## Bars
- [ ] `theme_bar1` true → bar 0 is revealed
- [ ] `theme_bar1` false → bar 0 is hidden
- [ ] `theme_bar2` true → bar 1 is revealed
- [ ] `theme_bar2` false → bar 1 is hidden
- [ ] Same for bar3, bar4

## Dock
- [ ] `theme_dock=true` → dock shown
- [ ] `theme_dock=false` → dock hidden

## Frame
- [ ] `theme_frame=true` → frame enabled
- [ ] `theme_frame=false` → frame disabled

## Animations
- [ ] `theme_animations=0` → mangoWM animations disabled
- [ ] `theme_animations=1` → mangoWM animations enabled

## Font
- [ ] mangoWM font set in `~/.config/mango/sdg-font.conf`
- [ ] DMS font updated (if installed)
- [ ] Ghostty config updated (if installed)
- [ ] VSCode font updated (if installed)
- [ ] Waybar/Monocle CSS font updated (if configs installed)
- [ ] Font skip works: `apply_font=false` in `~/.config/SDG-THEMES/sdg-themes.conf`

## Corner Radius CSS
- [ ] `theme-overrides.css` generated in `~/.config/SDG-WAYSHELL-CONFIGS/`
- [ ] `theme-overrides.css` generated in `~/.config/SDG-MONOCLE/` (if dir exists)
- [ ] CSS files import `theme-overrides.css`
- [ ] `var(--theme-radius, 10px)` fallback works when file absent

## Fastfetch
- [ ] `sdgfetch setlogo` called with `theme_fetch_logo` value
- [ ] `sdgfetch setconf` called with `theme_fetch_conf` value
- [ ] Fastfetch skip works: `apply_fastfetch=false` in config
- [ ] Graceful if `sdgfetch` not installed

## Config File
- [ ] `~/.config/SDG-THEMES/sdg-themes.conf` sourced if present
- [ ] Missing config file doesn't error

## Scripts
- [ ] `install.sh` copies all dirs (config/, local/, docs/, tips/, themes/)
- [ ] `install.sh` makes `sdg-font-apply.sh` executable
- [ ] `update.sh` copies config/, local/, docs/, tips/, themes/
- [ ] `update.sh` makes `sdg-font-apply.sh` executable
- [ ] `uninstall.sh` cleans up all installed files and symlink

## Theme Conf Fields (per `themes/*/theme.conf`)
- [ ] Every theme has: theme_name, theme_wallpaper, theme_preset_type, theme_preset_setting, theme_mode, theme_font, theme_border_thickness, theme_corner_radius, theme_bar1-4, theme_dock, theme_frame, theme_animations, theme_fetch_conf
- [ ] `theme_fetch_logo` present: either a real sdgfetch logo or listed in NEW-LOGOS.md
