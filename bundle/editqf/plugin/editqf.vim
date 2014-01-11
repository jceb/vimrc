" editqf.vim -- make quickfix entries editable
" Author:         Jan Christoph Ebersbach (jceb@e-jc.de)
" Copyright:      2011, 2012, 2013, Jan Christoph Ebersbach
" License:        GPL (see http://www.gnu.org/licenses/gpl.txt)
" Created:        2008-11-28
" Revision:       1.5
" vi:             ft=vim:tw=80:sw=4:ts=8

if exists("g:loaded_editqf") || &cp
    finish
endif
let g:loaded_editqf = 1

let g:editqf_saveqf_filename         = !exists("g:editqf_saveqf_filename")         ? "quickfix.list" : g:editqf_saveqf_filename
let g:editqf_saveloc_filename        = !exists("g:editqf_saveloc_filename")        ? "location.list" : g:editqf_saveloc_filename
let g:editqf_jump_to_error           = !exists("g:editqf_jump_to_error")           ? 1               : g:editqf_jump_to_error
let g:editqf_store_absolute_filename = !exists("g:editqf_store_absolute_filename") ? 1               : g:editqf_store_absolute_filename

command! -nargs=* -bang QFAddNote              :call editqf#AddNote("<bang>", "qf", 'l', <f-args>)
command! -nargs=* -bang QFAddNotePattern       :call editqf#AddNote("<bang>", "qf", 'p', <f-args>)
command! -nargs=? -bang -complete=file QFSave  :call editqf#Save("<bang>", "qf", <f-args>)
command! -nargs=? -bang -complete=file QFLoad  :call editqf#Load("<bang>", "qf", <f-args>)

command! -nargs=* -bang LocAddNote             :call editqf#AddNote("<bang>", "loc", 'l', <f-args>)
command! -nargs=* -bang LocAddNotePattern      :call editqf#AddNote("<bang>", "loc", 'p', <f-args>)
command! -nargs=? -bang -complete=file LocSave :call editqf#Save("<bang>", "loc", <f-args>)
command! -nargs=? -bang -complete=file LocLoad :call editqf#Load("<bang>", "loc", <f-args>)

nnoremap <Plug>QFAddNote         :QFAddNote<CR>
nnoremap <Plug>QFAddPatternNote  :QFAddNotePattern<CR>
nnoremap <Plug>LocAddNote        :LocAddNote<CR>
nnoremap <Plug>LocAddPatternNote :LocAddNotePattern<CR>

if !exists("g:editqf_no_mappings") || !g:editqf_no_mappings
	if !hasmapto("<Plug>QFAddNote", "n")
		nmap <leader>n <Plug>QFAddNote
	endif

	if !hasmapto("<Plug>QFAddPatternNote", "n")
		nmap <leader>N <Plug>QFAddPatternNote
	endif
endif

nnoremap <Plug>QFEdit         :<C-u>if !exists('s:current_bufnr')<Bar>call editqf#Edit()<Bar>endif<CR>
nnoremap <Plug>QFPreviousType :<C-u>call editqf#ChangeType(-1)<CR>
nnoremap <Plug>QFNextType     :<C-u>call editqf#ChangeType(+1)<CR>

augroup qf
	au!
	au BufReadCmd qf:list call editqf#Read(expand("<amatch>"))
	au BufReadCmd loc:list call editqf#Read(expand("<amatch>"))
	for i in ["I", "W", "E"]
		exec "au BufReadPost quickfix nnoremap <silent> <buffer> ".i." :call editqf#ChangeType('".i."')<CR>"
	endfor
	au BufReadPost quickfix nmap <silent> <buffer> << <Plug>QFPreviousType
	au BufReadPost quickfix nmap <silent> <buffer> >> <Plug>QFNextType

	for i in ["i", "a", "c", "o", "p", "r", "s", "d", "x", "A", "C", "O", "P", "R", "S", "D", "X"]
		exec "au BufReadPost quickfix nmap <silent> <buffer> ".i." <Plug>QFEdit"
	endfor
augroup END
