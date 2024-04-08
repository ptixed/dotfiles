function fish_greeting
    if test "$PWD" != "$HOME"
        return
    elif test $(cat /proc/(ps -o ppid= -p $fish_pid | grep -Po '[0-9]+')/comm) != "kitty"
        return
    end

    echo
    echo "❤️ Hi there!"
    echo

    if ! test -f ~/todo.txt
        return 
    end
        
    echo "Here are some ideas in case you were looking for something to do:"
    cat ~/todo.txt | grep -vP '^\*\*'
end

