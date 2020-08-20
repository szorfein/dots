local beautiful = require("beautiful")
local widget = require("util.widgets")
local button = require("util.buttons")
local helpers = require("helpers")
local aspawn = require("awful.spawn")
local wibox = require("wibox")
local btext = require("util.mat-button")
local bicon = require("util.icon")

-- beautiful vars
local icon_prev = beautiful.widget_mpc_prev_icon or ""
local icon_pause = beautiful.widget_mpc_pause_icon or ""
local icon_play = beautiful.widget_mpc_play_icon or ""
local icon_stop = beautiful.widget_mpc_stop_icon or ""
local icon_next = beautiful.widget_mpc_next_icon or ""
-- for titlebar
local icon_ncmpcpp_prev = beautiful.widget_ncmpcpp_prev or ' ≪ '
local icon_ncmpcpp_toggle = beautiful.widget_ncmpcpp_toggle or ' ⊡ '
local icon_ncmpcpp_next = beautiful.widget_ncmpcpp_next or ' ≫ '

-- command
local prev_cmd = function() aspawn("mpc prev", false) end
local toggle_cmd = function() aspawn("mpc toggle", false) end
local next_cmd = function() aspawn("mpc next", false) end

-- root
local mpc_root = class()

function mpc_root:init(args)
  -- options
  self.mode = args.mode or 'text' -- possible values: text, titlebar
  self.font = args.font or M.f.button
  self.fg = args.fg or M.x.primary
  self.overlay = args.overlay or M.x.primary -- bg for the hover
  self.spacing = args.spacing or dpi(1)
  self.layout = args.layout or beautiful.widget_mpc_layout or 'horizontal' -- possible values: horizontal , vertical
  self.no_margin = args.no_margin or nil -- boolean
  -- base widgets
  self:base_widget()
  self.w = self:make_widget()
end

function mpc_root:base_widget()
  if self.mode == "titlebar" then
    self.wicon_prev = btext({ 
      font_icon = self.font, fg_icon = self.fg, icon = icon_ncmpcpp_prev,
      overlay = self.overlay, command = prev_cmd
    })
    self.wicon_toggle = btext({
      font_icon = self.font, fg_icon = self.fg, icon = icon_ncmpcpp_toggle,
      overlay = self.overlay, command = toggle_cmd
    })
    self.wicon_next = btext({
      font_icon = self.font, fg_icon = self.fg, icon = icon_ncmpcpp_next,
      overlay = self.overlay, command = next_cmd
    })
  else
    self.wicon_prev = bicon({
      fg = self.fg, icon = icon_prev, command = prev_cmd, no_margin = self.no_margin
    })
    self.wicon_toggle = bicon({
      fg = self.fg, icon = icon_play, command = toggle_cmd, no_margin = self.no_margin
    })
    self.wicon_next = bicon({
      fg = self.fg, icon = icon_next, command = next_cmd, no_margin = self.no_margin
    })
  end
end

function mpc_root:make_widget()
  if self.mode == "titlebar" then
    return self:make_for_titlebar()
  else
    return self:make_text()
  end
end

function mpc_root:make_text()
  local w
  local w = widget.box(self.want_layout,
    { self.wicon_prev, self.wicon_toggle, self.wicon_next }, 0)

  awesome.connect_signal("daemon::mpd", function(mpd)
    if (mpd.status == "playing") then
      self.wicon_toggle.markup = helpers.colorize_text(icon_pause, self.fg)
    elseif (mpd.status == "paused") then
      self.wicon_toggle.markup = helpers.colorize_text(icon_play, self.fg)
    elseif (mpd.status == "void") then
      self.wicon_toggle.markup = helpers.colorize_text(icon_play, self.fg)
    else
      self.wicon_toggle.markup = helpers.colorize_text(icon_stop, self.fg)
    end
  end)

  return w
end

function mpc_root:make_for_titlebar()
  local w = wibox.widget {
    nil,
    widget.box('horizontal', { self.wicon_prev, self.wicon_toggle, self.wicon_next }, self.spacing),
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
  }
  return w
end

-- herit
local mpc_widget = class(mpc_root)

function mpc_widget:init(args)
  mpc_root.init(self, args)
  return self.w
end

return mpc_widget
