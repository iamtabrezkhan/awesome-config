local wibox_widget = require("wibox.widget")
local wibox_layout = require("wibox.layout")
local awful = require('awful')
local naughty = require("naughty")
local config_path = awful.util.getdir("config")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local volumne_icon = config_path .. "volume.png"
local volumne_mute_icon = config_path .. "volume-mute.png"
local cmd = "pamixer --get-volume; pamixer --get-mute"

local function get_volume_label(str)
    local lines = {}
    for line in str:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    local volume_amount = lines[1]
    local is_mute = lines[2]
    if is_mute == "true" then
        return "0"
    else
        return volume_amount
    end
end

local function get_volume_icon(arg)
    if arg == "0" then
        return volumne_mute_icon
    else
        return volumne_icon
    end
end

function _M.get()
    local icon = wibox_widget {
        image = volumne_icon,
        widget = wibox_widget.imagebox
    }

    local volumne_text = wibox_widget {
        text = "10%",
        widget = wibox_widget.textbox
    }

    awful.spawn.easy_async_with_shell(cmd, function(out)
        local v_text = get_volume_label(out)
        local v_icon = get_volume_icon(v_text)
        icon:set_image(v_icon)
        volumne_text:set_text(v_text .. "%")
    end)

    awesome.connect_signal("system:volumeupdate", function(args)
        awful.spawn.easy_async_with_shell(cmd, function(out)
            local v_text = get_volume_label(out)
            local v_icon = get_volume_icon(v_text)
            icon:set_image(v_icon)
            volumne_text:set_text(v_text .. "%")
        end)
    end)

    local usage_stat = {
        icon,
        volumne_text,
        layout = wibox_layout.fixed.horizontal,
        spacing = 4
    }

    return usage_stat
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
