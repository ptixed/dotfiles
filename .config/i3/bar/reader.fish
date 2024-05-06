#!/usr/bin/fish

function main
    set keys lmb mmb rmb scrollup scrolldown

    echo '{ "version": 1, "click_events": true }'
    $home/writer.fish &

    while read event
        set parts (echo $event | string trim -c, | jq -r '.name,.button')
        if test "$parts[1]" != '' -a "$keys[$parts[2]]" != ''
            $home/modules/$parts[1] $keys[$parts[2]]
            kill (cat pid)
        end
    end
end

set -g home (realpath (status dirname))
main
