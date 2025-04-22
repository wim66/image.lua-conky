-- image.lua
-- by @wim66
-- April 22 2025, added rotation

require 'cairo'

-- Attempt to safely require the 'cairo_xlib' module
local status, cairo_xlib = pcall(require, 'cairo_xlib')
if not status then
    cairo_xlib = setmetatable({}, { __index = _G })
end

-- === Table of drawable images ===
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

-- === Image drawing function with rotation ===
function conky_draw_image(path, x, y, w, h, rotation)
    if not conky_window then return end

    local cs = cairo_xlib_surface_create(conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    local cr = cairo_create(cs)

    local image = cairo_image_surface_create_from_png(path)
    if image then
        local img_width = cairo_image_surface_get_width(image)
        local img_height = cairo_image_surface_get_height(image)
        local scale_x = w / img_width
        local scale_y = h / img_height

        local center_x = x + w / 2
        local center_y = y + h / 2

        cairo_translate(cr, center_x, center_y)
        cairo_rotate(cr, math.rad(rotation or 0))
        cairo_scale(cr, scale_x, scale_y)
        cairo_set_source_surface(cr, image, -img_width / 2, -img_height / 2)
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
    if not conky_window then return end
    for _, img in ipairs(images) do
        if img.draw_me then
            conky_draw_image(
                img.path, img.x, img.y, img.w, img.h,
                img.rotation or 0
            )
        end
    end
end
