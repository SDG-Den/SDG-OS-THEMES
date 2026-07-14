# SDG-OS-THEMES

Wallpaper groups and visual theme system for SDG-OS.

## Description

SDG-OS-THEMES provides a curated collection of wallpapers organized into named groups. Each group has a `wallpaper.conf` that tells the system what color scheme, Material You palette variant, dark/light mode, and DMS theme preset to apply on selection.

## Features

- **57 wallpaper groups** — categories: dynamic, registry, custom, generic
- **Material You integration** — dynamic groups auto-extract colors from the wallpaper
- **DMS theme presets** — registry and custom groups apply matching DMS themes
- **Keybind access** — SUPER+W opens interactive picker
- **Cycle within group** — press SUPER+W again to cycle images
- **Custom groups** — add your own directories with wallpaper.conf

## CLI Usage

```bash
wallpaper-select              # Interactive group picker
wallpaper-select nord         # Switch to a group directly
```

## Installation

```bash
sdgpkg install sdg-themes
```

## Dependencies

- `dms` (DankMaterialShell) — wallpaper setting and theme management
- `mmsg` — IPC messaging for config reload
- `fzf` — interactive group picker
- `notify-send` — desktop notifications
- `matugen` (optional) — Material You color extraction

## Related Packages

- **SDG-MANGO-CORE** — binds SUPER+W to open wallpaper picker
