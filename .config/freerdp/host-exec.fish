#!/usr/bin/fish

xmacroplay-keys :0 Control_R
eval "$argv[1]"

# below is necesasary for freerdp to regrab keyboard
# first we transfer the focus to st, than back to freerdp
st exit
i3-msg '[class="freerdp"] focus'
