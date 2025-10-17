#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export PATH="$PATH:/home/DonMarc0/snap/flutter/common/flutter/bin"
export QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/qt/plugins
. "$HOME/.cargo/env"
