#!/usr/bin/fish

# same as in reader.fish
function update_one -a module command
    begin
        flock 3
        set env (cat state/$module 2>/dev/null)
        eval $env $home/modules/$module $command >state/$module
        flock -u 3
    end 3>lock
end

function update_all -a command
    for module in date radio volume mic yt
        update_one $module $command
    end
end

function print_one -a module separator
    function f
        if test "$output" = ''
            return
        else if test "$separator" = 'false'
            jq -n --arg name $module --arg output "$output" '{ 
                "name": $name, 
                "full_text": $output,
                "separator": false,
                "separator_block_width": 11
            }'
        else
            jq -n --arg name $module --arg output "$output" '{ 
                "name": $name, 
                "full_text": $output
            }'
        end
        echo ','
    end
    begin
        flock 3
        eval module=$module separator=$separator (cat state/$module) f
        flock -u 3
    end 3>lock
end

function print_all 
    echo '['
    print_one radio true
    print_one mic false
    print_one volume true
    print_one date false
    echo '{"full_text":""}],'
end

function main
    update_all init

    echo '['
    while true
        update_all refresh
        print_all

        set wake (cat state/* | string match -r '(?<=wake=).*' | sort -n | head -1)
        set now (date +%s)

        sleep (math $wake - $now) &
        echo $last_pid >pid
        wait
    end
end

set -g home (realpath (status dirname))
main
