
# general settings

bind 'TAB:menu-complete' 2>/dev/null
bind "set show-all-if-unmodified on" 2>/dev/null
bind "set menu-complete-display-prefix on" 2>/dev/null
bind '"\e[A":history-search-backward' 2>/dev/null
bind '"\e[B":history-search-forward' 2>/dev/null

shopt -s globstar

stty -ixon -ixoff 2>/dev/null

export HISTSIZE=10000
export HISTFILESIZE=10000
export LESS='-iRS'
export GPG_TTY="$(tty)"

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
}
PROMPT_COMMAND=prompt

# completion

alias grep='grep --color'
alias d=docker
alias k=kubectl

if command -v git &> /dev/null; then
    alias g=git
    alias ga='git add -A'
    alias gc='git checkout --recurse-submodules'
    alias gd='git diff'
    alias gp='git pull'
    alias gs='git status'
    complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g

	stash () {
		if [ "$1" == pop ] || [ "$1" == apply ] || [ "$1" == drop ] || [ "$1" == show ]; then
			git stash $1 $(git stash list | grep -Po "(stash@\{\d+\})(?=: On [^:]+: ${2}$)")
		else
			git stash push -m "$1"
		fi
	}
fi

