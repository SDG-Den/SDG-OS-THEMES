# SDG-OS-THEMES Documentation Plan

## Current Status
One doc file exists (`docs/SDG-THEMES/README.md`, full documentation of wallpaper system). One tips file exists (`tips/SDG-OS-THEMES/README.md`, quick tips).

## Docs System (`docs/`)
**Deploy location**: `~/.local/docs/SDG-THEMES/`

### Existing Docs
| File | Topic |
|------|-------|
| docs/SDG-THEMES/README.md | Wallpaper group structure, wallpaper.conf format, keybinds, cycling, wallpaper-select CLI |

### Planned Doc Topics
| # | Topic | Description | Priority |
|---|-------|-------------|----------|
| 1 | Getting Started | How to use SUPER+W or wallpaper-select to change wallpaper | High |
| 2 | Wallpaper Groups Reference | Full list of all 56 groups with theme category, mode, and matugen variant | High |
| 3 | Group Categories Explained | dynamic vs registry vs custom vs generic behavior | Medium |
| 4 | wallpaper.conf Reference | All fields: Theme_Category, Theme_Name, Generic_Color, Matugen, Mode, Preset | Medium |
| 5 | Adding Custom Groups | How to create new wallpaper groups with your own images | Medium |
| 6 | Color Scheme Integration | How themes propagate via Matugen to DMS, mangoWM, Firefox, WayShell | Low |

### Implementation
- Convert existing README.md into focused topic docs
- Add wallpaper group reference table
- Follow SDG-DOCS naming convention

## Tips System (`tips/`)
**Deploy location**: `~/.local/tips/SDG-OS-THEMES/`

### Existing Tips (from tips/SDG-OS-THEMES/README.md)
1. Press SUPER+W to open wallpaper picker
2. Use `wallpaper-select <group>` for direct switching
3. Each wallpaper group sets its own color scheme
4. Cycle to next image in group by pressing SUPER+W again

### Planned Tips
| # | Tip | Description | Priority |
|---|-----|-------------|----------|
| 1 | Wallpaper picker | SUPER+W — browse and select wallpaper groups | High |
| 2 | Quick switch | `wallpaper-select nord` — switch without interactive menu | High |
| 3 | Dynamic colors | Dynamic wallpaper groups auto-generate colors from the image | Medium |
| 4 | Custom themes | Hardware-brand groups apply matching DMS presets (ROG, Razer, etc.) | Medium |

### Implementation
- Convert tips/README.md to tips.list format for SDG-TIPS aggregation
- Add more actionable one-liner tips
