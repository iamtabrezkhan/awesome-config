-- Standard awesome library
local awful = require("awful")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local config_path = awful.util.getdir("config")

local my_tags = {
  { icon = config_path .. "/code.png" },
  { icon = config_path .. "/chrome.png" },
}

function _M.get ()
  local tags = {}

  awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    for i, t in ipairs(my_tags) do
      local tag = awful.tag.add("", { icon = t.icon, screen = s, layout = RC.layouts[1], layouts = RC.layouts })
      if i == 1 then
        tag.selected = true
      end
    end
  end)
  
  return tags
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
