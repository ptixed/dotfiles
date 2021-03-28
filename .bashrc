
# general settings

shopt -s globstar
shopt -s checkwinsize

stty -ixon -ixoff

export HISTSIZE=10000
export HISTFILESIZE=10000
export PROMPT_COMMAND='history -a'

IFS=$'\n'


# PS1

if [ $(whoami) != 'root' ]; then
    seed=$(printf "%d" "0x$(echo $(whoami && printf $HOSTNAME) | md5sum | xxd -p -c 4 | head -1)")
    rand=$(sh -c "RANDOM=$seed; echo \$RANDOM")
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

if ! command -v __git_ps1 >/dev/null; then
    __git_ps1 () {
        :
    }
fi

export PS1='\n\[\e[93m\]\w\[\e[90m\]`__git_ps1` \[\e[91m\]\n`_ps1_isok`: \[\e[0m\]'


# completion

if command -v git &> /dev/null; then
    alias g=git
    complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g
fi

if command -v kubectl &> /dev/null; then
    alias k=kubectl
    . <(kubectl completion bash)
    complete -F __start_kubectl k
fi

alias grep='grep --color'


# conemu tab name

if [[ -n "${ConEmuPID}" ]]; then
  PS1="$PS1\[\e]9;9;\"\w\"\007\e]9;12\007\]"
fi

