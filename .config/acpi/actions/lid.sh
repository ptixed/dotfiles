#!/bin/bash

# acpi_listen

case "$1" in
    button/lid)
        export DISPLAY=:0
        export XAUTHORITY=/home/ptixed/.Xauthority

        if [ "$3" == "open" ]; then
            xrandr --output eDP-1 --auto
        else
            xrandr --output eDP-1 --off
        fi

        sudo -u ptixed autorandr --change --force
        ;;
esac

