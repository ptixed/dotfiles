#!/bin/bash

# https://i3wm.org/docs/i3bar-protocol.html

trap 'kill $(jobs -p)' EXIT

mkdir -p /tmp/i3-bar
cd /tmp/i3-bar

date_tzs=("" "EST")
date_tzs_names=("" " EST")
date_tzs_i=0
date_tzs_n=2
date_pid=
function date_loop() {
    kill $date_pid
    tz=${date_tzs[$date_tzs_i]}
    tz_name=${date_tzs_names[$date_tzs_i]}
    while true; do
        TZ=$tz date "+%b %d %a %H:%M$tz_name" > date
        sleep $((60 - $(date +%S)))
    done &
    date_pid=$!
}

date_loop

echo '{ "version": 1, "click_events": true }'
echo '['
while true; do
    jq --null-input --compact-output \
        --arg date "$(cat date)" \
        '[{name: "aaa", full_text: "aaa"}, {name: "date", full_text: $date }]'
    echo ','
    sleep 1 # TODO inotify
done & 

read
while read -r line; do
    case $(echo "$line" | sed 's/^,//' | jq -r .name) in
        date)
            date_tzs_i=$(( ($date_tzs_i+1)%$date_tzs_n ))
            date_loop
            ;;
    esac
done
