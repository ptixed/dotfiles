
# to prevent ring buffer from trashing tty1:
# dmesg --console-off >> /etc/rc.local

if [[ "$DISPLAY" == "" ]] && [[ "$XDG_VTNR" == "1" ]]; then
  startx
fi

