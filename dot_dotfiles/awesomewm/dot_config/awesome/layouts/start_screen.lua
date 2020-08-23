local wibox = require("wibox")
local gtable = require("gears.table")
local awful = require("awful")
local beautiful = require("beautiful")
local widget = require("util.widgets")
local button = require("util.buttons")
local font = require("util.font")
local helpers = require("helpers")
local app = require("util.app")
local btext = require("util.mat-button")
local modal = require("util.modal")

local function start_screen_hide()
  local s = awful.screen.focused()
  s.start_screen.visible = false
end

local exec_prog = function(cmd)
  app.start(cmd, nil, nil, start_screen_hide)
end

local function open_link(url)
  app.open_link(url, start_screen_hide)
end

local max_feeds = 7
local feed_width = 380
local feed_height = 345

-- base for rss
local rss_threatpost = wibox.widget {
  spacing = 8,
  layout = wibox.layout.fixed.vertical
}

local rss_ycombinator = wibox.widget {
  spacing = 8,
  layout = wibox.layout.fixed.vertical
}

local tabs = require("util.tabs")
local rss_widgets = tabs({
  texts = { "ycombinator", "threatpost" }, -- text titles
  containers = { rss_ycombinator, rss_threatpost } -- matching widgets
})

local function rss_links(rss, feed_name, w)
  w:reset()
  local f, s, b
  for i = 1, max_feeds do
    f = function() open_link(rss[feed_name].link[i]) end
    s = #rss[feed_name].title[i] > 26 and -- cut the text if too long
      string.sub(rss[feed_name].title[i], 1, 26) .. "..." or
      rss[feed_name].title[i]
    b = button.text_list(s, f, "on_surface")
    b.forced_width = 310
    w:add(b)
  end
end

-- signal to update rss feeds
awesome.connect_signal("daemon::rss", function(rss)
  if rss.threatpost then
    rss_links(rss, "threatpost", rss_threatpost)
  end
  if rss.ycombinator then
    rss_links(rss, "ycombinator", rss_ycombinator)
  end
end)

-- images
local theme_picture_container = wibox.container.background()
theme_picture_container.forced_height = dpi(100)
theme_picture_container.forced_width = dpi(160)

local theme_picture = wibox.widget {
  wibox.widget.imagebox(beautiful.wallpaper),
  widget = theme_picture_container
}

local theme_name = font.h6(M.name, M.x.on_surface, 87)
local picture_widget = widget.box('vertical', { theme_picture, theme_name })

-- quotes
local quotes = {
  "Change is neither good nor bad. It simply is.",
  "You're good. Get better. Stop asking for things.",
  "Why does everybody need to talk about everything?",
  "Today's a good day for Armageddon.",
  "In the highest level a man has the look of knowing nothing.",
  "Even if it seems certain that you will lose, retaliate.",
  "The end is important in all things.",
  "Having only wisdom and talent is the lowest tier of usefulness.",
  "Fear stimulates my imagination.",
  "I'm living like there's no tomorrow, cause there isn't one."
}
local quote_title = font.h4("", M.x.on_surface, 38)
local quote = font.body_text(quotes[math.random(#quotes)])
local quote_widget = widget.box("vertical", { quote_title, quote }, dpi(8))

-- date
local day = wibox.widget.textclock("%d")
day.font = M.f.h4
day.align = "center"

local month = wibox.widget.textclock("%B")
month.font = M.f.body_1
month.align = "left"
month.text = month.text:sub(1,3)
month:connect_signal("widget::redraw_needed", function()
  month.text = month.text:sub(1,3)
end)

local date_widget = wibox.widget {
  {
    day,
    fg = M.x.primary,
    widget = wibox.container.background
  },
  {
    month,
    fg = M.x.secondary,
    widget = wibox.container.background
  },
  layout = wibox.layout.fixed.vertical
}

-- function for buttons
local launch_term = function(cmd)
  app.start(cmd, true, nil, start_screen_hide)
end

-- buttons apps
local gimp_cmd = function() exec_prog("gimp") end
local gimp = btext({ fg_icon = "primary", icon = "",
  overlay = "primary", command = gimp_cmd })

local game_cmd = function() exec_prog("lutris") end
local game = btext({ fg_icon = "secondary", icon = "",
  overlay = "secondary", command = game_cmd })

local pentest_cmd = function() launch_term("msfconsole") end
local pentest = btext({ fg_icon = "error", icon = "ﮊ",
  overlay = "error", command = pentest_cmd })

local buttons_widget = widget.box('vertical', { gimp,game,pentest })

-- buttons path
local image_cmd = function() launch_term(file_browser .. " ~/images") end
local image = btext({ fg_text = "primary", overlay = "primary",
  text = "IMAGES", command = image_cmd
})

local torrent_cmd = function() launch_term(file_browser .. " ~/torrents") end
local torrent = btext({ fg_text = "secondary", overlay = "secondary",
  text = "TORRENTS", command = torrent_cmd
})

local movie_cmd = function() launch_term(file_browser .. " ~/videos") end
local movie = btext({ fg_text = "error", overlay = "error",
  text = "MOVIES", command = movie_cmd
})

local buttons_path_1_widget = widget.box('horizontal', { image,torrent }, 15)
local buttons_path_2_widget = widget.box('horizontal', { movie })

-- buttons url
local github_cmd = function() open_link("https://github.com/szorfein") end
local github = btext({ fg_icon = "primary", icon = "",
  overlay = "primary", command = github_cmd })

local twitter_cmd = function() open_link("https://twitter.com/szorfein") end
local twitter = btext({ fg_icon = "secondary", icon = "",
  overlay = "secondary", command = twitter_cmd })

local reddit_cmd = function() open_link("https://reddit.com/user/szorfein") end
local reddit = btext({ fg_icon = "error", icon = "",
  overlay = "error", command = reddit_cmd })

local buttons_url_widget = widget.box('vertical', { github, twitter, reddit })

-- Minimal TodoList
local todo_textbox = wibox.widget.textbox() -- to store the prompt
local history_file = os.getenv("HOME").."/.todoslist"
local todo_max = 6
local todo_list = wibox.layout.fixed.vertical()
local remove_todo

local function update_history()
  local history = io.open(history_file, "r")
  if history == nil then return end

  local lines = {}
  todo_list:reset()
  for line in history:lines() do
    table.insert(lines, line)
  end
  history:close()

  for k,v in pairs(lines) do
    if k > todo_max or not v then return end
    local t = font.text_list(v)
    local f = function() remove_todo(v) end -- serve to store the actual line
    local b = btext({ fg_text = "secondary", overlay = "secondary",
      text = "", command = f })
    local w = widget.box('horizontal', { b, t })
    todo_list:add(w)
  end
end

remove_todo = function(line)
  local line = string.gsub(line, "/", "\\/") -- if contain slash
  local command = "[ -f "..history_file.." ] && sed -i '/"..line.."/d' "..history_file
  awful.spawn.easy_async_with_shell(command, function()
    update_history()
  end)
end

local function exec_prompt()
  awful.prompt.run {
    prompt = " > ",
    fg = M.f.on_surface, 
    history_path = os.getenv("HOME").."/.history_todo",
    textbox = todo_textbox,
    exe_callback = function(input)
      if not input or #input == 0 then return end
      local command = "echo "..input.." >> "..history_file
      awful.spawn.easy_async_with_shell(command, function()
        update_history()
      end)
    end
  }
end

local todo_new = btext({ fg_icon = "on_secondary", icon = "",
  font_icon = M.f.button,
  fg_text = "on_secondary", text = " New task",
  bg = "secondary",
  mode = "contained",
  spacing = 4,
  rrect = 30,
  overlay = "on_surface",
  command = exec_prompt, layout = "horizontal"
})

local todo_widget = wibox.widget {
  todo_list,
  widget.centered(widget.box("horizontal", { todo_new, todo_textbox })),
  spacing = 12,
  layout = wibox.layout.fixed.vertical
}

update_history() -- init once the todo

local function boxes(w, width, height, margin)
  local width, height = width, height or 1, 1
  local margin = margin or 1
  local boxed_widget = wibox.widget {
    {
      widget.centered(
      {
        widget.centered(w, "vertical"),
        margins = dpi(10),
        widget = wibox.container.margin,
      }),
      bg = M.x.surface,
      forced_height = dpi(height),
      forced_width = dpi(width),
      shape = helpers.rrect(10),
      widget = wibox.container.background
    },
    margins = dpi(margin),
    color = "#00000000",
    widget = wibox.container.margin
  }
  return boxed_widget
end

local startscreen = class()

function startscreen:init(s)

  s.start_screen = modal:init(s)

  s.start_screen:buttons(gtable.join(
    awful.button({}, 3, function() start_screen_hide() end)
  ))

  local w = wibox.widget {
    {
      boxes(date_widget, 100, 120, 1),
      boxes(buttons_widget, 100, 376, 1),
      layout = wibox.layout.fixed.vertical
    },
    widget.centered(
    {
      boxes(picture_widget, 210, 200, 1),
      boxes(quote_widget, 210, 200, 1),
      layout = wibox.layout.fixed.vertical
    }, "vertical"),
    {
      boxes(rss_widgets, feed_width, feed_height, 1),
      layout = wibox.layout.fixed.vertical
    },
    widget.centered(
    {
      boxes(todo_widget, 210, 250, 1),
      boxes(buttons_path_1_widget, 210, 80, 1),
      boxes(buttons_path_2_widget, 210, 80, 1),
      layout = wibox.layout.fixed.vertical
    }, "vertical"),
    {
      boxes(buttons_url_widget, 100, 376, 1),
      layout = wibox.layout.fixed.vertical
    },
    layout = wibox.layout.fixed.horizontal
  }

  modal:run_center(w)
end

return startscreen
