" The vimrc to use when running under Windows

" first, load in the normal vimrc
source ~\vimfiles\vimrcs\common.vimrc
source ~\vimfiles\vimrcs\true.vimrc

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


