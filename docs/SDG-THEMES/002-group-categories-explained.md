# Group Categories Explained

Each wallpaper group has a `Theme_Category` field that determines how colors are applied.

## dynamic

Colors are extracted automatically from the wallpaper using Matugen (Material You). The `Generic_Color` field is set to `dynamic`, and no preset is used.

## registry

A predefined DMS theme preset is applied (e.g., nord, catppuccin, gruvbox). The `Generic_Color` is set to `custom` and `Preset` names a DMS theme file.

## custom

Hardware/vendor-branded presets applied (e.g., asusrog, razer, framework). Same mechanism as registry but themed to match specific hardware.

## generic

Uses a fixed color name. No DMS preset is applied.
