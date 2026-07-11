# SDG-OS-THEMES Documentation Plan

## Current Status
One doc file exists (`docs/SDG-THEMES/README.md`, 46 lines). One tips file exists (`tips/SDG-OS-THEMES/README.md`, 14 lines with 4 tips). The existing docs are partially accurate but need expansion.

## Source-Verified Inventory
**Components:**
- 57 wallpaper groups (NOT 56 as previously thought — plan was outdated)
- 1 script: `setwallpapergroup.sh` — handles fzf group picker, wallpaper selection via DMS IPC, parses wallpaper.conf fields, applies theme category/Matugen variant/mode/preset
- wallpaper.conf format: `Theme_Category` (dynamic/registry/custom/generic), `Theme_Name` (NOT used by script), `Generic_Color`, `Matugen` (vibrant/tonal-spot/neutral/fruit-salad), `Mode` (dark/light), `Preset`
- Keybinds: SUPER+W (picker), ALT+W / ALT+SHIFT+W (cycle), wallpaper-select CLI
- Theme categories: dynamic (Matugen extracts from wallpaper), registry (DMS preset applied), custom (hardware brand preset), generic (fixed color)

## Docs System (`docs/`)
**Deploy location**: `~/.local/docs/SDG-THEMES/`

### Planned Doc Topics
| # | Topic | Description | Priority |
|---|-------|-------------|----------|
| 1 | Getting Started | How to use SUPER+W and wallpaper-select to change wallpapers | High |
| 2 | Wallpaper Groups Reference | Full list of all 57 groups with category, mode, and matugen variant | High |
| 3 | Group Categories Explained | dynamic vs registry vs custom vs generic — what each does | Medium |
| 4 | wallpaper.conf Reference | All fields: Generic_Color, Theme_Category, Matugen, Mode, Preset | Medium |
| 5 | Adding Custom Groups | How to create a new wallpaper group with custom images and conf | Medium |
| 6 | Color Scheme Integration | How themes propagate to DMS, mangoWM, Firefox, WayShell, Ghostty | Low |

### Existing Content
| File | Notes |
|------|-------|
| `docs/SDG-THEMES/README.md` | 46 lines — covers basics. Needs expansion for topics #1, #3, #4 |
| `analysis.md` | Has group category breakdown data — source for topic #3 |

## Tips System (`tips/`)
**Deploy location**: `~/.local/tips/SDG-OS-THEMES/`

### Existing Tips
| # | Tip | Format | Notes |
|---|-----|--------|-------|
| 1 | SUPER+W — open wallpaper group selector | In `tips/README.md` — .md format, NOT sdgtip-compatible | Needs conversion to tips.list |
| 2 | ALT+W / ALT+SHIFT+W — cycle wallpapers | Same .md file | Needs conversion |
| 3 | wallpaper-select CLI | Same .md file | Needs conversion |
| 4 | Per-group color schemes | Same .md file | Needs conversion |

### Planned Additional Tips
| # | Tip | Priority |
|---|-----|----------|
| 5 | dynamic themes auto-color from wallpaper | Medium |
| 6 | custom themes match hardware brand | Low |

## Implementation Notes
- Use `nn-topic-name.md` format for docs
- Tips must be converted to `tips/SDG-OS-THEMES/tips.list` (one tip per line) for sdgtip compatibility
- Keep the existing `tips/README.md` as reference but add the `.list` file for runtime
- The 57 groups list data is in individual wallpaper.conf files under `config/SDG-THEMES/`
