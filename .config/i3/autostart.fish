#!/usr/bin/fish

xss-lock --transfer-sleep-lock -- i3lock-fancy-rapid 5 3 &
picom --daemon &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# also spawns kill-daemon process, it can't be avoided
ibus-daemon --xim --single --daemonize 
# following only works after ibus deamon is started
/bin/python3 /usr/share/ibus-anthy/engine/main.py --ibus &

