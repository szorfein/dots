local wibox = require("wibox")
local awful = require("awful")
local gtable = require("gears.table")
local widget = require("util.widgets")
local beautiful = require("beautiful")
local helpers = require("helpers")
local font = require("util.font")
local mat_bg = require("util.mat-background")

local mat_button = class()

-- opacity color on dark theme
-- https://material.io/design/iconography/system-icons.html#color
local mat_mode = { text = {}, contained = {}, outlined = {} }
mat_mode.text.margin = { right = 8, left = 8 }
mat_mode.text.fg = { disabled = 60, hovered = 87 , focused = 100 }
mat_mode.contained.margin = { right = 16, left = 16 }
mat_mode.contained.fg = { disabled = 90, hovered = 95 , focused = 100 }
mat_mode.outlined.margin = { right = 16, left = 16 }
mat_mode.outlined.fg = { disabled = 60, hovered = 87 , focused = 100 }

function mat_button:init(args)
  -- options
  self.font_text = args.font_text or M.f.button
  self.font_icon = args.font_icon or M.f.h1
  self.icon = args.icon or ""  
  self.text = args.text or ""
  self.fg_text = M.x[args.fg_text] or M.x.on_surface
  self.fg_icon = M.x[args.fg_icon] or M.x.on_surface
  self.bg = M.x[args.bg] or M.x.surface
  self.layout = args.layout or "vertical"
  self.rrect = args.rrect or 10
  self.width = args.width or nil
  self.height = args.height or nil -- default height 36
  self.spacing = args.spacing or 0
  self.command = args.command or nil
  self.overlay = M.x[args.overlay] or M.x.on_primary
  -- button mode https://material.io/components/buttons/#
  self.mode = args.mode or 'text' -- mode are: contained , outlined or text
  -- widgets
  self.wicon = widget.create_text(self.icon, self.fg_icon, self.font_icon)
  self.wtext = args.wtext or font.button(self.text, self.fg_text)
  self.background = wibox.widget {
    bg = self.bg,
    shape = helpers.rrect(self.rrect),
    widget = wibox.container.background
  }
  self.margin = wibox.widget {
    top = 1, bottom = 1,
    left = mat_mode[self.mode].margin.left,
    right = mat_mode[self.mode].margin.right,
    forced_height = self.height,
    forced_width = self.width,
    widget = wibox.container.margin
  }
  self.w = self:make_widget()
end

function mat_button:make_widget()
  if self.mode == "contained" then
    return wibox.widget {
      {
        {
          {
            self.wicon,
            self.wtext,
            spacing = dpi(self.spacing),
            layout = wibox.layout.fixed[self.layout],
          },
          widget = self.margin
        },
        {
          {
            image = nil,
            widget = wibox.widget.imagebox
          },
          widget = mat_bg({ color = self.overlay, shape = helpers.rrect(self.rrect) }),
        },
        layout = wibox.layout.stack
      },
      widget = self.background
    }
  else
    return wibox.widget {
      {
        {
          self.wicon,
          self.wtext,
          layout = wibox.layout.fixed[self.layout],
        },
        widget = self.margin
      },
      widget = mat_bg({ color = self.overlay, shape = helpers.rrect(self.rrect) }),
    }
  end
end

function mat_button:add_action()
  self.w:buttons(gtable.join(
    awful.button({}, 1, function() 
      self.command()
    end)
  ))
end

function mat_button:hover()
  self.wicon.markup = helpers.colorize_text(self.icon, self.fg_icon, mat_mode[self.mode].fg.disabled)
  self.wtext.markup = helpers.colorize_text(self.text, self.fg_text, mat_mode[self.mode].fg.disabled)

  self.w:connect_signal("mouse::leave", function() 
    self.wicon.markup = helpers.colorize_text(self.icon, self.fg_icon, mat_mode[self.mode].fg.disabled)
    self.wtext.markup = helpers.colorize_text(self.text, self.fg_text, mat_mode[self.mode].fg.disabled)
  end)
  self.w:connect_signal("mouse::enter", function() 
    self.wicon.markup = helpers.colorize_text(self.icon, self.fg_icon, mat_mode[self.mode].fg.focused)
    self.wtext.markup = helpers.colorize_text(self.text, self.fg_text, mat_mode[self.mode].fg.focused)
  end)
  self.w:connect_signal("button::release", function() 
    self.wicon.markup = helpers.colorize_text(self.icon, self.fg_icon, mat_mode[self.mode].fg.hovered)
    self.wtext.markup = helpers.colorize_text(self.text, self.fg_text, mat_mode[self.mode].fg.hovered)
  end)
  self.w:connect_signal("button::press", function()
    self.wicon.markup = helpers.colorize_text(self.icon, self.fg_icon)
    self.wtext.markup = helpers.colorize_text(self.text, self.fg_text)
  end)
end

local new_button = class(mat_button)

function new_button:init(args)
  mat_button.init(self, args)
  mat_button.add_action(self)
  mat_button.hover(self)
  return self.w
end

return new_button
