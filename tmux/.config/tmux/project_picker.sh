#!/bin/bash

DEV_ROOT="$DEV_ROOT"
cd "$DEV_ROOT" || exit

echo "Select a project directory (2nd level):"
SELECTED=$(find . -mindepth 2 -maxdepth 2 -type d | sed 's|^\./||' | fzf --prompt='Project > ')

if [ -n "$SELECTED" ]; then
  cd "$DEV_ROOT/$SELECTED" && exec nvim
else
  echo "No project selected."
  exec zsh -l
fi

