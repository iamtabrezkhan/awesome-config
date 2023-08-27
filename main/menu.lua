local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup').widget
local beautiful = require('beautiful')

local _menu = {}
local _M = {}

local terminal = RC.vars.terminal
local editor = os.getenv("EDITOR") or "nano"
local editor_cmd = terminal .. " -e " .. editor

_menu.awesome = {
    {
        "Hotkeys",
        function ()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end
    },
    {
        "Awesome Manual",
        terminal .. " -e man awesome"
    },
    {
        "Edit Config",
        editor_cmd .. " " .. awesome.conffile
    }
}

function _M.get()
    local menu_items = {
        {
            "Awesome",
            _menu.awesome,
            beautiful.awesome_subicon
        },
        {
            "Open Terminal",
            terminal
        }
    }
    return menu_items
end

return setmetatable(
  {}, 
  { __call = function(_, ...) return _M.get(...) end }
)