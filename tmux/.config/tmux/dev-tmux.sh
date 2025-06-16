#!/bin/bash

# Set environment variables for directories and session name
SESSION_NAME="Dev-Work"
OBSIDIAN_DIR="$OBSIDIAN"
DEV_DIR="$HOME/dev"
FRONTEND_DIR="$DEV_DIR/inspect-mobility/Inspectmobility.frontend"
BACKEND_DIR="$DEV_DIR/inspect-mobility/InspectMobility.backend/Gtue.Inspectmobilityservice.Api"

# Check if required packages are installed, install if missing
install_if_missing() {
    if ! command -v $1 &> /dev/null; then
        echo "$1 not found, installing..."
        if [ "$(uname)" == "Darwin" ]; then
            brew install $1
        elif [ -x "$(command -v apt-get)" ]; then
            sudo apt-get install -y $1
        elif [ -x "$(command -v dnf)" ]; then
            sudo dnf install -y $1
        elif [ -x "$(command -v yum)" ]; then
            sudo yum install -y $1
        elif [ -x "$(command -v pacman)" ]; then
            sudo pacman -S $1
        else
            echo "Package manager not found. Please install $1 manually."
            exit 1
        fi
    fi
}

# Check and install necessary tools
install_if_missing htop
install_if_missing neofetch

# Start tmux session
tmux new-session -d -s $SESSION_NAME

# Window 1: Code editing in ~/dev
# Window 1: Project selection with fzf
# Window 1: Project selection using external script
tmux new-window -t $SESSION_NAME:1 -n 'Editor'
tmux send-keys -t $SESSION_NAME:1 "$HOME/.config/tmux/project_picker.sh" C-m


# Window 2: Obsidian notes with nvim
tmux new-window -t $SESSION_NAME:2 -n 'Obsidian'
tmux send-keys -t $SESSION_NAME:2 "cd $OBSIDIAN_DIR" C-m
tmux send-keys -t $SESSION_NAME:2 "nvim" C-m

# Window 3: Metrics with htop and neofetch in vertical split
tmux new-window -t $SESSION_NAME:3 -n 'Metrics'
tmux split-window -h
tmux send-keys -t $SESSION_NAME:3.0 "htop" C-m
tmux send-keys -t $SESSION_NAME:3.1 "neofetch" C-m

# Window 4: App server with vertical split for FE and BE
tmux new-window -t $SESSION_NAME:4 -n 'Server'
tmux send-keys -t $SESSION_NAME:4 "cd $FRONTEND_DIR" C-m
tmux send-keys -t $SESSION_NAME:4 "ng serve" C-m
tmux split-window -h -t $SESSION_NAME:4
tmux send-keys -t $SESSION_NAME:4.1 "cd $BACKEND_DIR" C-m
tmux send-keys -t $SESSION_NAME:4.1 "dotnet run" C-m

# Attach to the tmux session
# Attach to tmux session, starting in Window 1
tmux select-window -t $SESSION_NAME:1
tmux attach-session -t $SESSION_NAME


