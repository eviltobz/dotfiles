" basic log4net vim syntax file

if exists("b:current_syntax")
    finish
endif

syn case ignore


syn region Metadata start="^" end=" - " contains=Datestamp,Timestamp,Thread,HighLog,LowLog,Component

syn match Datestamp contained "^[0-9]\{4}-[0-9]\{2}-[0-9]\{2}" nextgroup=Timestamp skipwhite
syn match Timestamp contained "[0-9]\{2}:[0-9]\{2}:[0-9]\{2},[0-9]\{3}" nextgroup=Thread skipwhite
syn match Thread contained "\[.\{-}]" nextgroup=LowLog skipwhite

syn keyword HighLog contained FATAL ERROR WARN 
syn keyword LowLog contained  INFO DEBUG TRACE nextgroup=Component skipwhite

syn match Component contained " .\{-} - " " nextgroup=LogMessage skipwhite
"syn match LogMessage ".*$"

" Colour Groups: 
" Comment (blue) Constant (pinky) Identifier (purple) Statement (brown) PreProc (dark green) Type (light blue) Special (light purple) 
" Underlined (light blue & underline)  Error (white on red) Todo (blue on yellow)
" Ignore (same as background!)


hi def link Datestamp Statement
hi def link Timestamp Todo
hi def link Thread PreProc
hi def link HighLog Error
hi def link LowLog Identifier
hi def link Component Comment




let b:current_syntax = "log"
