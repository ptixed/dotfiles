#!/bin/bash

for pane_id in $(tmux list-panes -F '#{pane_id}'); do
    # -p - output to stdout
    # -J - correct line wrapping
    # -S - how far back to reach
    tmux capture-pane -S -256 -pJ -t $pane_id
done \
    | sed 's/ /\n/g' \
    | sort \
    | uniq \
    | fzf \
    | tr -d $'\n' \
    | tmux load-buffer -w -
