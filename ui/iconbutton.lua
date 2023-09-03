local wibox_widget = require("wibox.widget")
local wibox_container = require("wibox.container")
local gshape = require("gears.shape")

local function iconButton(args)
    local icon = wibox_widget {
        image = args.icon,
        widget = wibox_widget.imagebox,
        id = args.id
    }
    local container = wibox_widget {
        icon,
        widget = wibox_container.margin,
        margins = args.margins,
    }
    local background = wibox_widget {
        container,
        widget = wibox_container.background,
        shape = function(cr, w, h)
            gshape.rounded_rect(cr, w, h, args.radius)
        end,
        bg = args.bg,
        fg = args.fg,
    }

    -- signals --------------------------------------------
    background:connect_signal("mouse::enter", function(b)
        b:set_bg(args.bg_hover)
    end)
    background:connect_signal("mouse::leave", function(b)
        b:set_bg(args.bg)
    end)
    local old_cursor, old_wibox
    background:connect_signal("mouse::enter", function()
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.cursor = "hand2"
    end)
    background:connect_signal("mouse::leave", function()
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)
    background:connect_signal("button::press", function(b)
        args.on_click()
    end)
    return background
end

return iconButton
