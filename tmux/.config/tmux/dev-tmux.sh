#!/bin/bash

set -euo pipefail

SESSION_NAME="Dev-Work"
OBSIDIAN_DIR="${OBSIDIAN}"  # muss exportiert sein (z. B. aus deiner Shell)
DEV_DIR="${HOME}/dev"
FRONTEND_DIR="${DEV_DIR}/inspect-mobility/Inspectmobility.frontend"
BACKEND_DIR="${DEV_DIR}/inspect-mobility/InspectMobility.backend/Gtue.Inspectmobilityservice.Api"

install_if_missing() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "$1 not found, installing..."
    if [ "$(uname)" = "Darwin" ]; then
      brew install "$1"
    elif command -v apt-get >/dev/null 2>&1; then
      sudo apt-get install -y "$1"
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y "$1"
    elif command -v yum >/dev/null 2>&1; then
      sudo yum install -y "$1"
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -S --noconfirm "$1"
    else
      echo "Package manager not found. Please install $1 manually."
      exit 1
    fi
  fi
}

install_if_missing htop install_if_missing neofetch

# Session neu anlegen falls nicht vorhanden
if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  # Startfenster 1: Editor (startet im DEV_DIR oder $HOME, wenn DEV_DIR nicht existiert)
  tmux new-session -d -s "$SESSION_NAME" -n 'Editor' -c "${DEV_DIR:-$HOME}"
  tmux send-keys -t "$SESSION_NAME:Editor" "$HOME/.config/tmux/project_picker.sh" C-m

  # Fenster 2: Obsidian (setzt Arbeitsverzeichnis via -c, kein 'cd' nötig)
  tmux new-window -t "$SESSION_NAME:" -n 'Obsidian' -c "${OBSIDIAN_DIR:-$HOME}"
  tmux send-keys  -t "$SESSION_NAME:Obsidian" "nvim" C-m

  # Fenster 3: Metrics
  tmux new-window -t "$SESSION_NAME:" -n 'Metrics' -c "$HOME"
  tmux split-window -h -t "$SESSION_NAME:Metrics"
  tmux send-keys -t "$SESSION_NAME:Metrics.0" "htop" C-m
  tmux send-keys -t "$SESSION_NAME:Metrics.1" "neofetch" C-m

  # Fenster 4: Server (FE/BE jeweils mit -c)
  tmux new-window -t "$SESSION_NAME:" -n 'Server' -c "${FRONTEND_DIR:-$HOME}"
  tmux send-keys  -t "$SESSION_NAME:Server.0" "ng serve" C-m
  tmux split-window -h -t "$SESSION_NAME:Server" -c "${BACKEND_DIR:-$HOME}"
  tmux send-keys  -t "$SESSION_NAME:Server.1" "dotnet run" C-m
fi

# Beim Attach direkt ins Obsidian-Fenster springen
tmux select-window -t "$SESSION_NAME:Editor"
tmux attach -t "$SESSION_NAME"
