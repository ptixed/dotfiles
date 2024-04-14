#!/bin/bash

xss-lock --transfer-sleep-lock -- i3lock-fancy-rapid 5 3 &
picom --daemon &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

ibus-daemon --xim --single --daemonize # also spawns kill-daemon process, it can't be avoided
/bin/python3 /usr/share/ibus-anthy/engine/main.py --ibus &

