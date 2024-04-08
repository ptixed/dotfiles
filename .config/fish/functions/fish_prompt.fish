function fish_prompt
    set --local exit_code $status
    echo

    set_color blue
    fish_prompt_pwd_dir_length=0 prompt_pwd | tr -d "\n"

    set_color brblack
    fish_git_prompt
    echo

    set --local jobs (jobs -c | tail +1)
    if test "$jobs"
        echo -n "$(string join " " $jobs)... "
    end

    set --local symbol "❯"
    if fish_is_root_user
        set --local symbol "#"
    end

    if test "$exit_code" != 0
        set_color red
    else
        set_color magenta
    end

    set --local parent_process (cat /proc/(ps -o ppid= -p $fish_pid | grep -Po '[0-9]+')/comm)
    if test "$parent_process" = kitty
        echo -n "$symbol "
    else
        echo -n "$parent_process $symbol "
    end

    set_color normal
end
