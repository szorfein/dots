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

-- work only on a tile layout
local function screen_padding(nb)
  local s = screen.focused()
  local v = s.padding.top + nb
  screen.padding(s, { top = v, right = v, bottom = v, left = v })
end

local padding = wibox.widget {
  nil,
  {
    button({
      fg_icon = M.x.on_surface,
      icon = font.icon(""),
      command = function() screen_padding(-10) end,
    }),
    button({
      fg_icon = M.x.on_surface,
      icon = font.icon(""),
      command = function() screen_padding(10) end,
    }),
    layout = wibox.layout.fixed.horizontal
  },
  expand = "none",
  layout = wibox.layout.align.horizontal
}

local gapping = wibox.widget {
  nil,
  {
    button({
      fg_icon = M.x.on_surface,
      icon = font.icon(""),
      command = function() awful.tag.incgap(-2, nil) end,
    }),
    button({
      fg_icon = M.x.on_surface,
      icon = font.icon(""),
      command = function() awful.tag.incgap(2, nil) end,
    }),
    layout = wibox.layout.fixed.horizontal
  },
  expand = "none",
  layout = wibox.layout.align.horizontal
}

local box = function(w)
  return wibox.widget {
    {
      w,
      bg = M.x.on_surface .. "03", -- 1%
      shape = helper.rrect(4),
      widget = wibox.container.background
    },
    margins = dpi(10),
    widget = wibox.container.margin
  }
end

local myapps = class()

function myapps:init(s)
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
      font.subtile_1("Pads"),
      box({
        padding,
        layout = wibox.layout.fixed.vertical
      }),
      font.subtile_1("Gaps"),
      box({
        gapping,
        layout = wibox.layout.fixed.vertical
      }),
      font.subtile_1("Others"),
      box({
        require("widgets.volume")({ mode = "slider" }),
        require("widgets.brightness")({ mode = "slider" }),
        spacing = dpi(8),
        layout = wibox.layout.fixed.vertical
      }),
      layout = wibox.layout.fixed.vertical
    },
    expand = "none",
    layout = wibox.layout.align.vertical
  }
end

return myapps
