local wibox = require('wibox')
local awful = require('awful')
local colors = require('themes.default.colors')
local gshape = require("gears.shape")

local iconbutton = require('ui.iconbutton')
local list = require('ui.list')

local _M = {}

local config_path = awful.util.getdir("config")
local is_active = false

function _M.get()
    local popup = awful.popup {
        widget = {},
        visible = false,
        ontop = true,
        maximum_width = 400,
        minimum_width = 120,
        border_width = 2,
        border_color = colors.dark1,
        shape = function(cr, w, h)
            gshape.rounded_rect(cr, w, h, 8)
        end,
        shape_clip = true
    }

    local icon_path = config_path .. "/power.png"
    local icon_active_path = config_path .. "/power-active.png"

    local power_icon_button = iconbutton({
        icon = icon_path,
        icon_active = icon_active_path,
        margins = 4,
        id = "p",
        radius = 6,
        bg_hover = colors.dark0,
        on_click = function()
            is_active = not is_active
            if popup.visible then
                popup.visible = not popup.visible
            else
                popup:move_next_to(mouse.current_widget_geometry)
            end
        end
    })
    local power_button = wibox.widget {
        layout = wibox.container.margin,
        left = 2,
        right = 2,
        power_icon_button
    }

    local menu_items = {
        -- {
        --     name = "Logout",
        --     icon = config_path .. "/exit.png"
        -- },
        {
            name = "Restart",
            icon = config_path .. "/restart.png",
            cmd = "sudo reboot"
        },
        {
            name = "Shutdown",
            icon = config_path .. "/power.png",
            cmd = "sudo shutdown"
        }
    }

    local popup_menu = list({
        items = menu_items,
        margins = 8,
        icon_text_spacing = 8,
        icon_width = 20,
        icon_height = 20,
        bg = colors.bg,
        fb = colors.fg,
        on_click = function()
            popup.visible = not popup.visible
        end
    })

    popup:setup(popup_menu)

    local power_widget = {
        power_button,
        layout = wibox.layout.fixed.horizontal
    }

    return power_widget
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
