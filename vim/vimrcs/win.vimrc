" The vimrc to use when running under Windows

" first, load in the normal vimrc
source ~/vimfiles/vimrcs/common.vimrc
source ~/vimfiles/vimrcs/true.vimrc

set shell=powershell
set shellcmdflag=-NoLogo\ -NoProfile\ -NonInteractive\ -ExecutionPolicy\ RemoteSigned
set shellpipe=|
set shellredir=>

if has("gui_running") " Some stuff suitable for gvim, less good for the terminal
  set guifont=Consolas:h9:cANSI
  " crosshairs - Cool but messy in commandline mode
  set cursorcolumn 
  set cursorline
endif

set termguicolors

" This _SHOULD_ allow me to have different cursor styles in terminal Vim as you change modes.
" Unfortunately, with my current setup (windows terminal 1.21 & normal vim 8.2), when you go into replace mode, it jumps the cursor forwards several chars for no good reason, hence commenting it out.
" I'm leaving it here to retry with future versions or if I switch to nvim...
" let &t_SR.="\e[3 q" "SR = REPLACE mode
" let &t_SI.="\e[5 q" "SI = INSERT mode
" let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)
" let &t_ti .= "\e[1 q"
" let &t_te .= "\e[0 q"
" "Cursor settings:
" "  1 -> blinking block
" "  2 -> solid block 
" "  3 -> blinking underscore
" "  4 -> solid underscore
" "  5 -> blinking vertical bar
" "  6 -> solid vertical bar