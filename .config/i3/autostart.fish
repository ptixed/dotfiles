#!/usr/bin/fish

xss-lock --transfer-sleep-lock -- slock &
picom --daemon &
hsetroot -cover (random choice ~/media/wallpapers/*)

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# also spawns kill-daemon process, it can't be avoided
ibus-daemon --xim --daemonize 
# now this should work:
# XMODIFIERS='@im=ibus' st

# uxplay &
