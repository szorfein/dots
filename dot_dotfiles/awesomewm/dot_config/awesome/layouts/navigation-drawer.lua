local wibox = require("wibox")
local modal = require("utils.modal")
local awful = require("awful")
local gtable = require("gears.table")
local font = require("utils.font")
local button = require("utils.button")
local ufont = require("utils.font")
local mat_fg = require("utils.material.foreground")
local mat_bg = require("utils.material.background")
local beautiful = require("beautiful")

function nav_drawer_hide()
  local s = awful.screen.focused()
  s.nav_drawer.visible = false
end

function nav_drawer_show()
  local s = awful.screen.focused()
  s.nav_drawer.visible = true
end

local function gen_menu(elements)
  local w = wibox.widget { layout = wibox.layout.fixed.horizontal }
  for k,v in pairs(elements) do
    local text = font.body_2(v[2])
    local row = button({
      icon = font.h5(v[1]),
      --height = dpi(60),
      command = v[3]
    })
    w:add(row)
  end
  return w
end

local layout = gen_menu({
  { "", "Start Screen", function()
    local s = awful.screen.focused()
    s.start_screen.visible = not s.start_screen.visible
    nav_drawer_hide()
  end },
  { "", "Monitor", function()
    local s = awful.screen.focused()
    s.monitor_bar.visible = not s.monitor_bar.visible
    nav_drawer_hide()
  end },
  { "", "Lock", function()
    lock_screen_show()
    nav_drawer_hide()
  end },
})

local logout = button({
  fg_icon = M.x.error,
  icon = ufont.h5(""),
  command = function()
    exit_screen_show()
    nav_drawer_hide()
  end
})

local header = wibox.widget {
  button({
    icon = ufont.body_2(""),
    command = nav_drawer_hide
  }),
  nil,
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}

local sep = wibox.widget {
  orientation = "horizontal",
  color  = M.x.on_surface .. "33", -- 20%
  border_width = 1,
  border_color = M.x.on_surface,
  widget = wibox.widget.separator
}

local nav_drawer = class()

function nav_drawer:init(s)

  s.nav_drawer = modal:init(s)
  modal:add_buttons(nav_drawer_hide)

  local layout_widget = wibox.widget {
    layout,
    spacing = 10,
    layout = wibox.layout.fixed.vertical
  }

  local w = wibox.widget {
    {
      {
        {
          header,
          forced_height = beautiful.wibar_size or dpi(36),
          widget = wibox.container.margin
        },
          --spacing_widget = sep,
          --spacing = 1,
        {
          {
            nil,
            layout_widget,
            nil,
            expand = "none",
            layout = wibox.layout.align.horizontal
          },
          {
            require("widgets.music")(),
            margins = 8,
            widget = wibox.container.margin
          },
          {
            nil,
            logout,
            forced_width = dpi(40),
            expand = "none",
            layout = wibox.layout.align.horizontal
          },
          spacing = dpi(20),
          layout = wibox.layout.fixed.vertical
        },
        nil,
        forced_width = 256,
        expand = "none",
        layout = wibox.layout.align.vertical
      },
      widget = wibox.container.margin
    },
    bg = M.x.surface,
    widget = wibox.container.background
  }

  modal:run_left(w)
end

return nav_drawer
