" Common vimrc settings for different vims & vim emulations


" Navigation stuff
" Word-wrapped lines navigable with j & k
nmap j gj
nmap k gk


" mappings
" Y yanks to end of line, change to nnoremap???
map Y y$ 
" tab & shift tab for indenting highlighted line & keeping highlight active
vmap <TAB> >gv
vmap <S-TAB> <gv


" General UI Settings
set scrolloff=5 " scroll before hitting the edge
set number " show line numbers for wapping cursor to a line with :<line number> or <line number>G


" search options & highlighting
  " goodness with case
set ignorecase
set smartcase
  " highlight all matches & do incremental search to first instance
set hlsearch
set incsearch


" Leader grammar
" This is pretty nice with the textblade. Space for leader, add slash for localLeader.
let mapleader = " "
let maplocalleader = "\\" 
nnoremap <Leader><Leader> :nohlsearch<CR>

" s - Selection
" Select All
nnoremap <Leader>sa ggVG 
