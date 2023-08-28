local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local gmc   = require('themes.default.gmc')

local _M = {}

local config_path = awful.util.getdir("config")
local is_active = false

function _M.get()
    local power_button = wibox.widget {
        layout = wibox.container.margin,
        left = 2,
        right = 2,
        {
            widget = wibox.widget.imagebox,
            image = config_path .. "/power.png",
            id = "p"
        }
    }

    local popup = awful.popup {
        widget = {},
        visible = false,
        ontop = true,
        maximum_width = 400,
        minimum_width = 120,
        border_width = 2,
        border_color = gmc.color["white"]
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
    local menu_item_rows = {
        layout = wibox.layout.fixed.vertical
    }
    for _, menu_item in ipairs(menu_items) do
        local menu_row = wibox.widget {
            widget = wibox.container.background,
            bg = gmc.color["dark"],
            fg = gmc.color["white"],
            {
                widget = wibox.container.margin,
                margins = 8,
                {
                    {
                        widget = wibox.widget.imagebox,
                        image = menu_item.icon,
                        forced_width = 20,
                        forced_height = 20,
                    },
                    {
                        widget = wibox.widget.textbox,
                        text = menu_item.name
                    },
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 8
                }
            }
        }
        menu_row:connect_signal("mouse::enter", function (c)
            c:set_bg(gmc.color["grey800"])
        end)
        menu_row:connect_signal("mouse::leave", function (c)
            c:set_bg(gmc.color["dark"])
        end)
        menu_row:buttons(
            awful.util.table.join(
                awful.button({}, 1, function ()
                    popup.visible = not popup.visible
                end)
            )
        )
        table.insert(menu_item_rows, menu_row)
    end

    popup:setup(menu_item_rows)

    power_button:connect_signal("button::press", function (b)
        local power_icon = power_button:get_children_by_id("p")[1]
        if(is_active == false) then
            power_icon:set_image(config_path .. "/power-active.png")
        else
            power_icon:set_image(config_path .. "/power.png")
        end
        is_active = not is_active
        if popup.visible then
            popup.visible = not popup.visible
        else
            popup:move_next_to(mouse.current_widget_geometry)
        end
    end)

    local power_widget = {
        power_button,
        layout = wibox.layout.fixed.horizontal
    }

    return power_widget
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
