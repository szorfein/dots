local wibox = require("wibox")

-- opacity for helper text and dark theme
-- https://material.io/design/color/dark-theme.html#ui-application

function widget_text(font, text)
  return wibox.widget {
    align  = 'center',
    valign = 'center',
    font = font,
    text = text,
    widget = wibox.widget.textbox
  }
end

local font = {}

function font.h1(text) 
  return widget_text(M.f.h1, text)
end

function font.h4(text)
  return widget_text(M.f.h4, text)
end

function font.h5(text)
  return widget_text(M.f.h5, text)
end

function font.h6(text)
  return widget_text(M.f.h6, text)
end

function font.subtile_1(text)
  return widget_text(M.f.subtile_1, text)
end

function font.body_1(text)
  return widget_text(M.f.body_1, text)
end

function font.body_2(text)
  return widget_text(M.f.body_2, text)
end

function font.icon(text)
  return widget_text(M.f.icon, text)
end

function font.button(text)
  return widget_text(M.f.button, text)
end

function font.caption(text)
  return widget_text(M.f.caption, text)
end

function font.overline(text)
  return widget_text(M.f.overline, text)
end

return font
