#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

cd() {
	builtin cd "$@" && ls -lA --color=auto
}

alias l='ls -lA --color=auto'

# nixos-rebuild switch xD
alias nrs='~/.arch/config/install.py'

alias check-health='~/.arch/scripts/check-health'
alias cleanup='sudo ~/.arch/scripts/cleanup'
alias list-packages='~/.arch/scripts/list-packages'
alias list-security='sudo ~/.arch/scripts/list-security'
alias update='~/.arch/scripts/update'
#checkupdate # from pacman-contrib

alias ui='/usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland'

