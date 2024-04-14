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
    abbr --add broadcast kitty +kitten broadcast --match-tab state:focused

    function last_history_item
        echo $history[1]
    end
    abbr --add !! --position anywhere --function last_history_item
end

fish_add_path /usr/local/bin/python-venv/bin/

# fish_key_reader
bind \b backward-kill-word 
bind \e\[3\;5~ kill-word
bind \cO 'ranger; commandline -f repaint'

zoxide init --cmd cd fish | source

