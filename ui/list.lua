local awful = require("awful")
local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")
local wibox_container = require("wibox.container")
local colors = require("themes.default.colors")

local function list(args)
    local container = {
        layout = wibox_layout.fixed.vertical
    }
    for _, item in ipairs(args.items) do
        local item_row = wibox_widget {
            widget = wibox_container.background,
            bg = args.bg,
            fg = args.fb,
            {
                widget = wibox_container.margin,
                margins = args.margins,
                {
                    {
                        widget = wibox_widget.imagebox,
                        image = item.icon,
                        forced_width = args.icon_width,
                        forced_height = args.icon_height,
                    },
                    {
                        widget = wibox_widget.textbox,
                        text = item.name
                    },
                    layout = wibox_layout.fixed.horizontal,
                    spacing = args.icon_text_spacing
                }
            }
        }
        item_row:connect_signal("mouse::enter", function (c)
            c:set_bg(colors.dark1)
        end)
        item_row:connect_signal("mouse::leave", function (c)
            c:set_bg(colors.dark0)
        end)
        item_row:buttons(
            awful.util.table.join(
                awful.button({}, 1, function ()
                    args.on_click()
                end)
            )
        )
        table.insert(container, item_row)
    end
    return container
end

return list