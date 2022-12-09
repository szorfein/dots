#!/usr/bin/env sh

bg="#000000"
on_bg="#e3fafeee"
primary="#4EDAF3"
secondary="#5da6FF"
error="#f4826c"

i3lock \
  -B "${BG}00" \
  --blur 1 \
  --insidevercolor="${secondary}66" \
  --ringvercolor="${secondary}bb" \
  \
  --insidewrongcolor="${error}66" \
  --ringwrongcolor="${error}bb" \
  --wrongcolor="$on_bg" \
  \
  --verifcolor="$on_bg" \
  --ringcolor="${secondary}ff" \
  --insidecolor="${secondary}22" \
  --linecolor="${bg}FF" \
  \
  --keyhlcolor="${primary}bb" \
  --bshlcolor="${error}bb" \
  \
  --timecolor="$on_bg" \
  --datecolor="$on_bg" \
  --timestr="%H:%M" \
  --datestr="%A, %m, %Y" \
  \
  --indicator \
  --clock \
  --wrongtext="Die!"
