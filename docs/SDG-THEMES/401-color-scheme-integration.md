# Theme Integration

When a theme is selected via `sdgtheme`, the full visual configuration propagates through the system.

## Runtime Flow

1. User presses SUPER+W or runs `sdgtheme [category/name]`
2. First image in the theme directory is set as wallpaper
3. `theme.conf` is sourced — all theme fields are read
4. Color scheme applied via DMS IPC (matugen/DMS/generic/directory)
5. Mode (dark/light) applied via DMS IPC
6. mangoWM border size and corner radius set via DMS IPC
7. mangoWM font config written to `~/.config/mango/sdg-font.conf` (includes border, radius, animations)
8. Font propagated to DMS, Ghostty, VSCode, Waybar, Monocle via `sdg-font-apply.sh`
9. Bar visibility toggled via DMS IPC (bars 0–3)
10. Dock shown/hidden via DMS IPC
11. Frame enabled/disabled via DMS IPC
12. `theme-overrides.css` generated in `~/.config/SDG-WAYSHELL-CONFIGS/` and `~/.config/SDG-MONOCLE/` with `--theme-radius`
13. Fastfetch logo and config updated via `sdgfetch` (if installed)

## Components Affected

| Component | How It Receives Theme |
|-----------|----------------------|
| DMS | Direct IPC calls for wallpaper, theme, mode, bars, dock, frame |
| mangoWM | Config reload via `mmsg dispatch reload_config` |
| Firefox | Theme propagated through DMS/system |
| Waybar | `@import "../theme-overrides.css"` provides `--theme-radius` |
| SDG-MONOCLE | `@import "./theme-overrides.css"` provides `--theme-radius` |
| Ghostty | Config file rewritten by `sdg-font-apply.sh` |
| VSCode | Settings JSON patched by `sdg-font-apply.sh` |
| Fastfetch | Logo set via `sdgfetch setlogo`, config via `sdgfetch setconf` |

## Config File

`~/.config/SDG-THEMES/sdg-themes.conf` (optional) can disable font or fastfetch:

```bash
apply_font=false
apply_fastfetch=false
```

If the config file doesn't exist, both font and fastfetch apply by default.

## Dependencies

| Dependency | Purpose |
|------------|---------|
| DMS | Wallpaper setting and theme management |
| mmsg | IPC messaging for mangoWM config reload |
| fzf | Interactive theme picker |
| sdgfetch (optional) | Fastfetch logo/config integration |
| sdg-font-apply.sh | Font propagation to secondary targets |
