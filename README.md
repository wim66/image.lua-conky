# image.lua-conky
## A Concept for Displaying Images in Conky

`image.lua-conky` is a Conky configuration concept designed to display images using Lua scripting. It allows you to overlay PNG images on your desktop with options for positioning, scaling, and rotation. This project is ideal for users who want to enhance their desktop with lightweight and dynamic visual elements.

---

## Features
- **Display Images**: Add PNG images to your Conky setup with customizable size and position.
- **Rotation Support**: Rotate images to any angle.
- **Lightweight**: Uses minimal resources, making it perfect for low-overhead desktop enhancements.
- **Customizable**: Easily define multiple images and their attributes (position, size, rotation) in a Lua table.
- **Dynamic Updates**: Images can be updated dynamically based on your Conky configuration.

---

## Requirements
- **Conky**: Conky must be installed on your system. Refer to [Conky's installation guide](https://github.com/brndnmtthws/conky).
- **Cairo**: The script uses the Cairo graphics library for rendering images. Ensure Cairo is installed on your system.
  - On some systems, you may need the `cairo-xlib` module. If unavailable, it will fall back gracefully.

---

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/wim66/image.lua-conky.git
   ```
    Ensure Conky is installed and properly configured on your system.

    Copy the conky.conf file to your Conky configuration directory or use it as a reference for your existing setup.

    Place your images (e.g., archlogo.png and archlogo2.png) in the same directory as image.lua or update the paths in the script.

    Run Conky with the configuration:
    ```
    conky -c conky.conf
    ```
Usage
Configuring image.lua

The images are defined in a Lua table within the image.lua file. Each image entry includes the following attributes:

    path: The relative or absolute path to the PNG file.
    x and y: The position of the image on the screen.
    w and h: The width and height of the image.
    rotation: The rotation angle in degrees (clockwise).
    draw_me: A boolean to toggle whether the image should be drawn.

Example configuration:
Lua
```
local images = {
    {
        path = "archlogo.png",
        x = 15, y = 15, w = 74, h = 74,
        rotation = -30,  -- degrees
        draw_me = true
    },
    {
        path = "archlogo2.png",
        x = 5, y = 140, w = 120, h = 40,
        rotation = 45,
        draw_me = true
    },
}
```

Loading the Script

In your conky.conf file, ensure the Lua script is loaded and the drawing hook is set:
Lua
```
lua_load = 'image.lua'
lua_draw_hook_pre = 'draw_images'
```

Customization

    Relative vs Absolute Paths: Use relative paths for images located in the same directory as image.lua, or absolute paths for images stored elsewhere.
    Multiple Scripts: To use additional Lua scripts (e.g., clock rings), configure lua_load and lua_draw_hook_pre accordingly in conky.conf.

Example:
```
lua_load = 'image.lua clock_rings.lua'
lua_draw_hook_pre = 'draw_images draw_clock_rings'
```

Known Limitations

    Only PNG images are supported.
    Ensure the image dimensions (w and h) match the aspect ratio to avoid distortion.

License

This project is licensed under the MIT License. See the LICENSE file for details.
Author
