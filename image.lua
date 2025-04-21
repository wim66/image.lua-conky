-- image.lua
-- by @wim66
-- April 21 2025

-- === Required Cairo Modules ===
require 'cairo'

-- Attempt to safely require the 'cairo_xlib' module
local status, cairo_xlib = pcall(require, 'cairo_xlib')

if not status then
    cairo_xlib = setmetatable({}, {
        __index = function(_, k)
            return _G[k]
        end
    })
end

-- === Load settings.lua from parent directory ===
local script_path = debug.getinfo(1, 'S').source:match[[^@?(.*[\/])[^\/]-$]]
local parent_path = script_path:match("^(.*[\\/])resources[\\/].*$") or ""

-- === Table of drawable elements ===
local boxes_settings = {
    {
        type = "image",
        path = parent_path .. "archlogo.png",
        x = 15, y = 5, w = 74, h = 74,
        draw_me = true
    },
    {
        type = "image",
        path = parent_path .. "archlogo2.png",
        x = 5, y = 90, w = 120, h = 40,
        draw_me = true
    },
}

-- === Image drawing function with scaling ===
function conky_draw_image(path, x, y, w, h)
    if conky_window == nil then return end
    local cs = cairo_xlib_surface_create(conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    local cr = cairo_create(cs)

    -- Load the image
    local image = cairo_image_surface_create_from_png(path)
    if image then
        -- Get original image dimensions
        local img_width = cairo_image_surface_get_width(image)
        local img_height = cairo_image_surface_get_height(image)

        -- Calculate scaling factors
        local scale_x = w / img_width
        local scale_y = h / img_height

        -- Apply scaling
        cairo_scale(cr, scale_x, scale_y)

        -- Draw the image at scaled position
        cairo_set_source_surface(cr, image, x / scale_x, y / scale_y)
        cairo_paint(cr)

        cairo_surface_destroy(image)
    else
        print("Failed to load image: " .. path)
    end

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end

-- === Main drawing function ===
function conky_draw_images()
    if conky_window == nil then return end

    for _, box in ipairs(boxes_settings) do
        if box.draw_me and box.type == "image" then
            conky_draw_image(box.path, box.x, box.y, box.w, box.h)
        end
    end
end