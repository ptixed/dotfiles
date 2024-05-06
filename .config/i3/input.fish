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
        wpctl set-volume @DEFAULT_SINK@ 0.05+
        kill -USR1 $(cat /tmp/i3-bar/pid)
    case XF86AudioLowerVolume
        wpctl set-volume @DEFAULT_SINK@ 0.05-
        kill -USR1 $(cat /tmp/i3-bar/pid) 
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
        wpctl set-mute @DEFAULT_SOURCE@ toggle
        if wpctl get-volume @DEFAULT_SOURCE@ | grep -q MUTED
            dunstify --replace 861 -i $icons/24x24/panel/audio-input-microphone-muted.svg "Muted"
        else
            dunstify --replace 861 -i $icons/24x24/panel/audio-input-microphone-high.svg "Microphone on"
        end
    case Super+BackSpace
        if ibus engine | grep -q anthy
            ibus engine xkb:pl::pol
            dunstify --replace 862 "Keyboard switched"
        else
            ibus engine anthy
            dunstify --replace 862 "キーボードが切り替わった"
        end
end

echo key-local
