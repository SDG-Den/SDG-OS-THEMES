# Adding Custom Themes

You can create your own themes by adding a directory under `~/.local/themes/<category>/`.

## Steps

1. Pick a category (e.g., `SDG-THEMES`, `SDG-THEMES-BRANDS`, `SDG-THEMES-FUN`, `SDG-THEMES-DESTINY`)

2. Create the theme directory:

   ```sh
   mkdir -p ~/.local/themes/SDG-THEMES/my-theme
   ```

3. Add wallpaper images (jpg/png)

   ```sh
   cp ~/wallpaper.jpg ~/.local/themes/SDG-THEMES/my-theme/
   ```

4. Create a `theme.conf`:

   ```sh
   cat > ~/.local/themes/SDG-THEMES/my-theme/theme.conf << 'EOF'
   theme_name=my-theme
   theme_wallpaper=wallpaper.jpg
   theme_preset_type=color
   theme_preset_setting=blue
   theme_mode=dark
   theme_font="JetBrainsMono Nerd Font"
   theme_border_thickness=2
   theme_corner_radius=14
   theme_bar1=false
   theme_bar2=true
   theme_bar3=false
   theme_bar4=false
   theme_dock=false
   theme_frame=true
   theme_animations=1
   theme_fetch_conf=minimal.jsonc
   EOF
   ```

5. The theme will appear in the SUPER+W picker automatically.

## Example: Dynamic Theme (auto-color from wallpaper)

```
theme_name=my-dynamic
theme_wallpaper=photo.jpg
theme_preset_type=matugen
theme_preset_setting=vibrant
theme_mode=dark
theme_font="JetBrainsMono Nerd Font"
theme_border_thickness=2
theme_corner_radius=14
theme_bar1=false
theme_bar2=false
theme_bar3=true
theme_bar4=false
theme_dock=false
theme_frame=false
theme_animations=1
theme_fetch_conf=simple.jsonc
```

## Example: Brand Theme (DMS preset)

```
theme_name=my-brand
theme_wallpaper=brand-logo.png
theme_preset_type=DMS
theme_preset_setting=mybrand
theme_mode=dark
theme_font="JetBrainsMono Nerd Font"
theme_border_thickness=1
theme_corner_radius=4
theme_bar1=true
theme_bar2=false
theme_bar3=false
theme_bar4=false
theme_dock=false
theme_frame=false
theme_animations=1
theme_fetch_logo=mybrand
theme_fetch_conf=screenfetch.jsonc
```

## Opt-Out Config

To disable font propagation or fastfetch globally, create `~/.config/SDG-THEMES/sdg-themes.conf`:

```sh
apply_font=false
apply_fastfetch=false
```
