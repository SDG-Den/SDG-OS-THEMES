# SDG-OS-THEMES Migration Plan

## Directory Mapping

| Source | Installed to |
|--------|-------------|
| `config/SDG-THEMES/<group>/` | `~/.config/SDG-THEMES/<group>/` |
| `local/SDG-THEMES/setwallpapergroup.sh` | `~/.local/SDG-THEMES/setwallpapergroup.sh` |
| `tips/` | `~/.local/tips/SDG-OS-THEMES/` |
| `docs/` | `~/.local/docs/SDG-OS-THEMES/` |

## Path Rewrites

### setwallpapergroup.sh — internal paths

| Old | New |
|-----|-----|
| `WP_DIR=~/.config/sdgos/wallpapers` | `WP_DIR=~/.config/SDG-THEMES` |
| `/home/$(whoami)/.config/DankMaterialShell/themes/` | `$HOME/.config/DankMaterialShell/themes/` |

### firstrun.sh (from SDG-MANGO-CORE) references this module

| Old | New |
|-----|-----|
| `~/.config/sdgos/wallpapers/default/wallpaper.png` | `~/.config/SDG-THEMES/default/wallpaper.png` |

### binds.conf (from SDG-MANGO-CORE) references this module

| Old | New |
|-----|-----|
| `~/.config/sdgos/wallpapers/setwallpapergroup.sh` | `~/.local/SDG-THEMES/setwallpapergroup.sh` |

## Lifecycle Scripts

All four root-level scripts are empty. Implement:

- **install.sh**: Copy `config/SDG-THEMES/` → `~/.config/SDG-THEMES/`, copy `local/SDG-THEMES/` → `~/.local/SDG-THEMES/`, copy docs/tips.
- **uninstall.sh**: Remove `~/.config/SDG-THEMES/`, `~/.local/SDG-THEMES/`.
- **update.sh**: Re-deploy wallpapers (overwrite).
- **detect.sh**: Check `dms` command, verify `~/.config/SDG-THEMES/` has at least one group.

## Modular Tips

- Create `tips/` with tips about wallpaper groups, `SUPER+W` bind, `ALT+W` cycling, `setwallpapergroup.sh` usage.

## Modular Docs

- `docs/SDG-THEMES/README.md` already exists — copy to `~/.local/docs/SDG-THEMES/`.

## Cleanup

- Empty `cache/`, `other/`, `tips/` — populate or remove.
