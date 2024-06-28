#!/usr/bin/fish

trap 'kill (jobs -p)' EXIT

function main
    mkdir -p /tmp/bar
    cd /tmp/bar
    $home/bar/reader.fish
end

set -g home (realpath (status dirname))
main
