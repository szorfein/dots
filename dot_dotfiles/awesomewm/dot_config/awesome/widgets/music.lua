local wibox = require("wibox")
local awful = require("awful")
local button = require("utils.button")
local font = require("utils.font")
local shape = require("gears.shape")
local surface = require("gears.surface")
local noti = require("utils.noti")
local progressbar = require("utils.progressbar")

local music_root = class()

function music_root:init()
  self.title = font.body_1('')
  self.artist = font.body_2('')
  self.progress = progressbar.horiz()
  self.cover = wibox.widget {
    resize = true,
    widget = wibox.widget.imagebox
  }
  self.w = button({
    fg_icon = M.x.secondary,
    icon = font.icon(""),
    layout = "horizontal",
    margins = dpi(4)
  })
  self:gen_popup()
  self:signals()
end

function music_root:gen_popup()
  local w = awful.popup {
    widget = {
      {
        self.progress,
        self.cover,
        layout = wibox.layout.fixed.vertical
      },
      {
        {
          self.title,
          self.artist,
          forced_height = dpi(76),
          layout = wibox.layout.fixed.vertical
        },
        margins = dpi(8),
        widget = wibox.container.margin
      },
      {
        nil,
        require("widgets.mpc")({}),
        expand = "none",
        layout = wibox.layout.align.horizontal
      },
      expand = "none",
      forced_height = dpi(200),
      forced_width = dpi(200),
      layout = wibox.layout.align.vertical
    },
    hide_on_right_click = true,
    visible = false,
    ontop = true,
    bg = M.x.surface,
  }
  w:bind_to_widget(self.w)
end

function music_root:signals()
  awesome.connect_signal("daemon::mpd_infos", function(title, artist)
    self.title.text = #title > 20
      and string.sub(title, 1, 20)
      or title
    if not (artist == nil or artist == '') then
      self.artist.text = "by " .. artist
    else
      self.artist.text = artist
    end
  end)
  awesome.connect_signal("daemon::mpd_cover", function(cover)
    --noti.info('in signal cover ' .. cover) 
    --self.cover:set_image(cover)
    --self.cover:emit_signal("widget::redraw_needed")
    --self.cover:emit_signal("widget::layout_changed")
    self.cover:set_image(cover)
  end)
  awesome.connect_signal("daemon::mpd_time", function(time)
    self.progress:set_value(time)
  end)
end

local music_widget = class(music_root)

function music_widget:init()
  music_root.init(self)
  return self.w
end

return music_widget
