local wibox = require("wibox")
local awful = require("awful")
local keygrabber = require("awful.keygrabber")
local btext = require("util.mat-button")
local modal = require("util.modal")
local helpers = require("helpers")

-- keylogger
local exit_screen_grabber

function exit_screen_hide()
  keygrabber.stop(exit_screen_grabber)
  exit_screen.visible = false
end

local poweroff_command = function() 
  awful.spawn("sudo systemctl poweroff")
  exit_screen_hide()
end

local poweroff = btext({ fg_icon = "error",
  overlay = "error",
  icon = "⭘",
  text = "<b>P</b>oweroff",
  width = 110,
  command = poweroff_command
})

local exit_command = function() 
  awesome.quit()
end

local exit = btext({ fg_icon = "primary",
  overlay = "primary",
  icon = ">>",
  text = "<b>E</b>xit",
  width = 110,
  command = exit_command
})
-- {{{ END Exit part

-- {{{ Lock part
local lock_command = function() 
  exit_screen_hide()
  lock_screen_show()
end

local lock = btext({ fg_icon = "secondary",
  overlay = "secondary",
  icon = "",
  text = "<b>L</b>ock",
  width = 110,
  command = lock_command
})

-- exit_screen creation
exit_screen = modal:init()

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

  if grabber.is_running and exit_screen.visible == false then
    grabber:stop()
  elseif exit_screen.visible == false then
    grabber:stop()
  end

  grabber:start()
  exit_screen.visible = true
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
  shape = helpers.rrect(20),
  bg = M.x.surface,
  widget = wibox.container.background
}

modal:run_center(w)
