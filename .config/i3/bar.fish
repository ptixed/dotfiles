#!/usr/bin/fish

function main
    mkdir -p /tmp/bar2
    cd /tmp/bar2
    $home/bar/reader.fish
end

set -g home (realpath (status dirname))
main
