#!/bin/bash

. /etc/bash_completion.d/git-prompt
. /usr/share/doc/fzf/examples/key-bindings.bash
. /usr/share/bash-completion/completions/git
. /usr/local/bin/python-venv/bin/activate

shopt -s globstar

stty -ixon -ixoff 2>/dev/null

export EDITOR=vim
export HISTSIZE=20000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:ignorespace
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
        PS1='\n\[\e[90m\]`date +%H:%M:%S` \[\e[93m\]`dirs +0`\[\e[90m\]`__git_ps1`\[\e[94m\]\n`echo $s2`:\[\e[0m\] '
    else 
        PS1='\n\[\e[90m\]`date +%H:%M:%S` \[\e[93m\]`dirs +0`\[\e[90m\]`__git_ps1`\[\e[91m\]\n`echo $s2`:\[\e[0m\] '
    fi
    s2="$USER@$(cat /proc/$PPID/comm)"
    history -a
}
PROMPT_COMMAND=prompt

# completion

alias xclip="xclip -selection c"
alias ls="ls --color --hyperlink=auto"
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
alias ranger='. ranger'
