
shopt -s globstar
shopt -s checkwinsize

stty -ixon

alias grep='grep --color'
alias g=git
alias k=kubectl

if [ $(whoami) != 'root' ]; then
    seed=$(printf "%d" "0x$(echo $(whoami && printf $HOSTNAME) | md5sum | xxd -p -c 4 | head -1)")
    rand=$(bash -c "RANDOM=$seed; echo \$RANDOM")
    code=$((0x03b1 + $rand % 25))
    char=$(printf "\u$(printf '%x' $code)")
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

export PS1='\n\[\e[93m\]\w\[\e[90m\]`__git_ps1`\[\e[91m\]\n`_ps1_isok`: \[\e[0m\]'

if [[ -n "${ConEmuPID}" ]]; then
  PS1="$PS1\[\e]9;9;\"\w\"\007\e]9;12\007\]"
fi

if [ ! $(type __git_wrap__git_main 2>/dev/null >/dev/null) ]; then
    . $(dirname "$BASH_SOURCE")/git-prompt.sh
fi
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g

export HISTSIZE=10000
export HISTFILESIZE=10000
export PROMPT_COMMAND='history -a'

IFS=$'\n'

