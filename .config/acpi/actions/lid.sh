#!/bin/bash

# acpi_listen
case "$1" in
    button/lid)
        user=$(ps -ef | grep /etc/X11/xinit/xinitrc | grep -Po '^[^ ]+' | head -1)
        if [ "$user" == "" ]; then
            exit
        fi
        if [ "$3" == "open" ]; then
            DISPLAY=:0 sudo -u $user xrandr --output eDP-1 --auto
        else
            DISPLAY=:0 sudo -u $user xrandr --output eDP-1 --off
        fi
        DISPLAY=:0 sudo -u $user autorandr --change --force
        ;;
esac

