local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local widget = require("util.widgets")
local helpers = require("helpers")
local icons = require("icons.default")
local gtable = require("gears.table")
local font = require("util.font")
local bicon = require("util.icon")
local mat_bg = require("util.mat-background")

-- widget for the popup
local mpc = require("widgets.mpc")({})
local volume_bar = require("widgets.volume")({ mode = "slider" })

-- beautiful vars
local bg = beautiful.widget_volume_bg or M.x.background
local font_button = M.f.button
local l = beautiful.widget_button_music_layout or 'horizontal'

-- for the popup
local fg_p = M.x.on_surface
local bg_p = M.x.surface
local padding = beautiful.widget_popup_padding or 1

local music_player_root = class()

function music_player_root:init(args)
  -- options
  self.fg = args.fg or beautiful.widget_volume_fg or M.x.on_background
  self.icon = args.icon or beautiful.widget_mpc_button_icon or { "", M.x.on_background }
  self.mode = args.mode or 'popup' -- possible values: block, popup, song
  self.wibar_position = args.wibar_position or beautiful.wibar_position or "top"
  self.wibar_size = args.wibar_size or beautiful.wibar_size or dpi(56)
  self.wposition = args.position or widget.check_popup_position(self.wibar_position)
  -- widgets
  --self.wicon = font.button(self.icon[1], self.icon[2])
  self.wicon = bicon({ icon = self.icon[1], fg = self.icon[2] })
  self.title = font.button("")
  self.artist = font.caption("")
  self.cover = widget.imagebox(90)
  self.time_pasted = font.caption("")
  self.widget = self:make_widget()
end

function music_player_root:make_widget()
  if self.mode == "block" then
    return self:make_block()
  elseif self.mode == "song" then
    return self:make_song()
  else
    return self:make_popup()
  end
end

function music_player_root:make_block()
  local mpc = require("widgets.mpc")({ no_margin = true }) -- mini block, no need margin
  self.title.align = "left"
  self.cover.forced_height = dpi(60)
  self.cover.forced_width = dpi(60)
  local w = wibox.widget {
    {
      self.cover,
      {
        nil,
        {
          {
            self.title,
            forced_height = dpi(20), -- one line
            left = dpi(10),
            widget = wibox.container.margin
          },
          mpc,
          layout = wibox.layout.fixed.vertical
        },
        expand = "none",
        layout = wibox.layout.align.vertical
      },
      layout = wibox.layout.align.horizontal
    },
    forced_height = 80,
    top = dpi(10), bottom = dpi(10), -- adjust in order to limit the name to one line
    widget = wibox.container.margin
  }
  self:signals()
  return w
end

function music_player_root:create_popup(w)
  self.cover.forced_height = dpi(200)
  self.cover.forced_width = dpi(200)
  self.cover.resize = true
  --self.cover.clip_shape = helpers.rrect(20) -- do not work ?
  self.title.forced_height = 20
  local img = wibox.widget {
    nil,
    {
      widget.centered(self.cover),
      widget.centered(mpc),
      spacing = dpi(8),
      layout = wibox.layout.fixed.vertical
    },
    expand = "none",
    layout = wibox.layout.align.horizontal
  }
  local desc = wibox.widget {
    self.title,
    self.artist,
    self.time_pasted,
    volume_bar,
    spacing = dpi(5),
    layout = wibox.layout.fixed.vertical
  }
  self.wpopup = awful.popup {
    widget = {
      {
        {
          img,
          desc,
          layout = wibox.layout.fixed.vertical
        },
        margins = dpi(14),
        forced_width = dpi(270),
        widget = wibox.container.margin
      },
      bg = M.x.on_surface .. M.e.dp01,
      widget = wibox.container.background
    },
    visible = false, -- do not show at start
    ontop = true,
    hide_on_right_click = true,
    preferred_positions = self.wposition,
    offset = { y = padding, x = padding }, -- no pasted on the bar
    bg = M.x.surface,
    shape = helpers.rrect(15)
  }

  -- attach popup to widget
  self.wpopup:bind_to_widget(w)
end

function music_player_root:make_popup()
  -- widget creation
  local button = self.wicon
  self:create_popup(button)
  self:signals()
  return widget.box(layout, { button })
end

-- update
function music_player_root:updates(mpd)
  -- default value
  local img = mpd.cover ~= "nil" and mpd.cover or icons["default_cover"]
  local artist = mpd.artist ~= nil and mpd.artist or 'Unknown'
  local title = mpd.title ~= nil and mpd.title or 'Unknown'
  local title_cut = #title > 20
    and string.sub(title, 1, 20)
    or title

  self.cover.image = img
  self.title.markup = helpers.colorize_text(title_cut, M.x.error)
  self.artist.markup = helpers.colorize_text("By "..artist, M.x.primary)
end

function music_player_root:update_time(mpd)
  self.time_pasted.markup = helpers.colorize_text(mpd.full_time, M.x.secondary)
end

-- signals
function music_player_root:signals()
  awesome.connect_signal("daemon::mpd", function(mpd)
    if mpd.cover then
      --naughty.notify({ text = tostring(mpd.cover) })
      self:updates(mpd)
    end
  end)
  awesome.connect_signal("daemon::mpd_time", function(mpd)
    self:update_time(mpd)
  end)
end

function music_player_root:make_song()
  local font = require("util.font")
  local icon = font.button(self.icon[1], self.icon[2])
  local w = wibox.widget {
    {
      {
        icon,
        self.title,
        spacing = dpi(8),
        layout = wibox.layout.fixed.horizontal
      },
      margins = dpi(12),
      widget = wibox.container.margin
    },
    widget = mat_bg({ color = M.x.error })
  }
  self:create_popup(w)
  self.wpopup.x = dpi(4)
  self.wpopup.y = self.wibar_size + dpi(4)
  self:signals()
  return w
end

-- herit
local music_player_widget = class(music_player_root)

function music_player_widget:init(args)
  music_player_root.init(self, args)
  return self.widget
end

return music_player_widget
