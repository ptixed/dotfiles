#!/usr/bin/fish

switch $argv[1]
    case key
        switch $argv[2]
            case ''
                echo XF86AudioRaiseVolume 
                echo XF86AudioLowerVolume 
                echo XF86MonBrightnessDown 
                echo XF86MonBrightnessUp 
                echo XF86AudioPlay 
                echo XF86AudioNext 
                echo XF86AudioPrev 
                echo XF86AudioMute
                echo Print
                echo Superspace # bug in freerdp, should be Super+space and so on
                echo Superj
                echo Superl
            case Superspace
                ~/.config/freerdp/host-exec.fish '~/.config/i3/input.fish Super+space' >/dev/null &
                echo key-local
            case '*'
                # redirecting for parent to not wait for output
                ~/.config/i3/input.fish (string replace Super Super+ $argv[2]) >/dev/null &
                echo key-local
        end
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
        playerctl previous
    case XF86AudioMute
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        if test $(pactl get-source-mute @DEFAULT_SOURCE@) = 'Mute: yes'
            dunstify --replace 861 '  Muted'
        else
            dunstify --replace 861 '  Microphone on'
        end
        kill -USR1 $(cat /tmp/bar/pid)
    case Print
        exec flameshot gui
    case Super+BackSpace
        if test $(ibus engine) = 'anthy'
            ibus engine xkb:pl::pol
            dunstify --replace 862 'Keyboard switched'
        else
            ibus engine anthy
            dunstify --replace 862 'キーボードが切り替わった'
        end
    case Super+space
        exec ~/.config/i3/menu.fish
    case Super+l
        exec slock
    case Super+j
        if ! kill $(grep 'attach -t st-quick' /proc/*/cmdline 2>&1 | grep -Po '[0-9]+') 
            exec st -c st-quick -- sh -c 'tmux attach -t st-quick || tmux new -t st-quick'
        end
    case Super+t
        exec st tmux
    case Super+b
        exec google-chrome --password-store=gnome-libsecret
end
