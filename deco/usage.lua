local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require('gears')
local awful = require('awful')

local config_path = awful.util.getdir("config")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function format_memory(memory_mb)
    if memory_mb >= 1024 then
        return string.format("%.2f GB", memory_mb / 1024)
    else
        return string.format("%.2f MB", memory_mb)
    end
end

local function get_gpu_text (text)
    local values = {}
    for value in text:gmatch("[^,]+") do
        table.insert(values, value:match("^%s*(.-)%s*$")) -- Trim whitespace
    end
    local gpu_name = values[1]
    local total_mem = format_memory(tonumber(values[2]))
    local used_mem = format_memory(tonumber(values[3]))
    local temp = values[4]
    return gpu_name .. " | " .. used_mem .. "/" .. total_mem .. " | " .. temp .. "°C"
end

local items = {
    {
        id = "gpu",
        icon = config_path .. "/gpu.png",
        update = function (w)
            local cmd = "nvidia-smi --query-gpu=name,memory.total,memory.used,temperature.gpu --format=csv,noheader,nounits"
            local err = awful.spawn. easy_async_with_shell(
                cmd,
                function (out)
                    local gpu_text = get_gpu_text(out)
                    w:set_text(gpu_text)
                end
            )
        end
    },
    {
        id = "cpu",
        icon = config_path .. "/cpu.png",
        update = function (w)
            local cmd = "mpstat 1 1 | awk '" .. '/^Average/ {print 100-$NF"' .. "%" .. '"' .. "}'"
            local err = awful.spawn. easy_async_with_shell(
                cmd,
                function (out)
                    w:set_text(out)
                end
            )
        end
    },
    {
        id = "cputemp",
        icon = config_path .. "/temp-cpu.png",
        update = function (w)
            local cmd = "acpi -t | awk '{print $4 " .. '"°C"' .. "}'"
            local err = awful.spawn. easy_async_with_shell(
                cmd,
                function (out)
                    w:set_text(out)
                end
            )
        end
    },
    {
        id = "wifi",
        icon = config_path .. "/wifi.png",
        id_image = "wifi",
        update = function (w)
            local cmd = "curl -Is https://www.google.com | head -n 1"
            local err = awful.spawn. easy_async_with_shell(
                cmd,
                function (out)
                    if out:match("200") then
                        w:set_image(config_path .. "/wifi-active.png")
                    else
                        w:set_image(config_path .. "/wifi.png")
                    end
                end
            )
        end
    }
}

function _M.get()
    local usage_widget_items = {}
    for key, value in pairs(items) do
        table.insert(
            usage_widget_items,
            {
                {
                    {
                        id = value.id_image,
                        widget = wibox.widget.imagebox,
                        image = value.icon
                    },
                    {
                        id = value.id,
                        text = "",
                        widget = wibox.widget.textbox,
                    },
                    spacing = 4,
                    layout = wibox.layout.fixed.horizontal
                },
                right = 8,
                layout = wibox.container.margin
            }
        )
    end
    local my_button = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        table.unpack(usage_widget_items),
    }

    gears.timer {
        timeout = 5,
        call_now = true,
        autostart = true,
        callback = function ()
            -- gpu
            local gpuW = my_button:get_children_by_id("gpu")[1]
            items[1].update(gpuW)
            -- cpu
            local cpuW = my_button:get_children_by_id("cpu")[1]
            items[2].update(cpuW)
            -- wifi
            local wifiW = my_button:get_children_by_id("wifi")[1]
            items[4].update(wifiW)
        end
    }

    gears.timer {
        timeout = 60,
        call_now = true,
        autostart = true,
        callback = function ()
            local tempW = my_button:get_children_by_id("cputemp")[1]
            items[3].update(tempW)
        end
    }

    local usage_stat = {
        my_button,
        layout = wibox.layout.fixed.horizontal
    }

    return usage_stat
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
