#!/bin/bash
cd $(dirname $0)
for f in $(find -maxdepth 1 -name '.*' | grep -Po '\.\/\K\..*' | grep -v '^\.git'); do
    if [ -e ~/$(basename $f) ]; then
        echo ~/$(basename $f) already exists
    else
        ln -s $PWD/$f ~/$(basename $f)
    fi
done

