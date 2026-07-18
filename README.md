# SDG-OS-THEMES

Wallpaper themes with coordinated colors, fonts, bars, dock, frame, corner radius, and fastfetch for SDG-OS.

## Description

SDG-OS-THEMES provides 57 curated themes organized into categories. Each theme has a `theme.conf` that controls wallpaper, color scheme, mode, font, bar visibility, dock, frame, animations, corner radius, and fastfetch logo.

## Features

- **57 themes** — categories: dynamic (Matugen color extraction), DMS presets, generic colors, branded hardware themes
- **Font propagation** — applies to mangoWM, DMS, Ghostty, VSCode, Waybar/Monocle (opt-out per theme or globally)
- **Corner radius CSS** — generates `theme-overrides.css` for Waybar and Monocle with `--theme-radius` variable
- **Fastfetch integration** — per-theme logo and config via `sdgfetch`
- **Opt-out config** — `~/.config/SDG-THEMES/sdg-themes.conf` toggles font and fastfetch globally
- **Keybind access** — SUPER+W opens interactive picker

## CLI Usage

```bash
sdgtheme                  # Interactive FZF picker
sdgtheme nord             # Switch to a theme directly
sdgtheme SDG-THEMES/nord  # Full path works too
```

## Installation

```bash
sdgpkg install sdg-themes
```

## Configuration

`~/.config/SDG-THEMES/sdg-themes.conf` (optional):

```bash
apply_font=false       # Skip font propagation globally
apply_fastfetch=false  # Skip fastfetch logo/config globally
```

## Theme Fields (theme.conf)

| Field | Description |
|-------|-------------|
| `theme_name` | Display name |
| `theme_wallpaper` | Wallpaper image filename |
| `theme_preset_type` | `matugen`, `DMS`, `directory`, `color` |
| `theme_preset_setting` | Preset identifier |
| `theme_mode` | `dark` or `light` |
| `theme_font` | Font applied system-wide |
| `theme_border_thickness` | mangoWM border width |
| `theme_corner_radius` | Corner radius (px, Waybar/Monocle/mangoWM) |
| `theme_bar1`-`theme_bar4` | Bar visibility (`true`/`false`) |
| `theme_dock` | Dock enabled |
| `theme_frame` | Frame enabled |
| `theme_animations` | `0` off, `1` on |
| `theme_fetch_logo` | sdgfetch logo name (existing or aspirational — see NEW-LOGOS.md) |
| `theme_fetch_conf` | sdgfetch config template |

## Dependencies

- `dms` (DankMaterialShell) — wallpaper and theme management
- `mmsg` — IPC config reload
- `fzf` — interactive picker
- `sdgfetch` (SDG-FETCH) — optional, for fastfetch integration

## Related Packages

- **SDG-MANGO-CORE** — binds SUPER+W to `sdgtheme`
- **SDG-WAYSHELL-CONFIGS** — Waybar/Monocle CSS (imports `theme-overrides.css`)
- **SDG-FETCH** — fastfetch CLI with per-theme logos
- **SDG-TERM** — Ghostty terminal config
