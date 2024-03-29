function export
    set var (echo $argv | cut -f1 -d=)
    set val (echo $argv | cut -f2 -d=)
    set -g -x $var $val
end

if status is-interactive
    abbr --add g git
    abbr --add ga git add -A
    abbr --add gc git checkout
    abbr --add gd git diff
    abbr --add gdc git diff --cached
    abbr --add gp git pull
    abbr --add gs git status
    abbr --add apti sudo apt install --no-install-recommends

    abbr --add grep grep --color
    abbr --add icat kitty +kitten icat
    abbr --add ssh kitty +kitten ssh
    abbr --add broadcast kitty +kitten broadcast --match-tab state:focused

    function last_history_item
        echo $history[1]
    end
    abbr -a !! --position anywhere --function last_history_item
end

set --global pure_show_jobs true
set --global pure_enable_virtualenv false
set --global pure_symbol_git_dirty ""
set --global pure_symbol_git_stash ""
set --global pure_symbol_prompt "$(cat /proc/(ps -o ppid= -p $fish_pid | grep -Po '[0-9]+')/comm | sed -e 's/^kitty$//' -e 's/.$/\0 /')❯"

source /usr/local/bin/python-venv/bin/activate.fish

# fish_key_reader
bind \b backward-kill-word 
bind \e\[3\;5~ kill-word

if test "$PWD" = "$HOME"
    echo
    echo "❤️ Hi there!"
    echo
    echo "Here are some ideas in case you were looking for something to do:"
    cat ~/todo.txt
    echo
end
