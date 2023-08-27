-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

local menubar = require("menubar")

-- global library
RC = {}
-- user variables
RC.vars = require('main.user-variables')

-- {{{ Error handling
require('main.error-handling');
-- }}}

require('main.theme')

-- main library
local main = {
    layouts = require('main.layouts'),
    tags = require('main.tags'),
    menu = require('main.menu'),
    rules = require('main.rules')
}
-- bindings library
local bindings = {
    bindtotags = require('bindings.bindtotags'),
    globalbuttons = require('bindings.globalbuttons'),
    clientbuttons = require('bindings.clientbuttons'),
    globalkeys = require('bindings.globalkeys'),
    clientkeys = require('bindings.clientkeys')
}
RC.layouts = main.layouts()
RC.tags = main.tags()
RC.mainmenu = awful.menu({ items = main.menu() })
RC.launcher = awful.widget.launcher(
    {
        image = beautiful.awesome_icon,
        menu = RC.mainmenu
    }
)
menubar.utils.terminal = RC.vars.terminal

RC.globalkeys = bindings.globalkeys()
RC.globalkeys = bindings.bindtotags(RC.globalkeys)

root.buttons(bindings.globalbuttons())
root.keys(RC.globalkeys)

awful.layout.layouts = RC.layouts;

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()


require('deco.statusbar')

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = main.rules(bindings.clientkeys(), bindings.clientbuttons())

require("main.signals")