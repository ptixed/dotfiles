
shopt -s globstar

stty -ixon

alias grep='grep --color'
alias g=git

seed=$(printf "%d" "0x$(whoami | md5sum | xxd -p -c 4 | head -1)")
rand=$(bash -c "RANDOM=$seed; echo \$RANDOM")
code=$((0x03b1 + $rand % 25))
char=$(printf "\u$(printf '%x' $code)")

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

export HISTSIZE=5000
export HISTFILESIZE=5000

IFS=$'\n'

