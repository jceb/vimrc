" AutoAlign: ftplugin support for Maple
" Author:    Charles E. Campbell, Jr.
" Date:      Aug 16, 2007
" Version:   14
" ---------------------------------------------------------------------
let b:loaded_autoalign_maple = "v14"
let b:undo_ftplugin= "v13b"

"  overloading '=' to keep things lined up {{{1
ino <silent> = =<c-r>=AutoAlign(1)<cr>
let b:autoalign_reqdpat1 = ':='
let b:autoalign_notpat1  = '^\%(\%(:=\)\@!.\)*$'
let b:autoalign_trigger1 = '='
let b:autoalign_cmd1     = "'a,.Align :="
