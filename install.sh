#!/bin/bash

cd $(dirname $0)

for f in $(find -maxdepth 1 -name '.?*' | sed 's/^..//' | grep -v '^.git'); do
    if [ -e ~/$f ]; then
        echo ~/$f already exists
    else
        ln -s $PWD/$f ~/$f
    fi
done

if uname | grep -q MINGW; then
	cp bin/* /usr/bin/
fi
