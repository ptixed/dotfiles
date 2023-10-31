#!/bin/bash

# -p - output to stdout
# -J - correct line wrapping
# -S - how far back to reach

text=$(
    for pane_id in $(tmux list-panes -F '#{pane_id}'); do
        tmux capture-pane -S -256 -pJ -t $pane_id
    done \
    | sed 's/ /\n/g' \
    | grep -v '^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$' \
    | sort | uniq | fzf --bind 'ctrl-c:execute(echo {} > /dev/clipboard)'
)

if [ "$?" == "0" ]; then
    tmux set-buffer "$text"
    tmux paste-buffer -t $1
fi
