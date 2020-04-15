local wibox = require("wibox")
local awful = require("awful")
local keygrabber = require("awful.keygrabber")
local button = require("utils.button")
local modal = require("utils.modal")
local helper = require("utils.helper")
local font = require("utils.font")

-- keylogger
local exit_screen_grabber

function exit_screen_hide()
  local s = awful.screen.focused()
  keygrabber.stop(exit_screen_grabber)

  s.exit_screen.visible = false
end

-- button poweroff
local poweroff = button({
  fg_icon = M.x.error,
  icon = font.h1("⭘"),
  text = font.button("Poweroff"),
  width = 110,
  command = function()
    awful.spawn("sudo systemctl poweroff")
    exit_screen_hide()
  end
})

-- button exit
local exit = button({
  fg_icon = M.x.primary,
  icon = font.h1(">>"),
  text = font.button("Exit"),
  width = 110,
  command = function()
    awesome.quit()
  end
})

-- button lock
local lock = button({
  fg_icon = M.x.secondary,
  icon = font.h1(""),
  text = font.button("Lock"),
  width = 110,
  command = function()
    exit_screen_hide()
    lock_screen_show()
  end
})

local exit_root = class()

function exit_root:init(s)

  -- exit_screen creation
  s.exit_screen = modal:init()

  function exit_screen_show()
    local grabber = keygrabber {
      keybindings = {
        { {}, 'p', function() poweroff_command() end },
        { {}, 'e', function() exit_command() end },
        { {}, 'l', function() lock_command() end },
        { {}, 'q', function() exit_screen_hide() end },
      },
      stop_key = "Escape",
      stop_callback = function() exit_screen_hide() end,
    }

    if grabber.is_running and s.exit_screen.visible == false then
      grabber:stop()
    elseif s.exit_screen.visible == false then
      grabber:stop()
    end

    grabber:start()
    s.exit_screen.visible = true
  end

  -- buttons
  modal:add_buttons(exit_screen_hide)

  local w = wibox.widget {
    {
      {
        poweroff,
        exit,
        lock,
        spacing = 12,
        layout = wibox.layout.fixed.horizontal
      },
      margins = 20,
      widget = wibox.container.margin
    },
    shape = helper.rrect(20),
    bg = M.x.surface,
    widget = wibox.container.background
  }

  modal:run_center(w)
end

return exit_root
