#!/bin/bash

. /etc/bash_completion.d/git-prompt
. /usr/share/doc/fzf/examples/key-bindings.bash
. /usr/share/bash-completion/completions/git
. ~/.python-venv/bin/activate

export PATH="/home/ptixed/.local/bin/:$PATH"
. "$HOME/.cargo/env"

alias xclip="xclip -selection c"
alias ls="ls --color --hyperlink=auto"

# general settings

shopt -s globstar

stty -ixon -ixoff 2>/dev/null

# use quoted-insert (C-q) to find out keycodes
bind '"\e[A":history-search-backward' 2>/dev/null
bind '"\e[B":history-search-forward' 2>/dev/null
bind 'C-H:backward-kill-word'

export EDITOR=vim
export HISTSIZE=10000
export HISTFILESIZE=10000
export GPG_TTY="$(tty)"
export LESS='-JiwRXS'
# J # status column for marking with m, and navigating with '
# i # case insensitive
# w # highlight unread line
# R # color escape sequences
# X # no screen cleaning
# S # chop long lines

IFS=$'\n'

# PS1
function prompt() {
    if [ "$?" == "0" ]; then 
        s2="λ:"
    else 
        s2="!:"
    fi
    s2="$USER@$(cat /proc/$PPID/comm) $s2"
    history -a
    PS1='\n\[\e[90m\]`date +%H:%M:%S` \[\e[93m\]`dirs +0`\[\e[90m\]`__git_ps1`\[\e[91m\]\n`echo $s2` \[\e[0m\]'
}
PROMPT_COMMAND=prompt

# completion

alias grep='grep --color'
alias d=docker
alias k=kubectl
alias t=terraform
alias g=git
alias ga='git add -A'
alias gc='git checkout'
alias gd='git diff'
alias gdc='git diff --cached'
alias gp='git pull'
alias gpp='git pull && git push'
alias gs='git status'

stash () {
    if [ "$1" == pop ] || [ "$1" == apply ] || [ "$1" == drop ] || [ "$1" == show ]; then
        git stash $1 $(git stash list | grep -Po "(stash@\{\d+\})(?=: On [^:]+: ${2}$)")
    else
        git stash push -m "$1"
    fi
}
