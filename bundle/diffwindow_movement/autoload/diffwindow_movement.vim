" diffwindow_movement.vim: Movement over changes in a diff window. 
"
" DEPENDENCIES:
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   01.00.001	30-Aug-2011	file creation

function! diffwindow_movement#GetDiffType( lnum )
    let l:syntaxName = synIDattr(diff_hlID(a:lnum, 1), 'name')
    if l:syntaxName ==# 'DiffText'
	" Changed text within a changed line is the same as changed line. 
	let l:syntaxName = 'DiffChange'
    endif

    return l:syntaxName
endfunction

function! diffwindow_movement#IsDiffLine( lnum )
    return (diff_hlID(a:lnum, 1) == 0 ? -1 : 0)
endfunction

function! diffwindow_movement#IsDifferenceLine( lnum )
    if empty(g:CountJump_Context)
	let l:diffType = diffwindow_movement#GetDiffType(a:lnum)
	if empty(l:diffType)
	    return -1
	endif
	let g:CountJump_Context.DiffType = l:diffType
    endif
    return (diffwindow_movement#GetDiffType(a:lnum) ==# g:CountJump_Context.DiffType ? 0 : -1)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
