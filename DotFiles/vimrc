"   ************   MAIN VIMRC!!!!!!!!!
"
"   onfiguring powershell for the vim shell
  " this could do with being pulled out to a different file and sourced for better source control across platforms

if has("unix")
  " also set in gui mode - bad in windows command line
  set cursorcolumn 
  set cursorline

  if (system('uname') == "Darwin\n")
    " OSX
  endif

  if (system('uname') == "Linux\n")
    " LINUX
  endif
elseif has("win32")
  " WINDOWS
  set shell=powershell
  set shellcmdflag=-NoLogo\ -NoProfile\ -NonInteractive\ -ExecutionPolicy\ RemoteSigned
  set shellpipe=|
  set shellredir=>
endif


" Taken hints from vi-improved.org/vimrc.html and vim.wikia.com/wiki/example_vimrc

" Quckly tap jk to go to normal mode :)
"inoremap jk <ESC>
"vnoremap jk <ESC>
" falls through to ESC mapping for added :nohlsearch in normal mode
"nmap jk <ESC> 
"set timeoutlen=100 " nice and quick bailing on mappings
  " may need to separately set ttimeout stuff at some point...
  " timeoutlen effects <Leader> grammar




" Navigation stuff
" turbo cursor navigation
" " NOTE - I had commented this out due to VsVim inserting the text rather
" than remapping...
nnoremap <silent> <Left> @='5h'<CR>|xnoremap <silent> <Left> @='5h'<CR> "|onoremap <Left> 5h|
nnoremap <silent> <Up> @='5k'<CR>|xnoremap <silent> <Up> @='5k'<CR> "|onoremap <Up> 5k|
nnoremap <silent> <Down> @='5j'<CR>|xnoremap <silent> <Down> @='5j'<CR> "|onoremap <Down> 5j|
nnoremap <silent> <Right> @='5l'<CR>|xnoremap <silent> <Right> @='5l'<CR> "|onoremap <Right> 5l|

" Word-wrapped lines navigable with j & k
nmap j gj
nmap k gk





" mappings
" Y yanks to end of line, change to nnoremap???
map Y y$ 
" map escape to clear highlight -- changing to double space due to terminal foobar with escape codes
" nnoremap <ESC> :nohlsearch<CR><ESC> 

" General UI Settings
syntax on
filetype on
filetype plugin on
filetype indent on

" au(tomatically) apply syntax to filetypes when loaded
au BufNewFile,BufRead *.config set filetype=xml

set nocompatible " vim not vi
set scrolloff=5 " scroll before hitting the edge
set display=lastline " show what can be seen of long, wrapping-lines as you scroll, rather than waiting til it all fits the screen (which it may never do)
set display+=uhex " and show unicode values for undisplayable chars rather than odd control char thingies
"highlight cursorline ctermbg=1 "dark blue background for readability
  " good statusbar info
set ruler 
set laststatus=2
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
set noerrorbells visualbell " stop beeping all the time
" show line numbers for wapping cursor to a line with :<line number> or <line number>G
set number
" gvim stuff
if has("gui_running") " Some stuff suitable for gvim might be less good for the terminal
  set lines=45 columns=160
  " Good on Windows, may want to find options for OSX / Linux
  set guifont=Consolas:h9:cANSI
  " crosshairs - Cool but messy in commandline mode
  set cursorcolumn 
  set cursorline
  " different options for macvim? different conditional check???
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

" tab & shift tab for indenting highlighted line & keeping highlight active
vmap <TAB> >gv
vmap <S-TAB> <gv

" search options & highlighting
  " goodness with case
set ignorecase
set smartcase
  " highlight all matches & do incremental search to first instance
set hlsearch
set incsearch
" keep backup/restore/swap type files out of the way, rather than in the same folder
set backupdir=~/.vim/backups
set directory=~/.vim/backups

" File type specific tweaks - may want to pull out to individual files in
" ftplugin dir
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" Set up any plugin bits n bobbins
"execute pathogen#infect()



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
let mapleader = ' '
nmap <Silent> <Leader><Leader> :nohlsearch<CR>
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
nnoremap <Leader>sa ggVG " Select All
" copy & paste to system clipboard -- NOTE using + instead of * was this a linux thing? do i need to do more OS checks?
vmap <Leader>sy "+y
vmap <Leader>sd "+d
nmap <Leader>sp "+p
nmap <Leader>sP "+P
vmap <Leader>sp "+p
vmap <Leader>sP "+P

" t - Toggles
nmap <Leader>tp :set paste!<CR> " p - Paste mode - stops indents & stuff... allegedly...

