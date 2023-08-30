-- Standard awesome library
local gears = require("gears")
local awful     = require("awful")
local colors    = require("themes.default.colors")

-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
  wallpaper = require("deco.wallpaper"),
  taglist   = require("deco.taglist"),
  tasklist  = require("deco.tasklist"),
  usage = require('deco.usage'),
  power = require('deco.power')
}

local taglist_buttons  = deco.taglist()
local tasklist_buttons = deco.tasklist()

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock(
  "%a %b %d, %I:%M ",
  60,
  "Z"
)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)
  ))

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = tasklist_buttons,
    style    = {
        shape_border_width = 1,
        shape_border_color = colors.bg,
        shape  = gears.shape.rounded_bar,
        shap_clip = true,
    },
    layout   = {
        spacing = 2,
        layout  = wibox.layout.fixed.horizontal
    },
    widget_template = {
        {
            {
              {
                id     = 'icon_role',
                widget = wibox.widget.imagebox,
              },
              widget  = wibox.container.background,
            },
            margins = 6,
            widget = wibox.container.margin
        },
        id = 'background_role',
        widget = wibox.container.background,
    },
}

  -- Create the wibox
  s.mywibox = awful.wibar({
    position = "top",
    screen = s,
    height = 52,
  })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.container.margin,
    top = 8, bottom = 2,
    left = 8, right = 8,
    {
      layout = wibox.container.background,
      bg = colors.bg,
      shape = function (cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 50)
      end,
      shape_clip = true,
      shape_border_width = 2,
      shape_border_color = colors.dark1,
      {
        layout = wibox.container.margin,
        top = 6, bottom = 6,
        left = 16, right = 16,
        {
          layout = wibox.layout.align.horizontal,
          { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            {
              layout = wibox.container.margin,
              right = 4,
              RC.launcher
            },
            s.mytaglist,
            s.mypromptbox,
          },
          s.mytasklist, -- Middle widget
          { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            deco.usage(),
            -- mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            deco.power(),
            s.mylayoutbox
          }
        }
      }
    }
  }
end)
-- }}}
