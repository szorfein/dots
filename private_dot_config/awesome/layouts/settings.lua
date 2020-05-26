local wibox = require("wibox")
local awful = require("awful")
local screen = require("awful.screen")
local table = require("gears.table")
local keygrabber = require("awful.keygrabber")
local font = require("utils.font")
local button = require("utils.button")
local spawn = require("awful.spawn")
local helper = require("utils.helper")
local app = require("utils.app")
local icons = require("config.icons")

local w = wibox.widget { layout = wibox.layout.fixed.vertical }

function settings_toggle()
  local s = screen.focused()
  if s.settings.visible then
    settings_hide()
  else
    s.settings.visible = true
  end
end

function settings_hide()
  local s = screen.focused()
  s.settings.visible = false
end

local setting_title = font.subtile_1('Settings')

local myapps = class()

function myapps:init(s)
  self.screen = s or screen.focused()
  self.height = screen.focused().geometry.height
  self.width = screen.focused().geometry.width

  s.settings = wibox({ visible = false, ontop = true, type = "dock", position = "top", screen = s })
  s.settings.bg = M.x.surface
  s.settings.x = self.width - dpi(256)
  s.settings.y = dpi(32)
  s.settings.height = dpi(400)
  s.settings.width = dpi(250)
  s.settings.shape = helper.rrect(10)

  s.settings:buttons(table.join(
  -- Middle click - Hide settings
  awful.button({}, 2, function()
    settings_hide()
  end),
  -- Right click - Hide settings
  awful.button({}, 3, function()
    settings_hide()
  end)
  ))

  s.settings:setup {
    nil,
    {
      setting_title,
      {
        {
          {
            require("widgets.volume")({ mode = "slider" }),
            require("widgets.brightness")({ mode = "slider" }),
            spacing = dpi(8),
            layout = wibox.layout.fixed.vertical
          },
          bg = M.x.on_surface .. "03", -- 1%
          shape = helper.rrect(4),
          widget = wibox.container.background
        },
        margins = dpi(10),
        widget = wibox.container.margin
      },
      layout = wibox.layout.fixed.vertical
    },
    expand = "none",
    layout = wibox.layout.align.vertical
  }
end

return myapps
