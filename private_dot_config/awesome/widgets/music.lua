local wibox = require("wibox")
local awful = require("awful")
local button = require("utils.button")
local font = require("utils.font")
local shape = require("gears.shape")
local surface = require("gears.surface")
local noti = require("utils.noti")

local music_root = class()

function music_root:init()
  self.title = font.body_2('')
  self.artist = font.body_2('')
  self.cover = wibox.widget.imagebox(nil, true)
  self.cover.forced_width = 200
  self.w = button({
    fg_icon = M.x.secondary,
    icon = font.icon(""),
    layout = "horizontal",
    margins = dpi(4)
  })
  self:gen_popup()
  self:signals()
end

function music_root:signals()
  awesome.connect_signal("daemon::mpd_infos", function(title, artist)
    self.artist.text = artist
    self.title.text = title
  end)
  awesome.connect_signal("daemon::mpd_cover", function(cover)
    --noti.info('in signal cover ' .. cover) 
    --self.cover:set_image(cover)
    --self.cover:emit_signal("widget::redraw_needed")
    --self.cover:emit_signal("widget::layout_changed")
    self.cover.image = cover
  end)
end

function music_root:gen_popup()
  local w = awful.popup {
    widget = {
      {
        nil,
        {
          self.title,
          self.artist,
          self.cover,
          layout = wibox.layout.fixed.vertical
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
      },
      forced_width = 200,
      forced_height = 200,
      layout = wibox.layout.fixed.vertical
    },
    hide_on_right_click = true,
    visible = false,
    ontop = true,
    bg = M.x.surface,
  }
  w:bind_to_widget(self.w)
end

local music_widget = class(music_root)

function music_widget:init()
  music_root.init(self)
  return self.w
end

return music_widget
