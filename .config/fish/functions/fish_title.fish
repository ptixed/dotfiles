function fish_title
    set --local current_command (status current-command)

    if [ "$current_command" = "fish" ]
        prompt_pwd
    else
        echo $current_command
    end
end
