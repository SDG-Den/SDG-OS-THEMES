# Getting Started

## Keybinds

| Keybind | Action |
|---------|--------|
| SUPER+W | Open wallpaper group selector (FZF picker) |
| ALT+W | Next wallpaper in current group |
| ALT+SHIFT+W | Previous wallpaper in current group |

## CLI

```sh
wallpaper-select              # Interactive FZF group picker
wallpaper-select <group-name> # Switch to a group directly
```

## What Happens When You Switch

1. First image in the selected group directory is set as wallpaper via `dms ipc call wallpaper set`
2. `wallpaper.conf` is parsed to determine theme behavior
3. DMS restarts to apply changes
4. A config reload is dispatched via `mmsg` for other UI components

## Cycling Within a Group

If a group has multiple images, pressing SUPER+W again cycles to the next image. Images cycle in alphabetical order. Single-image groups do not cycle. Cycling is handled by DMS, not the script.
