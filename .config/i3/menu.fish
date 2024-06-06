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

        echo $name\t$exec
    end | grep -Pv '^(google chrome|imagemagick|fish|gvim|htop|ranger|vim|mpv|flameshot)'
    
    echo calculator\t'dmenu -l 1 -h 30 -C -wm | ifne xclip -selection clipboard'
    echo chrome\t'google-chrome --password-store=gnome-libsecret'
    echo reboot\t'systemctl reboot'
    echo shutdown\t'systemctl poweroff'
    echo skype\t'google-chrome --password-store=gnome-libsecret https://web.skype.com/'
    echo terminal\t'st tmux'
    echo terminal i18l\t'XMODIFIERS="@im=ibus" st tmux'

    if pgrep ebrit >/dev/null
        echo stop working\tkillall -r ebrit
    else
        echo work\t./scripts/ebrit.fish
    end

end \
    | sort -t \t -k1,1 \
    | dmenu -l 8 -h 30 -i -d \t -wm \
    | $SHELL
