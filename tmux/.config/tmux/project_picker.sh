#!/bin/bash

DEV_ROOT="${DEV_ROOT:-$HOME/dev}"

cd "$DEV_ROOT" || {
  echo "DEV_ROOT not found: $DEV_ROOT"
  exit 1
}

echo "Select a project directory (2nd level):"

SELECTED=$(
  find "$DEV_ROOT" -mindepth 2 -maxdepth 2 -type d \
  | sed "s|^$DEV_ROOT/||" \
  | fzf --prompt='Project > '
)

if [ -n "$SELECTED" ]; then
  cd "$DEV_ROOT/$SELECTED" && exec nvim
else
  echo "No project selected."
  exec zsh -l
fi
