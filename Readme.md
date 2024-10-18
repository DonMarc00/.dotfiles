# Installation Guide

## Manual installation

Either move all the folders into their respective directories as represented by their file structures. This means that they either have to be moved to $HOME or $XDG_CONFIG_HOME which is typically located in ~/.config/

## Automatic installation

### Step 1

Install `stow` using your favorite package manager:

#### Ubuntu

```bash
sudo apt install stow

```

#### Arch

```bash
sudo pacman -S stow
```

### Step 2

Use stow with verbose to check whether the configs are moved to the correct locations like this:

```bash
stow -v zshrc nvim tmux starship

```

Watch for the outputs of the command to check if the symlink happend in the correct directories

## Tmux and Nvim hints

If there should be problems with the plugins that are supposed to be installed by tmux or nvim you can delete the plugin folders for the systems.

### Tmux

```bash
rm -rf ~/.config/tmux/plugins/

```

### Nvim

```bash
rm -rf ~/.local/share/nvim/lazy/

```
