#!/usr/bin/fish

mkdir -p state

# same as in writer.fish
function update_one -a module command
    begin
        flock 3
        set env (cat state/$module 2>/dev/null)
        eval $env $home/modules/$module $command >state/$module
        flock -u 3
    end 3>lock
end

function main
    set keys lmb mmb rmb scrollup scrolldown

    echo '{ "version": 1, "click_events": true }'
    $home/writer.fish &

    while read event
        set parts (echo $event | string trim -c, | jq -r '.name,.button')
        if test "$parts[1]" != '' -a "$keys[$parts[2]]" != ''
            update_one $parts[1] $keys[$parts[2]]
            kill (cat pid)
        end
    end
end

set -g home (realpath (status dirname))
main
