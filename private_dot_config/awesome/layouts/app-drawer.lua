local wibox = require("wibox")
local awful = require("awful")
local table = require("gears.table")
local keygrabber = require("awful.keygrabber")
local font = require("utils.font")
local button = require("utils.button")
local spawn = require("awful.spawn")
local helper = require("utils.helper")
local app = require("utils.app")
local icons = require("config.icons")

local w = wibox.widget { forced_num_cols = 3, expand = true, orientation = "vertical", layout = wibox.layout.grid }
local w_fav = wibox.widget { forced_num_cols = 3, expand = true, orientation = "vertical", layout = wibox.layout.grid }
local app_drawer_grabber

function app_drawer_toggle()
  local s = awful.screen.focused()
  if s.app_drawer.visible then
    app_drawer_hide()
  else
    s.app_drawer.visible = true
    key_grabber()
  end
end

function app_drawer_hide()
  local s = awful.screen.focused()
  s.app_drawer.visible = false
  keygrabber.stop(app_drawer_grabber)
end

local function exe(cmd)
  app.start(cmd)
  app_drawer_hide()
end

local function shell(cmd)
  app.shell(cmd)
  app_drawer_hide()
end

local function web(link)
  app.web(link)
  app_drawer_hide()
end

-- Favorite widget, shortcut available on all tags
-- only favorite have keybindings for now
local fav_title = font.subtile_1('Favorite')
local favorite = {
  { name = "Xst", icon = icons["xst"], color = M.x.primary_variant_1, exec = function() exe("xst") end },
  { name = "Tmux", icon = icons["tmux"], color = M.x.primary, exec = function() shell("tmux") end },
  { name = "Vifm", icon = icons["vifm"], color = M.x.primary_variant_2, exec = function() shell("vifm") end },
  { name = "Scrot", icon = icons["scrot"], color = M.x.secondary_variant_1, exec = function() exe("scrot -q100 -d3") end },
  keybindings = {
    { {}, 'x', function() exe("xst") end },
    { {}, 't', function() shell("tmux") end },
    { {}, 'v', function() shell("vifm") end },
    { {}, 's', function() exe("scrot -q100 -d3") end },
  }
}

-- Additional shortcut by tags
local my_apps = {}
local ntags = 1
local w_title = font.subtile_1('')

-- tag for web
my_apps[2] = {
  title = "Web",
  { name = "Github", icon = icons["github"], color = M.x.primary_variant_1, exec = function() web("https://github.com/szorfein") end },
  { name = "Reddit", icon = icons["reddit"], color = M.x.primary, exec = function() web("https://reddit.com/u/szorfein") end }
}

function key_grabber()
  local s = awful.screen.focused()

  local grabber = keygrabber {
    keybindings = favorite.keybindings,
    stop_key = "Escape",
    stop_callback = function() app_drawer_hide() end,
  }

  if grabber.is_running and s.app_drawer.visible == false then
    grabber:stop()
  elseif s.app_drawer.visible == false then
    grabber:stop()
  else
    grabber:start()
  end
end

local function build_favorite()
  w_fav:reset()
  for _,v in ipairs(favorite) do
    local app_icon = button({
      fg_icon = v.color,
      icon = font.h5(v.icon),
      text = font.caption(v.name),
      width = 70,
      command = function() v.exec() end
    })
    w_fav:add(
      app_icon
    )
  end
end

local function build_my_apps(index)
  if not my_apps[index] then return end
  w:reset()
  w_title.text = my_apps[index].title
  for _,v in ipairs(my_apps[index]) do
    local app_icon = button({
      fg_icon = v.color,
      icon = font.h5(v.icon),
      text = font.caption(v.name),
      width = 70,
      command = function() v.exec() end
    })
    w:add(
      app_icon
    )
  end
end

function gen_menu(index)
  build_favorite()
  build_my_apps(index)
end

function update_app_drawer(desired_tag)
  local s = awful.screen.focused()
  local d = tonumber(desired_tag) or nil
  local curr_tag = s.selected_tag
  if d ~= nil then
    gen_menu(d)
  elseif curr_tag ~= nil then
    gen_menu(curr_tag.index)
  else -- fallback
    for i = 1, ntags do
      if tag then
        if curr_tag == s.tags[i] then
          gen_menu(i)
          break
        end
      end
    end
  end
end

-- exit
local exit_button = button({
  fg_icon = M.x.error,
  icon = font.icon(""),
  text = font.button("Logout"),
  command = function()
    app_drawer_hide() -- before for kill the keygrabber
    exit_screen_show()
  end,
  spacing = dpi(4),
  layout = "horizontal"
})

local myapps = class()

function myapps:init(s)
  s.app_drawer = wibox({ visible = false, ontop = true, type = "dock", position = "top", screen = s })
  s.app_drawer.bg = M.x.surface
  s.app_drawer.x = dpi(2)
  s.app_drawer.y = dpi(32)
  s.app_drawer.height = dpi(400)
  s.app_drawer.width = dpi(250)
  s.app_drawer.shape = helper.rrect(10)

  s.app_drawer:buttons(table.join(
  -- Middle click - Hide app_drawer
  awful.button({}, 2, function()
    app_drawer_hide()
  end),
  -- Right click - Hide app_drawer
  awful.button({}, 3, function()
    app_drawer_hide()
  end)
  ))

  s.app_drawer:setup {
    nil,
    {
      fav_title,
      {
        {
          w_fav,
          bg = M.x.on_surface .. '03', -- 1%
          shape = helper.rrect(6),
          widget = wibox.container.background
        },
        margins = dpi(10),
        widget = wibox.container.margin
      },
      w_title,
      {
        {
          w,
          bg = M.x.on_surface .. '03', -- 1%
          shape = helper.rrect(6),
          widget = wibox.container.background
        },
        margins = dpi(10),
        widget = wibox.container.margin
      },
      { nil, exit_button, expand = "none", layout = wibox.layout.align.horizontal },
      spacing = dpi(8),
      layout = wibox.layout.fixed.vertical
    },
    expand = "none",
    layout = wibox.layout.align.vertical
  }

  awful.tag.attached_connect_signal(s, "property::selected", function()
    update_app_drawer()
  end)
end

return myapps
