#!/bin/bash

# Set up colours
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function gitignore {
  #DEST=~/dotfiles/$1
  DEST=$1
  PATTERN=^$DEST$
  IGNOREFILE=~/dotfiles/.gitignore
  if grep -iq $PATTERN "$IGNOREFILE" ; then
    echo -e "${YELLOW}$DEST already in .gitignore"
  else
    echo -e "${GREEN}Adding $DEST to .gitignore"
    echo "$DEST" >> $IGNOREFILE 
  fi
}

function binlink {
  SOURCE=/bin/$1
  DEST=/usr/local/bin/$1
  if [ -e $DEST ]; then
    echo -e "${YELLOW}$1 exists in /usr/local/bin. Not linking."
  else
    echo -e "${GREEN}Linking $1 to /usr/local/bin from $SOURCE"
    ln -s $SOURCE $DEST
  fi
}


function link {
  SOURCE=~/dotfiles/$1/$2
  DEST=~/.$2
  if [ -e $DEST ]; then
    echo -e "${YELLOW}.$2 exists. Not linking."
  else
    echo -e "${GREEN}Linking $2 from $SOURCE"
    ln -s $SOURCE $DEST
  fi
}

function createFolder {
  DEST=~/dotfiles/$1
  if [ -d $DEST ]; then
    echo -e "${YELLOW}.$DEST exists. Not creating."
  else
    echo -e "${GREEN}Creating folder $DEST"
    mkdir -p $DEST
    gitignore $1
  fi
}

function curlGet {
  NAME=$1
  DEST=~/dotfiles/$2
  SOURCE=$3
  if [ -e $DEST ]; then
    echo -e "${YELLOW}$NAME already pulled"
  else
    echo -e "${GREEN}Pulling $NAME"
    curl -LSso $DEST $SOURCE
    gitignore $2
  fi
}

function gitGet {
  NAME=$1
  DEST=~/dotfiles/$2
  SOURCE=$3
    echo -e "${RED}gitGet should check for changes & prompt for an update!!!!"
  if [ -e $DEST ]; then
    echo -e "${YELLOW}$NAME already pulled"
  else
    echo -e "${GREEN}Pulling $NAME from $SOURCE into $DEST"
    git clone --depth=1 $SOURCE $DEST 
    rm -rf $DEST/.git
    rm $DEST/.gitignore
    gitignore $2
  fi
}

binlink zsh

link vim vimrc
link . vim
link nix/zsh zshrc
link nix/tmux tmux.conf
link nix/tmux tmux

createFolder vim/backups

createFolder vim/autoload 
createFolder vim/bundle 
curlGet Pathogen vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
# Vim plugins
# File browser
gitGet NERDtree vim/bundle/nerdtree https://github.com/scrooloose/nerdtree.git
# zsh autosuggestion
gitGet zsh-autosuggestions nix/oh-my-zsh/plugins/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions

# Generic syntax checking
gitGet syntastic vim/bundle/syntastic https://github.com/vim-syntastic/syntastic.git
# Idris extensions
#gitGet idris-vim vim/bundle/idris-vim https://github.com/idris-hackers/idris-vim.git
# Rust & TOML
#gitGet rust.vim vim/bundle/rust.vim https://github.com/rust-lang/rust.vim.git
#gitGet vim-toml vim/bundle/vim-toml https://github.com/cespare/vim-toml.git
#gitGet async.vim vim/bundle/async.vim https://github.com/prabirshrestha/async.vim.git
#gitGet vim-lsp vim/bundle/vim-lsp https://github.com/prabirshrestha/vim-lsp.git
#gitGet asyncomplete.vim vim/bundle/asyncomplete.vim https://github.com/prabirshrestha/asyncomplete.vim.git
#gitGet asyncomplete-lsp.vim vim/bundle/asyncomplete-lsp.vim https://github.com/prabirshrestha/asyncomplete-lsp.vim.git

gitGet oh-my-zsh nix/oh-my-zsh git://github.com/robbyrussell/oh-my-zsh.git

gitGet tpm  nix/tmux/tmux/plugins/tpm https://github.com/tmux-plugins/tpm 

link nix oh-my-zsh

# Manual install steps
# vim
#  :helptags ~/.vim/bundle/nerdtree/doc/
#  :helptags ~/.vim/bundle/syntastic/doc
#  :helptags ~/.vim/bundle/idris-vim/doc
#  ??? pathogen#helptags() added to .vimrc should cover this

# tmux
#  Prefix I -- tpm install plugins
