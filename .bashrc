
# general settings

shopt -s globstar
shopt -s checkwinsize

stty -ixon -ixoff

export HISTSIZE=10000
export HISTFILESIZE=10000
export PROMPT_COMMAND='history -a'
export LESS='-XiRSj.1'

IFS=$'\n'
export GPG_TTY="$(tty)"

# PS1

if [ $(whoami) != 'root' ]; then
    seed=$(printf "%d" "0x$(echo $(whoami && printf $HOSTNAME) | md5sum | xxd -p -c 4 | head -1)")
    char=$(printf "\u$(printf '%x' $((0x03b1 + $seed % 25)) )")
else
    char="$HOSTNAME"
fi

_ps1_isok () {
    if [ "$?" == "0" ]; then
        printf $char
    else
        printf '!'
    fi
}

if ! command -v __git_wrap__git_main >/dev/null; then
    source /usr/share/bash-completion/completions/git
fi

export PS1='\n\[\e[93m\]\w\[\e[90m\]`__git_ps1` \[\e[91m\]\n`_ps1_isok`: \[\e[0m\]'


# completion

alias grep='grep --color'
alias less='less -r'
alias d=docker
alias k=kubectl
alias v=vim

if command -v git &> /dev/null; then
    alias g=git
    alias ga='git add -A'
    alias gc='git checkout'
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

# conemu tab name

if [[ -n "${ConEmuPID}" ]]; then
  PS1="$PS1\[\e]9;9;\"\w\"\007\e]9;12\007\]"
fi

