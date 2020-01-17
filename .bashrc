
shopt -s globstar

stty -ixon

alias grep='grep --color'
alias g=git

export PS1='\n\[\e[93m\]\w\[\e[95m\]`__git_ps1`\[\e[91m\]\nλ: \[\e[0m\]'

if [[ -n "${ConEmuPID}" ]]; then
  PS1="$PS1\[\e]9;9;\"\w\"\007\e]9;12\007\]"
fi

complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g

export HISTSIZE=5000
export HISTFILESIZE=5000

IFS=$'\n'
