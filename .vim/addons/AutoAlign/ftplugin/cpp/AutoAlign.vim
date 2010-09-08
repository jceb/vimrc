" AutoAlign: ftplugin support for C++
" Author:    Charles E. Campbell, Jr.
" Date:      Aug 16, 2007
" Version:   13
" ---------------------------------------------------------------------
let b:loaded_autoalign_cpp= "v13"
let b:undo_ftplugin= "v13"

"  overloading '=' to keep things lined up {{{1
ino <silent> = =<c-r>=AutoAlign(1)<cr>
let b:autoalign_reqdpat1 = '^\(\s*\h\w*\(\[\d\+]\)\{0,}\(->\|\.\)\=\)\+\s*[-+*/^|%]\=='
let b:autoalign_notpat1  = '^[^=]\+$'
let b:autoalign_trigger1 = '='
if !exists("g:mapleader")
 let b:autoalign_cmd1     = 'norm \t=$'
else
 let b:autoalign_cmd1     = "norm ".g:mapleader."t=$"
endif

"  overloading '<<' to keep things lined up {{{1
"ino <silent> < <<c-o>:silent call AutoAlign(-2)<cr>
ino <silent> < <<c-r>=AutoAlign(-2)<cr>
let b:autoalign_reqdpat2 = '<<'
let b:autoalign_notpat2  = '^\%(\%(<<\)\@!.\)*$'
let b:autoalign_trigger2 = '<'
if !exists("g:mapleader")
 let b:autoalign_cmd2     = 'norm \a<$'
else
 let b:autoalign_cmd2     = "norm ".g:mapleader."a<$"
endif

"  overloading '>>' to keep things lined up {{{1
"ino <silent> > ><c-o>:silent call AutoAlign(-3)<cr>
ino <silent> > ><c-r>=AutoAlign(-3)<cr>
let b:autoalign_reqdpat3 = '>>'
let b:autoalign_notpat3  = '^\%(\%(>>\)\@!.\)*$'
let b:autoalign_trigger3 = '>'
if !exists("g:mapleader")
 let b:autoalign_cmd3     = 'norm \a<$'
else
 let b:autoalign_cmd3     = "norm ".g:mapleader."a<$"
endif
