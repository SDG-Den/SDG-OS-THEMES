# Color Scheme Integration

When a wallpaper group is selected, the theme propagates through the system.

## Runtime Flow

1. User presses SUPER+W or runs `wallpaper-select [group]`
2. Script finds first image in group directory (skipping .conf files)
3. Sends IPC commands to DMS: set wallpaper, apply theme category, matugen scheme, mode, and preset
4. DMS restarts to apply changes
5. Config reload dispatched via `mmsg` for other UI components

## Components Affected

| Component | How It Receives Theme |
|-----------|----------------------|
| DMS | Direct IPC calls for wallpaper, theme category, matugen scheme, mode, and preset |
| mangoWM | Config reload via `mmsg dispatch reload_config` |
| Firefox | Theme propagated through DMS/system |
| WayShell | Config reload via `mmsg dispatch reload_config` |
| Ghostty | Manual reload required (ctrl+r) after theme change |

## Dependencies

| Dependency | Purpose |
|------------|---------|
| DMS | Wallpaper setting and theme management |
| mmsg | IPC messaging for config reload |
| fzf | Interactive group picker |
| notify-send | Desktop notifications |
| Matugen (optional) | Material You color extraction |
