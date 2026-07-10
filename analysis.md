# SDG-OS-THEMES Analysis

## Type
Wallpaper and Visual Theme Presets Module

## Description
SDG-OS-THEMES provides a curated collection of ~150+ wallpaper images organized into 56 named wallpaper groups. Each group has a `wallpaper.conf` that tells DMS (DankMaterialShell) what color scheme, Material You palette variant, dark/light mode, and theme preset to apply when that group is selected.

## Usage
After installation via `sdgpkg install sdg-themes`, wallpaper groups are available at `~/.config/SDG-THEMES/`.

### Switching Wallpaper Groups
- **Via keybind**: Press `SUPER+W` to open the interactive fzf wallpaper group picker.
- **Via terminal**: Run `wallpaper-select` for the interactive picker, or `wallpaper-select <group-name>` to switch directly (e.g., `wallpaper-select nord`).
- **Cycle images within group**: If a group has multiple images, pressing SUPER+W again cycles to the next image in the same group.

### What Happens When You Switch
1. The first image in the selected group directory is set as wallpaper via `dms ipc call wallpaper set`
2. The `wallpaper.conf` is parsed to determine theme behavior:
   - **dynamic**: Matugen auto-extracts colors from the new wallpaper
   - **registry**: A predefined DMS theme preset is applied (e.g., nord, catppuccin)
   - **custom**: A hardware-brand custom preset is applied (e.g., asusrog)
   - **generic**: A fixed generic color is applied
3. DMS restarts to apply the changes
4. A config reload is dispatched via `mmsg` for other UI components

### Adding Custom Wallpaper Groups
1. Create a new directory under `~/.config/SDG-THEMES/`
2. Add wallpaper images (jpg/png) 
3. Create a `wallpaper.conf` with the desired theme settings

## CLI Entry Points
| Command | Description |
|---------|-------------|
| `wallpaper-select <group>` | Set wallpaper group directly by name |
| `wallpaper-select` (no args) | Interactive fzf group picker |

## Keybind (from SDG-MANGO-CORE)
- `SUPER+W` — Open wallpaper group selector

## Directory Structure
```
SDG-OS-THEMES/
├── README.md                     # Minimal
├── install.sh / update.sh / uninstall.sh
├── config/SDG-THEMES/
│   ├── setwallpapergroup.sh      # Main runtime script
│   ├── example.conf              # Template/example wallpaper.conf
│   ├── default/                  # Default wallpaper group
│   ├── AMOLED/                   # 56 theme groups (each with wallpaper.conf + images)
│   ├── WAN/
│   ├── anime/  arch/  catppuccin/  catppuccin-latte/  cute/
│   ├── dell/  destiny-*/  ethereal/  everforest/  flexoki/
│   ├── framework/  gaming/  ganjaos/  great-wave/  great-wave-dark/
│   ├── gruvbox/  hackerman/  hpspectre/  jade/  landscapes/
│   ├── lumon/  mac/  matey/  modus/  msi-*/  nord/
│   ├── omen/  pride/  razer/  retro-82/  risetto/  ROG/
│   ├── rose-pine/  snow/  solitude/  steamdeck/  surface/
│   ├── system76/  terminal/  terminal-blue/  terminal-monochrome/
│   ├── thinkpad/  tokyo-night/  vantablack/  yoga/  yuri/  zenbook/
│   └── ... (56 total)
├── local/SDG-THEMES/
│   └── setwallpapergroup.sh      # Executable copy
├── docs/SDG-THEMES/README.md     # Full documentation
└── tips/SDG-OS-THEMES/README.md  # Quick tips
```

## Theme Group Categories
| Category | Count | Behavior |
|----------|-------|----------|
| dynamic | ~20 | Colors extracted dynamically from wallpaper (Matugen auto-palette) |
| registry | ~15 | Uses a DMS-registered theme preset (nord, catppuccin, gruvbox, etc.) |
| custom | ~15 | Hardware/vendor-branded themes (ROG, Razer, Framework, etc.) |
| generic | 1 | Uses fixed color name (e.g., coral) |

## wallwards.conf Format
```
Theme_Category:dynamic|registry|custom|generic
Theme_Name:custom|dynamic
Generic_Color:color-name|dynamic|custom
Matugen:vibrant|tonal-spot|neutral|fruit-salad
Mode:dark|light
Preset:preset-name|-
```

## Runtime Flow
1. User presses SUPER+W or runs `wallpaper-select [group]`
2. Script finds first image in group directory (skipping .conf files)
3. Sends IPC commands to DMS: set wallpaper, apply color/theme preset
4. Restarts DMS, dispatches config reload via mmsg

## Required Dependencies
| Dependency | Purpose |
|------------|---------|
| DMS (DankMaterialShell) | Wallpaper setting and theme management |
| mmsg | IPC messaging for config reload |
| fzf | Interactive group picker |
| notify-send | Desktop notifications |

## Optional Dependencies
| Dependency | Purpose |
|------------|---------|
| Matugen | Material You color extraction (used if DMS uses it) |

## Required Dependents
- **SDG-MANGO-CORE**: Binds SUPER+W to `setwallpapergroup.sh`

## Optional Dependents
- **SDG-DOCS**: Documents theming
