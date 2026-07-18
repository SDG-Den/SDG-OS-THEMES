# Theme Preset Types

Each theme's `theme_preset_type` field determines how colors are applied.

## matugen

Colors are extracted automatically from the wallpaper using Matugen (Material You). The `theme_preset_setting` selects the Matugen variant (vibrant, tonal-spot, neutral, etc.).

Used by most color-scheme themes (nord, catppuccin, gruvbox, etc.).

## DMS / dms

A predefined DMS theme preset is applied (e.g., `thinkpad`, `ROG`, `mac`). The `theme_preset_setting` names the preset directory under `~/.config/DankMaterialShell/themes/`.

Used by hardware-branded themes.

## directory

A path to a DMS theme JSON file is used directly. The `theme_preset_setting` is an absolute path.

## color

A fixed Material You color name is used (e.g., `blue`, `green`, `red`). No DMS preset file is applied. The `theme_preset_setting` is the color name.

Used by generic color themes.
