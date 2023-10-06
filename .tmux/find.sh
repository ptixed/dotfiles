#!/bin/bash

# -p - output to stdout
# -J - correct line wrapping
text=$(tmux capture-pane -pJ -t $1 | sed 's/ /\n/g' \
    | grep -v '^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$' \
    | sort | uniq | fzf)

if [ "$?" == "0" ]; then
    tmux set-buffer "$text"
    tmux paste-buffer -t $1
fi
