# theme.conf Reference

Each theme directory contains a `theme.conf` that defines the full visual theme.

## Format

```sh
theme_name=nord
theme_wallpaper=nord-1.jpg
theme_preset_type=matugen
theme_preset_setting=vibrant
theme_mode=dark
theme_font="JetBrainsMono Nerd Font"
theme_border_thickness=2
theme_corner_radius=14
theme_bar1=false
theme_bar2=true
theme_bar3=false
theme_bar4=false
theme_dock=false
theme_frame=false
theme_animations=1
theme_fetch_logo=nord
theme_fetch_conf=left-frame-dotted.jsonc
```

## Fields

### theme_preset_type

| Value | Behavior |
|-------|----------|
| `matugen` | Matugen auto-extracts colors from the wallpaper |
| `DMS` / `dms` | A predefined DMS theme preset is applied |
| `directory` | Path to a DMS theme JSON file |
| `color` | A fixed Material You color name is used |

### theme_preset_setting

Depends on `theme_preset_type`:
- `matugen` → Matugen variant: `vibrant`, `tonal-spot`, `neutral`, `fruit-salad`, `fidelity`, `content`, `expressive`, `monochrome`, `rainbow`
- `DMS` → DMS preset folder name (e.g., `nord`, `thinkpad`)
- `directory` → Absolute path to a `theme.json` file
- `color` → Color name: `blue`, `purple`, `green`, `orange`, `red`, `cyan`, `pink`, `amber`, `coral`, `white`

### theme_mode

| Value | Description |
|-------|-------------|
| `dark` | Dark color scheme |
| `light` | Light color scheme |

### theme_font

Font applied to mangoWM, DMS, Ghostty, VSCode, Waybar, and Monocle. Skipped if `apply_font=false` in `sdg-themes.conf`.

### theme_border_thickness

mangoWM border width in pixels.

### theme_corner_radius

Corner radius in pixels — applied to mangoWM groups/bars and written to `--theme-radius` in Waybar/Monocle CSS overrides.

### theme_bar1–theme_bar4

Controls Waybar bar visibility for bars 0–3.

| Value | Effect |
|-------|--------|
| `true` | Bar is revealed |
| `false` | Bar is hidden |

### theme_dock

| Value | Effect |
|-------|--------|
| `true` | Dock is shown |
| `false` | Dock is hidden |

### theme_frame

| Value | Effect |
|-------|--------|
| `true` | Frame is enabled |
| `false` | Frame is disabled |

### theme_animations

| Value | Effect |
|-------|--------|
| `1` | mangoWM animations enabled |
| `0` | mangoWM animations disabled |

### theme_fetch_logo

sdgfetch logo name. If the logo does not yet exist in sdgfetch, it should be listed in NEW-LOGOS.md with a description of the image to create.

### theme_fetch_conf

sdgfetch config template name (e.g., `minimal.jsonc`, `screenfetch.jsonc`). These are fetch layout presets, not logos.
