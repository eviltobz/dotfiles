" Settings for proper vim/neovim

" Navigation stuff
" turbo cursor navigation
nnoremap <silent> <Left> @='5h'<CR>|xnoremap <silent> <Left> @='5h'<CR> "|onoremap <Left> 5h|
nnoremap <silent> <Up> @='5k'<CR>|xnoremap <silent> <Up> @='5k'<CR> "|onoremap <Up> 5k|
nnoremap <silent> <Down> @='5j'<CR>|xnoremap <silent> <Down> @='5j'<CR> "|onoremap <Down> 5j|
nnoremap <silent> <Right> @='5l'<CR>|xnoremap <silent> <Right> @='5l'<CR> "|onoremap <Right> 5l|


" mappings
" Save with sudo
cmap w!! %!sudo tee > /dev/null %


" General UI Settings
syntax on
filetype on
filetype plugin indent on
" au(tomatically) apply syntax to filetypes when loaded
au BufNewFile,BufRead *.config set filetype=xml

set nocompatible " vim not vi
set display=lastline " show what can be seen of long, wrapping-lines as you scroll, rather than waiting til it all fits the screen (which it may never do)
set display+=uhex " and show unicode values for undisplayable chars rather than odd control char thingies
"highlight cursorline ctermbg=1 "dark blue background for readability
  " good statusbar info
set ruler 
set laststatus=2
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
set noerrorbells visualbell " stop beeping all the time

" gvim stuff
if has("gui_running") " Some stuff suitable for gvim might be less good for the terminal
  set lines=45 columns=160
endif
" other recommended stuff...
set wildmenu
set showcmd
set mouse=a
set confirm
"set cmdheight=2

" formatting & layout
set expandtab
set softtabstop=2
set shiftwidth=2
set autoindent
set backspace=indent,eol,start


" keep backup/restore/swap type files out of the way, rather than in the same folder
set backupdir=~/dotfiles/vim/backups
set directory=~/dotfiles/vim/backups
set undodir=~/dotfiles/vim/backups
set undofile

" File type specific tweaks - may want to pull out to individual files in
" ftplugin dir
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" command line movement keys
"cnoremap <C-a>  <Home>
"cnoremap <C-b>  <Left>
"cnoremap <C-f>  <Right>
"cnoremap <C-d>  <Delete>
"cnoremap <M-b>  <S-Left>
"cnoremap <M-f>  <S-Right>
"cnoremap <M-d>  <S-right><Delete>
"cnoremap <Esc>b <S-Left>
"cnoremap <Esc>f <S-Right>
"cnoremap <Esc>d <S-right><Delete>
"cnoremap <C-g>  <C-c>



" NOTE - Sometimes having a comment on the end make the command not work (:buffers for example)
" NOTE 2 - mebe write a plugin to list leader grammar by groups & drill in - 
"         - not quite spacemacs where it does it, but at least have the discoverability

" Leader grammar
" This is pretty nice with the textblade. Space for leader, add slash for localLeader.

" b - Buffer
  " buffer mini menu - list buffers, and prompt for number to select
nnoremap <Leader>bb :buffers<CR>:buffer<Space>
nmap <Leader>b1 :buffer 1<CR> " switch to buffer
nmap <Leader>b2 :buffer 2<CR> " switch to buffer
nmap <Leader>b3 :buffer 3<CR> " switch to buffer
nmap <Leader>b4 :buffer 4<CR> " switch to buffer
nmap <Leader>b5 :buffer 5<CR> " switch to buffer

" f - Files
nnoremap <Leader>ft :NERDTreeToggle<CR> " t - Tree
"nnoremap <Leader>f. :e ~/.vimrc<CR>     " . - edit .vimrc
nnoremap <Leader>f. :e $MYVIMRC<CR>     " . - edit .vimrc
nnoremap <Leader>fr :so $MYVIMRC<CR>     " source - re-source .vimrc
" - let's try to get some common file-format furtling stuff 
" - http://stackoverflow.com/questions/3853028/how-to-force-vim-to-syntax-highlight-a-file-as-html
" - for things like editing html templates in the deploying SQL file. 
" mebe have some common type setting binds, and a general one that needs an arg
" look into differences between filetype & syntax - syntax may be more appropriate when hacking html in an sql
" "Note that :set syntax=xml highlights properly but seems to fail when one is attempting to autoindent the file 
" "(i.e. running gg=G). When I switched to :set filetype=xml, the highlighting worked properly and the file indented properly.



" s - Selection
" copy & paste to system clipboard -- NOTE using + instead of * was this a linux thing? do i need to do more OS checks?
vmap <Leader>sy "+y
vmap <Leader>sd "+d
nmap <Leader>sp "+p
nmap <Leader>sP "+P
vmap <Leader>sp "+p
vmap <Leader>sP "+P

" t - Toggles
nmap <Leader>tp :set paste!<CR> " p - Paste mode - stops indents & stuff... allegedly...

