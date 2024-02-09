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
    echo -n " "
    free | grep Mem | perl -ne 'my @a = split " "; printf("%.0f%%", 100*$a[2]/$a[1])'
}

function volume_loop() {
    volume_get > volume
}
function volume_get() {
    if [ "$(pactl get-sink-mute @DEFAULT_SINK@)" == "Mute: no" ]; then
        echo -n ' '
    else
        echo -n ' '
    fi
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+%' | head -1
}

function mic_loop() {
    mic_get > mic
}
function mic_get() {
    if [ "$(pactl get-source-mute @DEFAULT_SOURCE@)" == "Mute: no" ]; then
        echo -n ' '
    else
        echo -n ' '
    fi
    pactl get-source-volume @DEFAULT_SOURCE@| grep -Po '[0-9]+%' | head -1
}

function network_loop() {
    network_get > network
}
function network_get() {
    /usr/sbin/iwgetid -r # TODO: show status/connected or not
    echo -n " 󰖩 "
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
    xdotool getwindowfocus getwindowname # TODO i3 ipc socket
}

date_tzs=("" "EST5EDT" "CST6CDT" "UTC")
date_tzs_names=("" " EST" " CST" " UTC")
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
    (
        echo '[{"full_text":""}'
        for f in window memory volume mic date network; do
            cat <<EOT 
            ,{
                "name":"$f",
                "full_text":"$(cat $f)",
                "markup": "pango",
                "border":"#000000",
                "border_bottom":0,
                "border_right":0,
                "border_left":0,
                "border_top":0
            }
EOT
        done
        echo '],'
    ) | tr -d '\n' 
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
    esac
done
