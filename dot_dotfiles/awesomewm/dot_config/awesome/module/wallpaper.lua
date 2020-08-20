local awful = require("awful")
local beautiful = require("beautiful")

-- init table
local mywallpaper = class()

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    -- Method 1: Built in function
    -- gears.wallpaper.maximized(wallpaper, s, true)

    -- Method 2: Set theme's wallpaper with feh
    awful.spawn.with_shell("feh --bg-fill " .. wallpaper)

    -- Method 3: Set last wallpaper with feh
    -- awful.spawn.with_shell(os.getenv("HOME") .. "/.fehbg")
  end
end

function mywallpaper:init(s)
  set_wallpaper(s)

  -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
  screen.connect_signal("property::geometry", set_wallpaper)
end

return mywallpaper
