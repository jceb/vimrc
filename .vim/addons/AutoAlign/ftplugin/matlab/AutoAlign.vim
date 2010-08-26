" AutoAlign: ftplugin support for MatLab
" Author:    Charles E. Campbell, Jr.
" Date:      Aug 16, 2007
" Version:   13
" ---------------------------------------------------------------------
let b:loaded_autoalign_matlab = "v13"
let b:undo_ftplugin= "v13"

"  overloading '=' to keep things lined up {{{1
ino <silent> = =<c-r>=AutoAlign(1)<cr>
let b:autoalign_reqdpat1 = '\%(^.*=\)\&\%(^\s*\%(\%(if\>\|elseif\>\|function\>\|while\>\|for\>\)\@!.\)*$\)'
let b:autoalign_notpat1  = '^[^=]\+$'
let b:autoalign_trigger1 = '='
if !exists("g:mapleader")
 let b:autoalign_cmd1     = 'norm \t=$'
else
 let b:autoalign_cmd1     = "norm ".g:mapleader."t=$"
endif
