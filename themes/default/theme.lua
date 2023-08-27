local awful = require("awful")
awful.util = require("awful.util")

theme_path = awful.util.getdir("config") .. "/themes/default/"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- default variables

theme = {}

dofile(theme_path .. "elements.lua")
dofile(theme_path .. "titlebar.lua")
dofile(theme_path .. "layouts.lua")

theme.wallpaper          = theme_path .. "background.jpg"
theme.awesome_icon       = theme_path .. "launcher/logo_void_black.png"
theme.awesome_subicon    = theme_path .. "launcher/logo_void_black.png"

return theme