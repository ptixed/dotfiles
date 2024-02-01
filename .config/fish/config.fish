function export
    set var (echo $argv | cut -f1 -d=)
    set val (echo $argv | cut -f2 -d=)
    set -g -x $var $val
end

export EDITOR=vim
export HISTSIZE=20000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:ignorespace
export GPG_TTY="$(tty)"
export LESS='-JiwRXSj.5'
# J # status column for marking with m, and navigating with '
# i # case insensitive
# w # highlight unread line
# R # color escape sequences
# X # no screen cleaning
# S # chop long lines
export LESSHISTFILE=-
# disable .lesshst file

if status is-interactive
    abbr --add g git
    abbr --add ga git add -A
    abbr --add gc git checkout
    abbr --add gd git diff
    abbr --add gdc git diff --cached
    abbr --add gp git pull
    abbr --add gs git status
    abbr --add grep grep --color

    function last_history_item
        echo $history[1]
    end
    abbr -a !! --position anywhere --function last_history_item
end

set --universal pure_show_prefix_root_prompt true
set --universal pure_show_jobs true
set --universal pure_enable_virtualenv false
set --universal pure_symbol_git_dirty ""
set --universal pure_symbol_git_stash ""

source /usr/local/bin/python-venv/bin/activate.fish
