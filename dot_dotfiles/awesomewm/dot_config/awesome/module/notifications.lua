local naughty = require("naughty")

-- timeout
naughty.config.defaults.timeout = 10
naughty.config.presets.low.timeout = 6
naughty.config.presets.critical.timeout = 0 -- click to disable

naughty.config.presets.normal = {
  font         = M.f.button,
  fg           = M.x.on_surface,
  bg           = M.x.surface,
  border_color = M.x.primary,
  border_width = 1
}

naughty.config.presets.low = {
  font         = M.f.body_2,
  fg           = M.x.surface,
  bg           = M.x.on_surface,
  border_color = M.x.on_surface,
  border_width = 1
}

naughty.config.presets.ok = naughty.config.presets.low
naughty.config.presets.info = naughty.config.presets.low
naughty.config.presets.warn = naughty.config.presets.normal

naughty.config.presets.critical = {
  font         = M.f.subtile_1, -- TODO change
  fg           = M.x.on_error,
  bg           = M.x.error,
  border_color = M.x.error,
  border_width = 2
}

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ 
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors 
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
  -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ 
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })

    in_error = false
  end)
end

-- signal, TODO need awesome-git as dependencies to enable the signal !!
-- i wait the next release 4.4 for now
-- https://github.com/elenapan/dotfiles/issues/60
--naughty.connect_signal("request::display", function(n)

  --naughty.layout.box {
  --  notification = n,
  --  type = "splash",
  --  widget_template = {}
--  }
--end)
