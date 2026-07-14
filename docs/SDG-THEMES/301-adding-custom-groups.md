# Adding Custom Wallpaper Groups

You can create your own wallpaper groups with custom images and theme settings.

## Steps

1. Create a new directory under `~/.config/SDG-THEMES/`

   ```sh
   mkdir ~/.config/SDG-THEMES/my-group
   ```

2. Add wallpaper images (jpg/png)

   ```sh
   cp ~/wallpaper.jpg ~/.config/SDG-THEMES/my-group/
   ```

3. Create a `wallpaper.conf` with the desired theme settings

   ```sh
   cat > ~/.config/SDG-THEMES/my-group/wallpaper.conf << EOF
   Theme_Category:dynamic
   Generic_Color:dynamic
   Matugen:vibrant
   Mode:dark
   Preset:-
   EOF
   ```

4. The group will appear in the SUPER+W picker automatically — no registration needed.

## Example Configurations

**Dynamic (auto-color from wallpaper):**
```
Theme_Category:dynamic
Generic_Color:dynamic
Matugen:vibrant
Mode:dark
Preset:-
```

**Registry (DMS preset):**
```
Theme_Category:registry
Generic_Color:custom
Matugen:vibrant
Mode:dark
Preset:nord
```

**Custom (hardware brand):**
```
Theme_Category:custom
Generic_Color:custom
Matugen:vibrant
Mode:dark
Preset:asusrog
```

**Generic (fixed color):**
```
Theme_Category:generic
Generic_Color:coral
Matugen:vibrant
Mode:light
Preset:-
```
