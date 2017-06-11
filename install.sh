#!/bin/bash
ln -s ~/dotfiles/vimrc ~/.vimrc

mkdir -p ~/dotfiles/vim/backups

mkdir -p ~/dotfiles/vim/autoload ~/dotfiles/vim/bundle && curl -LSso ~/dotfiles/vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

