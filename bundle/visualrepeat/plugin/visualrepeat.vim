" visualrepeat.vim: Repeat command extended to visual mode. 
"
" DEPENDENCIES:
"   - visualrepeat.vim autoload script. 
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.00.002	13-Dec-2011	Prepared for publish. 
"	001	18-Mar-2011	file creation from ingomappings.vim. 

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_visualrepeat') || (v:version < 700)
    finish
endif
let g:loaded_visualrepeat = 1

xnoremap <silent> . :<C-U>call visualrepeat#repeat()<CR>

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
