#!/bin/bash

cd $(dirname $0)

export MSYS=winsymlinks:nativestrict 

ln -sT $PWD/.bashrc ~/.bashrc
ln -sT $PWD/.tmux.conf ~/.tmux.conf
ln -sT $PWD/.vimrc ~/.vimrc
ln -sT $PWD/.vim ~/.vim

mkdir -p ~/.config/ncspot/
ln -sT $PWD/.config/ncspot/config.toml ~/.config/ncspot/config.toml

if uname | grep -q MINGW; then
	cp bin/* /usr/bin/
fi
