#!/bin/bash

# https://i3wm.org/docs/i3bar-protocol.html

trap 'kill $(jobs -p)' EXIT
trap 'volume_loop' USR1
trap 'lang_switch' USR2

mkdir -p /tmp/i3-bar
cd /tmp/i3-bar
echo $$ > pid

memory_pid=
function memory_loop() {
    kill $memory_pid
    while true; do
        cpu0=$(grep 'cpu ' /proc/stat)
        cpu0usr=$(echo "$cpu0" | cut -d' ' -f3)
        cpu0sys=$(echo "$cpu0" | cut -d' ' -f5)
        cpu0idl=$(echo "$cpu0" | cut -d' ' -f6)
        sleep 5
        cpu1=$(grep 'cpu ' /proc/stat)
        cpu1usr=$(echo "$cpu1" | cut -d' ' -f3)
        cpu1sys=$(echo "$cpu1" | cut -d' ' -f5)
        cpu1idl=$(echo "$cpu1" | cut -d' ' -f6)
        {
            n=$(( ($cpu1usr+$cpu1sys-$cpu0usr-$cpu0sys) ))
            n=$(( 100*$n/($n + $cpu1idl - $cpu0idl) ))
            if [ ${#n} == 1 ]; then
                n=0$n
            fi
            echo "$n%  "
            free | grep Mem | perl -ne 'my @a = split " "; printf("%02.0f%%", 100*$a[2]/$a[1])'
        } > memory
    done &
    memory_pid=$!
}
# TODO: memory_get

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
    pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '[0-9]+%' | head -1
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
    xdotool getwindowfocus getwindowname | jq -R | sed -E 's/^"(.*)"$/\1/' > window
    while true; do
        { 
            echo -n i3-ipc
            echo -n 0a00000002000000 | xxd -p -r 
            echo -n '["window"]'
        } | nc -U $(i3 --get-socketpath) | {
            while true; do
                header=$(head -c14 | xxd -p)
                len=$(echo "$header" | sed -E 's/.{12}(..)(..)(..)(..).*/ibase=16; \U\4\3\2\1/' | bc)
                body=$(head -c $len)
                window=$(echo "$body" | jq .container.name)
                if [ "$window" != "null" ]; then
                    echo "$window" | sed -E 's/^"(.*)"$/\1/' > window
                fi
            done
        } 
    done &
    window_pid=$!
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
                title=$(echo "$meta" | grep -Po 'title.*CDATA\[\K[^\]]+' | head -1)
                artist=$(echo "$meta" | grep -Po 'artist.*CDATA\[\K[^\]]+' | head -1)
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

function lang_loop() {
    lang_get > lang
}
function lang_get() {
    if [ "$(ibus engine)" == "xkb:pl::pol" ]; then
        echo "PL"
    else
        echo "JP"
    fi
}
function lang_switch() {
    if [ "$(ibus engine)" == "xkb:pl::pol" ]; then
        ibus engine anthy
    else
        ibus engine xkb:pl::pol
    fi
    lang_loop
}

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
        for f in window memory music mic volume lang date network; do
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
lang_loop
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
while read line; do
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
        lang,$lmb)
            lang_switch
            ;;
    esac
done
