#!/usr/bin/env bash

# Create or attach to a tmux session named "work" with predefined windows
# - Window 0: TODOs (vim editing todos file)
# - Window 1: llm 
# - Window 2: zsh
tmux-work() {
  # Check if tmux server is running and if the 'work' session exists
  if tmux has-session -t work 2>/dev/null; then
    tmux attach-session -t work
    return
  fi

  # Create the session, starting a _shell_ in the first window.
  # Doing this separately from starting vim (below) prevents us loosing the
  # tmux window after exiting vim
  tmux new-session -d -s work -n TODOs -c "$CODE_DIR/dot-plans"
  # Now start vim (after a git pull)
  tmux send-keys -t work:0 "git pull" C-m
  # shellcheck disable=SC2154  # $todos is defined in ./exports/exports.local.sh
  tmux send-keys -t work:0 "vim \"$todos\"" C-m
  tmux new-window -t work:1 -n llm
  tmux new-window -t work:2 -n zsh
  tmux select-window -t work:0
  tmux attach-session -t work
}
