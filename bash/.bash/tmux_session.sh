#!/usr/bin/env bash

SESSION=session

# If session exists, just attach
if tmux has-session -t "$SESSION" 2>/dev/null; then
    exec tmux attach -t "$SESSION"
fi

tmux new-session -d -s session -n window

tmux split-window -h -t session:window
tmux split-window -v -t session:window.1
tmux split-window -h -t session:window.1

tmux send-keys -t session:window.3 'btop' C-m
tmux send-keys -t session:window.1 'clock' C-m
tmux send-keys -t session:window.2 'battery' C-m

tmux select-pane -t "session:window.0"

tmux resize-pane -t session:window.0 -x 80
tmux resize-pane -t session:window.3 -y 11
tmux resize-pane -t session:window.2 -x 20

exec tmux attach -t "$SESSION"
