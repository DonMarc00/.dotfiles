#!/bin/bash

DEV_ROOT="$HOME/dev"
cd "$DEV_ROOT" || exit

echo "Select a project directory (2nd level):"
SELECTED=$(find . -mindepth 2 -maxdepth 2 -type d | sed 's|^\./||' | fzf --prompt='Project > ')

if [ -n "$SELECTED" ]; then
  cd "$DEV_ROOT/$SELECTED" && exec nvim
else
  echo "No project selected."
  exec bash
fi

