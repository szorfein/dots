local helpers = require("helpers")
local abutton = require("awful.button")
local gtable = require("gears.table")
local font = require("util.font")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local mat_bg = require("util.mat-background")
local mat_fg = require("util.mat-foreground")

local root_icon = class()

function root_icon:init(args)
  -- options
  self.fg = args.fg or M.x.on_background
  self.bg = args.bg or M.x.background
  self.icon = args.icon or ""
  self.command = args.command or nil
  self.no_margin = args.no_margin or nil -- boolean
  -- base widgets
  self.wicon = font.button_v2(self.icon)
  self.w = self:spec()
end

function root_icon:action()
  if not self.command then return end
  self.w:buttons(gtable.join(
    awful.button({}, 1, function()
      self.command()
    end)
  ))
end

function root_icon:margins()
  self.wibar_size = beautiful.wibar_size or 56
  if self.no_margin then self.wibar_size = 0 end
  local margins = self.wibar_size < 30 and 0 or 12
  return wibox.widget {
    margins = margins,
    widget = wibox.container.margin
  }
end

-- https://material.io/design/iconography/system-icons.html#system-icon-metrics
function root_icon:spec()
  self.wicon.forced_height = 24
  self.wicon.forced_width = 24
  return wibox.widget {
    {
      {
        --{
          self.wicon,
          --  bg = M.x.on_surface .. M.e.dp02,
          --  widget = wibox.container.background
          --},
          widget = self:margins()
        },
        widget = mat_fg({ color = self.fg }),
    },
    --bg = M.x.on_surface .. M.e.dp01,
    widget = mat_bg({ color = self.fg })
  }
end

local new_icon = class(root_icon)

function new_icon:init(args)
  root_icon.init(self, args)
  root_icon.action(self)
  return self.w
end

return new_icon
