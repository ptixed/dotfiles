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
    end | grep -Pv '^(google chrome|imagemagick|fish|gvim|htop|ranger|vim|mpv)'
    
    echo skype\tgoogle-chrome --password-store=gnome-libsecret https://web.skype.com/

end | sort | dmenu -l 8 -fn "CaskaydiaMono Nerd Font:size=11" -h 30 -i -d \t | $SHELL
