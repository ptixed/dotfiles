#!/bin/bash

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
        s2='λ'
    else 
        s2='!'
    fi
    history -a
    s1=$(__git_ps1)
    pwd=$(dirs +0)
    s1="$s1$(printf "%$(( $COLUMNS - ${#s1} - ${#pwd} ))s" "$(date +%H:%M:%S)")"
    PS1='\n\[\e[93m\]\w\[\e[90m\]`echo $s1`\[\e[91m\]\n`echo $s2`: \[\e[0m\]'
    if [[ -n "${ConEmuPID}" ]]; then
      PS1="$PS1\[\e]9;9;\"\w\"\007\e]9;12\007\]"
    fi
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
