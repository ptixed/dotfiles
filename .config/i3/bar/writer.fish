#!/usr/bin/fish

function dict_set --argument-names module value
    set -g __$module $value
end

function dict_get --argument-names module
    set var __$module
    echo $$var
end

function update_one -a module -a command
    set full_text ($home/modules/$module $command)
    set offset $status

    set now (date +%s)
    set next_wakeup (math "$now + $offset")
    set -g wakeups $wakeups "$next_wakeup $module"

    if test "$full_text" != ''
        dict_set $module $full_text
    end
end

function update_all -a command
    set -g wakeups
    for module in date # add more here
        update_one (basename $module) $command
    end
end

function print_one -a module -a separator
    set full_text (dict_get $module)
    if test "$full_text" != ''
        jq -n --arg name $module --arg full_text "$full_text" --argjson separator $separator '{ 
            "name": $name, 
            "full_text": $full_text,
            "separator": $separator,
            "separator_block_width": 11
        }'
        echo ','
    end
end

function print_all 
    echo '['
    # add more here
    print_one date false
    echo '{"full_text":""}]'
end

function main
    set -g wakeups
    update_all init

    echo '['
    while true
        update_all refresh

        print_all | jq
        echo ','

        set next (printf %s\n $wakeups | sort -n | head -1)
        set next_wakeup (echo $next | cut -d' ' -f1)
        set next_module (echo $next | cut -d' ' -f2)

        set now (date +%s)
        sleep (math "max(0, $next_wakeup - $now)") &
        echo $last_pid > pid
        wait
    end
end

set -g home (realpath (status dirname))
main
