#!/usr/bin/fish

begin 
    for f in /usr/share/applications/* ~/.local/share/applications/*
        set entry "$(sed -nE '/\[Desktop Entry\]/,/^$/p' $f)"
        if string match -eq "NoDisplay=true" "$entry"
            continue
        end

        set name (string match -r "(?<=Name=).*" "$entry") 
        if test "$name" = ''
            continue
        end
        set name (string lower "$name")

        set exec (string match -r "(?<=Exec=).*" "$entry")
        set exec (string replace -r "%[fFU]" "" "$exec")

        echo $name\texec $exec
    end | grep -Pv '^(google chrome|imagemagick|fish|gvim|htop|ranger|vim|mpv|flameshot|install steam|visual studio code)'
    
    echo calculator\t'exec dmenu -l 1 -h 30 -C -wm | ifne xclip -selection clipboard'
    echo chrome\t'exec google-chrome --password-store=gnome-libsecret'
    echo log out\t'exec killall xinit'
    echo reboot\t'exec systemctl reboot'
    echo shutdown\t'exec systemctl poweroff'
    echo skype\t'exec google-chrome --password-store=gnome-libsecret https://web.skype.com/'
    echo steam\t'exec $HOME/.local/bin/steam'
    echo terminal i18l\t'XMODIFIERS="@im=ibus" exec st tmux'
    echo vial\t'exec vial'
    echo visual studio code\t'exec code --password-store=gnome-libsecret'

    if pgrep ebrit >/dev/null
        echo stop working\texec killall -r ebrit
    else
        echo work\texec ./scripts/ebrit.fish
    end

end \
    | sort -t \t -k1,1 \
    | dmenu -l 8 -h 30 -i -d \t -wm \
    | $SHELL
