#!/usr/bin/fish

if test "$argv[1]" != 'key'
    exit
end

switch "$argv[2]"
    case ''
        echo XF86AudioRaiseVolume 
        echo XF86AudioLowerVolume 
        echo XF86MonBrightnessDown 
        echo XF86MonBrightnessUp 
        echo XF86AudioPlay 
        echo XF86AudioNext 
        echo XF86AudioPrev 
        echo XF86AudioMute
        exit
    case XF86AudioRaiseVolume
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        kill -USR1 $(cat /tmp/bar/pid)
    case XF86AudioLowerVolume
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        kill -USR1 $(cat /tmp/bar/pid) 
    case XF86MonBrightnessDown
        brightnessctl -q set 10%-
    case XF86MonBrightnessUp
        brightnessctl -q set 10%+
    case XF86AudioPlay
        playerctl play-pause
    case XF86AudioNext
        playerctl next
    case XF86AudioPrev
        playerctl prev
    case XF86AudioMute
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        if test $(pactl get-source-mute @DEFAULT_SOURCE@) = "Mute: yes"
            dunstify --replace 861 "  Muted"
        else
            dunstify --replace 861 "  Microphone on"
        end
    case Super+BackSpace
        if string match -qr "anthy" (ibus engine)
            ibus engine xkb:pl::pol
            dunstify --replace 862 "Keyboard switched"
        else
            ibus engine anthy
            dunstify --replace 862 "キーボードが切り替わった"
        end
end

echo key-local
