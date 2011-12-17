" visualrepeat.vim: Repeat command extended to visual mode. 
"
" DEPENDENCIES:
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.00.006	12-Dec-2011	Catch any errors from the :normal . repetitions
"				instead of causing function errors. Also use
"				exceptions for the internal error signaling. 
"	005	06-Dec-2011	Retire visualrepeat#set_also(); it's the same as
"				visualrepeat#set() since we've dropped the
"				forced increment of b:changedtick. 
"	004	22-Oct-2011	BUG: Must initialize g:visualrepeat_tick on load
"				to avoid "Undefined variable" error in autocmds
"				on BufWrite. It can happen that this autoload
"				script is loaded without having a repetition
"				registered at the same time. 
"	003	21-Oct-2011	Also apply the same-register repeat enhancement
"				to repeat.vim here. 
"	002	17-Oct-2011	Increment b:changedtick without clobbering the
"				expression register. 
"				Must also adapt g:visualrepeat_tick on buffer
"				save to allow repetition after a save and buffer
"				switch (without relying on g:repeat_sequence
"				being identical to g:visualrepeat_sequence,
"				which has formerly often saved us). 
"				Omit own increment of b:changedtick, let the
"				mapping do that (or not, in case of a
"				non-modifying mapping). It seems to work without
"				it, and avoids setting the 'modified' flag on
"				unmodified buffers, which is not expected. 
"	001	17-Mar-2011	file creation

let g:visualrepeat_tick = -1

function! visualrepeat#set( sequence, ... )
    let g:visualrepeat_sequence = a:sequence
    let g:visualrepeat_count = a:0 ? a:1 : v:count
    let g:visualrepeat_tick = b:changedtick
endfunction


function! s:ErrorMsg( text )
    let v:errmsg = a:text
    echohl ErrorMsg
    echomsg v:errmsg
    echohl None

    if &cmdheight == 1
	" In visual mode, the mode message will override the error message. 
	sleep 500m
    endif
    normal! gv
endfunction
function! visualrepeat#repeat()
    if g:visualrepeat_tick == b:changedtick
	" visualrepeat.vim should handle the repeat. 
	let l:repeat_sequence = g:visualrepeat_sequence
	let l:repeat_count = g:visualrepeat_count
    elseif exists('g:repeat_tick') && g:repeat_tick == b:changedtick
	" repeat.vim is enabled and would handle a normal-mode repeat. 
	let l:repeat_sequence = g:repeat_sequence
	let l:repeat_count = g:repeat_count
    endif

    if exists('l:repeat_sequence')
	" A mapping for visualrepeat.vim or repeat.vim to repeat has been set. 
	" Ensure that a corresponding visual mode mapping exists; some plugins
	" that only use repeat.vim may not have this. 
	if ! empty(maparg(substitute(l:repeat_sequence, '^.\{3}', '<Plug>', 'g'), 'v'))
	    " Handle mappings that use a register and want the same register
	    " used on repetition. 
	    let l:reg = ''
	    if g:repeat_reg[0] ==# g:repeat_sequence && ! empty(g:repeat_reg[1])
		if g:repeat_reg[1] ==# '='
		    " This causes a re-evaluation of the expression on repeat, which
		    " is what we want.
		    let l:reg = '"=' . getreg('=', 1) . "\<CR>"
		else
		    let l:reg = '"' . g:repeat_reg[1]
		endif
	    endif

	    " The normal mode mapping to be repeated has a corresponding visual
	    " mode mapping. Use this so that the repetition will affect the
	    " current selection. With this we also avoid the clumsy application
	    " of the normal mode command to the visual selection, and can
	    " support blockwise visual mode. 
	    let l:cnt = l:repeat_count == -1 ? '' : (v:count ? v:count : (l:repeat_count ? l:repeat_count : ''))

	    call feedkeys('gv' . l:reg . l:cnt, 'n')
	    call feedkeys(l:repeat_sequence)
	    return
	endif
    endif

    " Note: :normal has no bang to allow a remapped '.' command here to enable
    " repeat.vim functionality. 

    try
	if visualmode() ==# 'v'
	    " Repeat the last change starting from the current cursor position. 
	    normal .
	elseif visualmode() ==# 'V'
	    " For all selected lines, repeat the last change in the line; the cursor
	    " is set to the first column. 
	    '<,'>normal .
	else
	    throw 'visualrepeat: Cannot repeat in this visual mode!'
	endif
    catch /^Vim\%((\a\+)\)\=:E/
	" v:exception contains what is normally in v:errmsg, but with extra
	" exception source info prepended, which we cut away. 
	call s:ErrorMsg(substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', ''))
    catch /^visualrepeat:/
	call s:ErrorMsg(substitute(v:exception, '^visualrepeat:\s*', '', ''))
    endtry
endfunction

augroup visualrepeatPlugin
    autocmd!
    autocmd BufLeave,BufWritePre,BufReadPre * let g:visualrepeat_tick = (g:visualrepeat_tick == b:changedtick || g:visualrepeat_tick == 0) ? 0 : -1
    autocmd BufEnter,BufWritePost * if g:visualrepeat_tick == 0|let g:visualrepeat_tick = b:changedtick|endif
augroup END

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
