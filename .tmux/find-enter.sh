#!/bin/bash

pane=$(tmux display -p '#{pane_id}')
tmux split-window -v -l16 "bash -i ~/.tmux/find.sh $pane"
