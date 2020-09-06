local wibox = require("wibox")
local modal = require("utils.modal")
local awful = require("awful")
local gtable = require("gears.table")
local font = require("utils.font")
local bicon = require("util.icon")
local mat_fg = require("utils.material.foreground")
local mat_bg = require("utils.material.background")

-- widgets
local volume = require("widgets.volume")({ mode = "slider" })
local brightness = require("widgets.brightness")({ mode = "slider" })

function nav_drawer_hide()
  local s = awful.screen.focused()
  s.nav_drawer.visible = false
end

function nav_drawer_show()
  local s = awful.screen.focused()
  s.nav_drawer.visible = true
end

local function gen_menu(elements)
  local w = wibox.widget { layout = wibox.layout.fixed.vertical }
  for k,v in pairs(elements) do
    local icon = font.icon(v[1])
    local text = font.body_2(v[2])
    local row = wibox.widget {
      {
        {
          {
            {
              {
                icon,
                text,
                spacing = 22,
                layout = wibox.layout.fixed.horizontal
              },
              nil,
              nil,
              layout = wibox.layout.align.horizontal
            },
            forced_height = 48,
            margins = 16,
            widget = wibox.container.margin,
          },
          widget = mat_fg({ color = M.x.on_surface, focus = M.x.primary }),
        },
        widget = mat_bg({ color = M.x.primary })
      },
      bg = M.x.surface,
      widget = wibox.container.background
    }
    row:buttons(gtable.join(
      awful.button({}, 1, v[3])
    ))
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
  { "", "Logout", function()
    exit_screen_show()
    nav_drawer_hide()
  end },
})

local header = wibox.widget {
  bicon({ icon = "", fg = M.x.on_surface, command = nav_drawer_hide }),
  layout = wibox.layout.fixed.horizontal
}

-- labels
local label_layout = font.subtile_1("Layouts")
label_layout.align = "left"
local label_setting = font.subtile_1("Settings")
label_setting.align = "left"

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

  local w = wibox.widget {
    {
      {
        {
          header,
          forced_height = 56,
          widget = wibox.container.margin
        },
        { 
          {
            layout = wibox.layout.fixed.vertical
          },
          { -- layout
            {
              label_layout,
              margins = 16,
              widget = wibox.container.margin
            },
            layout,
            layout = wibox.layout.fixed.vertical
          },
          { -- settings
            {
              label_setting,
              left = 16, top = 16,
              widget = wibox.container.margin
            },
            {
              {
                volume,
                brightness,
                layout = wibox.layout.fixed.vertical
              },
              margins = 16,
              widget = wibox.container.margin
            },
            layout = wibox.layout.fixed.vertical
          },
          spacing_widget = sep,
          spacing = 1,
          layout = wibox.layout.fixed.vertical
        },
        nil,
        forced_width = 256,
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
