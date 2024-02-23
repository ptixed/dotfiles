function fish_title \
    --description "Set title to current folder and shell name" \
    --argument-names last_command

    set --local current_command (status current-command 2>/dev/null; or echo $_)

    if [ "$current_command" = "fish" ]
        prompt_pwd
    else
        echo $current_command
    end
end
