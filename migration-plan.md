# SDG-OS-THEMES Migration Plan

## 1. Implement Lifecycle Scripts

All four root-level lifecycle scripts are **empty stubs** — must be implemented:

| Script | Purpose |
|--------|---------|
| `install.sh` | Deploy `config/SDG-THEMES/*` → `~/.config/sdgos/wallpapers/*`, deploy `local/SDG-THEMES/setwallpapergroup.sh` → `~/.config/sdgos/wallpapers/`, make executable |
| `uninstall.sh` | Remove all wallpaper groups from `~/.config/sdgos/wallpapers/` |
| `update.sh` | Re-deploy wallpapers |
| `detect.sh` | Check for `dms` command, verify ~/.config/sdgos/wallpapers/ structure |

## 2. Path Audit

### 2.1 Hardcoded `/home/$(whoami)/` in setwallpapergroup.sh
`local/SDG-THEMES/setwallpapergroup.sh` line 47:
```bash
dms ipc call settings set customThemeFile "/home/$(whoami)/.config/DankMaterialShell/themes/$Preset/theme.json"
```
- Change to: `dms ipc call settings set customThemeFile "$HOME/.config/DankMaterialShell/themes/$Preset/theme.json"`.

### 2.2 Wallpaper directory reference
Lines 6-8 reference `~/.config/sdgos/wallpapers` — this is the install destination. Correct after deployment.

## 3. Cross-module References

### 3.1 setwallpapergroup.sh calls
- `dms ipc call wallpaper set ...` — depends on DMS (DankMaterialShell from SDG-MANGO-CORE).
- `dms ipc call settings set ...` — DMS settings API.
- `dms kill`, `dms run` — DMS lifecycle commands.
- `mmsg dispatch reload_config` — mangoWM IPC command.

### 3.2 Binding from SDG-MANGO-CORE
- `SUPER+W` → `~/.config/sdgos/wallpapers/setwallpapergroup.sh` (from binds.conf line 56).

## 4. Config Structure

### 4.1 wallpaper.conf format
Each wallpaper group has a `wallpaper.conf` file:
```
Theme_Category:<category>
Theme_Name:<name>
Generic_Color:<color>
Matugen:<scheme>
Mode:dark|light
Preset:<preset>
```
This is read by `setwallpapergroup.sh` — do not change the format without updating the script.

### 4.2 Theme categories found
- `registry` (most groups)
- Verify all 59 groups have valid `wallpaper.conf` files.

## 5. Modular Tips/Help Contribution

### 5.1 Tips
- Add tips about wallpaper groups, the `SUPER+W` bind, `ALT+W` to cycle wallpapers.
- Create `tips/` directory.

### 5.2 Docs
- `docs/SDG-THEMES/README.md` exists with module documentation.
- Could contribute a help topic about using and customizing wallpaper groups.

## 6. Empty Directory Cleanup

| Directory | Status |
|-----------|--------|
| `cache/` | Empty — remove |
| `tips/` | Empty — add tips or remove |
| `other/` | Empty — remove |

## 7. Large Files
- The module contains ~300 wallpaper images across 59 groups. Consider `.gitattributes` for LFS or external download.
