has_systemd() {
  if [ -f /bin/systemctl ] || [ -f /usr/bin/systemctl ] ; then
    return 0
  else
    return 1
  fi
}
