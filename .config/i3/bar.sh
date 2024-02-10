#!/bin/bash

# https://i3wm.org/docs/i3bar-protocol.html

trap 'kill $(jobs -p)' EXIT
trap 'volume_loop' USR1

mkdir -p /tmp/i3-bar
cd /tmp/i3-bar
echo $$ > pid

memory_pid=
function memory_loop() {
    kill $memory_pid
    while true; do
        memory_get > memory
        sleep 5
    done &
    memory_pid=$!
}
function memory_get() {
    echo " "
    free | grep Mem | perl -ne 'my @a = split " "; printf("%.0f%%", 100*$a[2]/$a[1])'
}

function volume_loop() {
    volume_get > volume
}
function volume_get() {
    if [ "$(pactl get-sink-mute @DEFAULT_SINK@)" == "Mute: no" ]; then
        echo ' '
    else
        echo ' '
    fi
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+%' | head -1
}

function mic_loop() {
    mic_get > mic
}
function mic_get() {
    if [ "$(pactl get-source-mute @DEFAULT_SOURCE@)" == "Mute: no" ]; then
        echo ' '
    else
        echo ' '
    fi
    pactl get-source-volume @DEFAULT_SOURCE@| grep -Po '[0-9]+%' | head -1
}

network_pid=
function network_loop() {
    kill $network_pid
    while true; do
        network_get > network
        sleep 5
    done &
    network_pid=$!
}
function network_get() {
    if nc -zw1 1.1.1.1 53; then
        echo "󰖩 "
    else
        echo "󰖪 "
    fi    
}

window_pid=
function window_loop() {
    kill $window_pid
    while true; do
        window_get > window
        sleep 1
    done &
    window_pid=$!
}
function window_get() {
    xdotool getwindowfocus getwindowname | jq -R | sed -E 's/^"(.*)"$/\1/' # TODO i3 ipc socket
}

music_pid=
function music_toggle() {
    if [ "$music_pid" == "" ]; then
        (
            curl https://ice5.somafm.com/defcon-128-mp3 | ffplay -nodisp - &
            pid=$!
            trap "kill $pid" EXIT
            while true; do 
                meta=$(curl https://somafm.com/songs/defcon.xml)
                title=$(echo "$meta" | grep --color -Po 'title.*CDATA\[\K[^\]]+' | head -1)
                artist=$(echo "$meta" | grep --color -Po 'artist.*CDATA\[\K[^\]]+' | head -1)
                echo "$artist: $title" > music
                sleep 5
            done
        ) &
        music_pid=$!
    else
        kill $music_pid
        echo "󰝚" > music
        music_pid=
    fi
}
echo "󰝚" > music

date_tzs=("Europe/Warsaw" "America/New_York" "America/Chicago" "UTC")
date_tzs_names=("" " ET" " CT" " UTC")
date_tzs_i=0
date_tzs_n=4
date_pid=
function date_loop() {
    kill $date_pid
    while true; do
        date_get > date
        sleep $((60 - $(date +%S)))
    done &
    date_pid=$!
}
function date_get() {
    tz=${date_tzs[$date_tzs_i]}
    tz_name=${date_tzs_names[$date_tzs_i]}
    TZ=$tz date "+%b %d %a %H:%M$tz_name"
}

function print_all() {
    {
        echo '[{"full_text":""}'
        for f in window memory music mic volume date network; do
            cat <<EOT 
            ,{
                "name":"$f",
                "full_text":"$(cat $f)",
                "background":"#00000001"
            }
EOT
        done
        echo '],'
     } | tr -d '\n' 
}

date_loop
memory_loop
mic_loop
network_loop
volume_loop
window_loop

# wait for data
sleep 1

# first print
echo '{ "version": 1, "click_events": true }'
echo '['
print_all

# now only print on changes
inotifywait -m . -e close_write | while read; do 
    print_all
done &

lmb=1
mmb=2
rmb=3
scroll_up=4
scroll_down=5

read
while read -r line; do
    case $(echo "$line" | sed 's/^,//' | jq -r '"\(.name),\(.button)"') in
        date,$scroll_up)
            date_tzs_i=$(( ($date_tzs_i+1)%$date_tzs_n ))
            date_loop
            ;;
        date,$scroll_down)
            date_tzs_i=$(( ($date_tzs_i-1+$date_tzs_n)%$date_tzs_n ))
            date_loop
            ;;
        volume,$lmb)
            pactl set-sink-mute @DEFAULT_SINK@ toggle
            volume_loop
            ;;
        volume,$scroll_up)
            pactl set-sink-volume @DEFAULT_SINK@ +5%
            volume_loop
            ;;
        volume,$scroll_down)
            pactl set-sink-volume @DEFAULT_SINK@ -5%
            volume_loop
            ;;
        memory,$rmb)
            kitty btop &
            ;;
        mic,$lmb)
            pactl set-source-mute @DEFAULT_SOURCE@ toggle
            mic_loop
            ;;
        mic,$scroll_up)
            pactl set-source-volume @DEFAULT_SOURCE@ +5%
            mic_loop
            ;;
        mic,$scroll_down)
            pactl set-source-volume @DEFAULT_SOURCE@ -5%
            mic_loop
            ;;
        network,$rmb)
            nm-connection-editor &
            ;;
        music,$lmb)
            music_toggle
            ;;
    esac
done
