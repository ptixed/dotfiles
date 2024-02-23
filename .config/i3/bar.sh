#!/bin/bash

# https://i3wm.org/docs/i3bar-protocol.html

trap volume_refresh USR1
trap lang_switch USR2

mkdir -p /tmp/i3-bar
cd /tmp/i3-bar
echo $$ > pid

memory_pid=
function memory_loop() {
    kill $memory_pid
    while true; do
        memory=$(memory_get)
        echo "$memory" > memory
    done &
    memory_pid=$!
}
function memory_get() {
    cpu0=$(grep 'cpu ' /proc/stat)
    cpu0usr=$(echo "$cpu0" | cut -d' ' -f3)
    cpu0sys=$(echo "$cpu0" | cut -d' ' -f5)
    cpu0idl=$(echo "$cpu0" | cut -d' ' -f6)
    sleep 5
    cpu1=$(grep 'cpu ' /proc/stat)
    cpu1usr=$(echo "$cpu1" | cut -d' ' -f3)
    cpu1sys=$(echo "$cpu1" | cut -d' ' -f5)
    cpu1idl=$(echo "$cpu1" | cut -d' ' -f6)
    
    n=$(( ($cpu1usr+$cpu1sys-$cpu0usr-$cpu0sys) ))
    n=$(( 100*$n/($n + $cpu1idl - $cpu0idl) ))
    if [ ${#n} == 1 ]; then
        n=0$n
    fi
    echo " $n%  "
    free | grep Mem | perl -ne 'my @a = split " "; printf("%02.0f%%", 100*$a[2]/$a[1])'
}

function volume_refresh() {
    volume_get > volume
}
function volume_get() {
    state=$(wpctl get-volume @DEFAULT_SINK@)
    if  [[ "$state" == *MUTED* ]] then
        echo ' '
    else
        echo ' '
    fi
    echo "$state" | sed -E -e 's/.*([0-9])\.([0-9][0-9]).*/\1\2%/' -e 's/^0//g'
}

function mic_refresh() {
    mic_get > mic
}
function mic_get() {
    state=$(wpctl get-volume @DEFAULT_SOURCE@)
    if  [[ "$state" == *MUTED* ]] then
        echo ' '
    else
        echo ' '
    fi
    echo "$state" | sed -E -e 's/.*([0-9])\.([0-9][0-9]).*/\1\2%/' -e 's/^0//g'
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
        echo "󰖩"
    else
        echo "󰖪"
    fi    
}

battery_pid=
function battery_loop() {
    kill $battery_loop
    while true; do 
        battery_get > battery
        sleep 60
    done &
    battery_pid=$!
}
function battery_get() {
    x=$(cat /sys/class/power_supply/BAT0/capacity)
    if [ "$x" != "100" ]; then
        echo "$x%"
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

radio_stations=("https://ice5.somafm.com/defcon-128-mp3" "https://stream13.polskieradio.pl/pr3/pr3.sdp/chunklist_w1757229385.m3u8")
radio_stations_names=("SOMA" "Trojka")
radio_stations_i=0
radio_stations_n=2
radio_pid=
function radio_toggle() {
    if [ "$radio_pid" != "" ]; then
        kill $radio_pid
        radio_pid=
    else
        station=${radio_stations[$radio_stations_i]}
        mpv "$station" > >(grep  --line-buffered -Po 'icy-title: \K.*' \
            | while read title; do 
                echo "$title" > radio
            done 
        ) &
        radio_pid=$!
    fi
}
function radio_refresh() {
    station_name=${radio_stations_names[$radio_stations_i]}
    if [ "$radio_pid" != "" ]; then
        radio_toggle
        echo "$station_name" > radio
        radio_toggle
    else
        echo "$station_name" > radio
    fi
}

function lang_refresh() {
    lang_get > lang
}
function lang_get() {
    if [ "$(ibus engine)" != "anthy" ]; then
        echo "pl"
    else
        echo "jp"
    fi
}
function lang_switch() {
    if [ "$(ibus engine)" == "xkb:pl::pol" ]; then
        ibus engine anthy
    else
        ibus engine xkb:pl::pol
    fi
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

function print_one() {
    if [ "$2" == "true" ]; then
        cat <<EOT 
        ,{
            "name": "$1",
            "full_text": "$(cat $1)"
        }
EOT
    else
        cat <<EOT 
        ,{
            "name": "$1",
            "full_text": "$(cat $1)",
            "separator": false,
            "separator_block_width": 11
        }
EOT
    fi
}

function print_all() {
    {
        echo '[{"full_text":""}'
        # print_one window true
        print_one radio true
        print_one volume false
        print_one mic true
        print_one memory true
        print_one date true
        print_one lang false
        print_one network false
        print_one battery false
        echo '],'
     } | tr -d '\n' 
}

# window_loop
date_loop
memory_loop
network_loop
battery_loop

lang_refresh
volume_refresh
mic_refresh

radio_refresh

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
            wpctl set-mute @DEFAULT_SINK@ toggle
            volume_refresh
            ;;
        volume,$scroll_up)
            wpctl set-volume @DEFAULT_SINK@ 0.05+
            volume_refresh
            ;;
        volume,$scroll_down)
            wpctl set-volume @DEFAULT_SINK@ 0.05-
            volume_refresh
            ;;
        memory,$lmb)
            kitty btop &
            ;;
        mic,$lmb)
            wpctl set-mute @DEFAULT_SOURCE@ toggle
            mic_refresh
            ;;
        mic,$scroll_up)
            wpctl set-volume @DEFAULT_SOURCE@ 0.05+
            mic_refresh
            ;;
        mic,$scroll_down)
            wpctl set-volume @DEFAULT_SOURCE@ 0.05-
            mic_refresh
            ;;
        network,$lmb)
            nm-connection-editor &
            ;;
        radio,$lmb)
            radio_toggle
            ;;
        radio,$scroll_up)
            radio_stations_i=$(( ($radio_stations_i+1)%$radio_stations_n ))
            radio_refresh
            ;;
        radio,$scroll_down)
            radio_stations_i=$(( ($radio_stations_i-1+$radio_stations_n)%$radio_stations_n ))
            radio_refresh
            ;;
        lang,$lmb)
            lang_switch
            lang_refresh
            ;;
    esac
done
