tc='\033['
cyan="${tc}36m"
white="${tc}37m"
endc="${tc}0m"

msg() {
  printf "\\n${cyan}%s${endc}\\n" '--------------------------------------------------'
  printf "${cyan}%s${white} %s${endc}\\n\\n" '-->' "$1"
}

bye() {
  printf "\\n${cyan}%s${white} %s${endc}\\n" '-->' "End for $0"
  printf "${cyan}%s${endc}\\n" "--------------------------------------------------"
}

trap bye EXIT

search_auth() {
  if [ -f /bin/doas ] || [ -f /sbin/doas ] ; then
    echo "doas"
  elif [ -f /bin/sudo ] || [ -f /sbin/sudo ] ; then
    echo "sudo"
  else
    echo "No found doas or sudo, please install one and configure it for $USER."
    exit 1
  fi
}

has_systemd() {
  if readlink /sbin/init | grep -q systemd ; then
    return 0
  else
    return 1
  fi
}
