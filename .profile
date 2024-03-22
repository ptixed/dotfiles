
export PATH="$HOME/bin:$PATH"
export EDITOR=vim
# J # status column for marking with m, and navigating with '
# i # case insensitive
# w # highlight unread line
# R # color escape sequences
# X # no screen cleaning
# S # chop long lines
export LESS='-JiwRXSj.5'
# disable .lesshst file
export LESSHISTFILE=-
export QT_QPA_PLATFORMTHEME=gtk3

if [ -f $HOME/.bash_profile ]; then
    . $HOME/.bash_profile
fi

if [[ "$DISPLAY" == "" ]] && [[ "$XDG_VTNR" == "1" ]]; then
 startx
 touchpad=$(xinput list | grep -Po 'Touchpad.*id=\K[0-9]+')
 prop=$(xinput list-props $touchpad | grep -Po 'Tapping Button Mapping Enabled \(\K[0-9]+')
 xinput set-prop $touchpad $prop 1 0
fi

