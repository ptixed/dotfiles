export PATH="~/.bin:.cargo/bin/:$PATH"
export QT_QPA_PLATFORMTHEME=gtk3
if [[ "$DISPLAY" == "" ]] && [[ "$XDG_VTNR" == "1" ]]; then
  startx
fi

