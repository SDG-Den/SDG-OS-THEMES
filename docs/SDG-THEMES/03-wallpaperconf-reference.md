# wallpaper.conf Reference

Each wallpaper group directory can contain a `wallpaper.conf` that defines theme behavior.

## Format

```
Theme_Category:dynamic|registry|custom|generic
Generic_Color:color-name|dynamic|custom
Matugen:vibrant|tonal-spot|neutral|fruit-salad
Mode:dark|light
Preset:preset-name|-
```

## Fields

### Theme_Category

| Value | Behavior |
|-------|----------|
| `dynamic` | Matugen auto-extracts colors from the wallpaper |
| `registry` | A predefined DMS theme preset is applied |
| `custom` | A hardware-brand custom preset is applied |
| `generic` | A fixed color name is used |

### Generic_Color

| Value | Behavior |
|-------|----------|
| `dynamic` | Color extracted from wallpaper (used with dynamic category) |
| `custom` | Uses a DMS theme preset (used with registry/custom categories) |
| `blue` / `purple` / `green` / `orange` / `red` / `cyan` / `pink` / `amber` / `coral` / `white` | Fixed color (used with generic category) |

### Matugen

Material You palette variant.

| Value | Description |
|-------|-------------|
| `vibrant` | High saturation, colorful palette |
| `tonal-spot` | Subtle, tonal palette |
| `neutral` | Desaturated, neutral palette |
| `fruit-salad` | Playful, varied palette |
| `fidelity` | Faithful to source colors |
| `content` | Content-aware palette |
| `expressive` | Expressive color extraction |
| `monochrome` | Single-hue grayscale palette |
| `rainbow` | Full spectrum palette |

### Mode

| Value | Description |
|-------|-------------|
| `dark` | Dark color scheme |
| `light` | Light color scheme |

### Preset

A DMS theme preset applied from `~/.config/DankMaterialShell/themes/`. Use the folder names directly. Set to `-` when not used (dynamic/generic categories).
