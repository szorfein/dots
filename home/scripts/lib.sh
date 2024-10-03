has_systemd() {
  if [ -d /usr/lib/systemd/system ] || [ -d /usr/lib64/systemd/system ] ; then
    return 0
  else
    return 1
  fi
}
