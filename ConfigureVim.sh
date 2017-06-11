#!/bin/bash
ln -s ~/Dev/Config/DotFiles/vimrc ~/.vimrc

#mkdir ~/.vim
mkdir -p ~/.vim/backups

mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

