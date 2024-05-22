function export
    set var (echo $argv | cut -f1 -d=)
    set val (echo $argv | cut -f2 -d=)
    set -g -x $var $val
end

if status is-interactive
    abbr g git
    abbr ga git add -A
    abbr gc git checkout
    abbr gd git diff
    abbr gdc git diff --cached
    abbr gp git pull
    abbr gs git status
    abbr apti sudo apt install --no-install-recommends
    abbr la ls -la
    abbr grep grep --color
    abbr code code --password-store=gnome-libsecret

    function last_history_item
        echo $history[1]
    end
    abbr !! --position anywhere --function last_history_item

    # fish_key_reader
    bind \b backward-kill-word 
    bind \e\[3\;5~ kill-word
    bind \cO 'ranger; commandline -f repaint'

    zoxide init --cmd cd fish | source
end

fish_add_path $HOME/.local/python-venv/bin/
