" hier.vim:		Highlight quickfix errors
" Last Modified: Tue 26. Apr 2011 15:53:25 +0900 JST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		1.1

if (exists("g:loaded_hier") && g:loaded_hier) || &cp
    finish
endif
let g:loaded_hier = 1

if ! exists('g:hier_highlight_group_qf')
	let g:hier_highlight_group_qf = 'ErrorMsg'
endif

if ! exists('g:hier_highlight_group_loc')
	let g:hier_highlight_group_loc = 'Search'
endif

if ! exists('g:hier_enabled')
	let g:hier_enabled = 1
endif

function! s:Hier()
	if g:hier_enabled == 0
		return
	endif

	call clearmatches()
	let bufnr = bufnr('%')

	if g:hier_highlight_group_qf != ""
		for i in getqflist()
			if i.bufnr == bufnr
				if i.lnum > 0
					call matchadd(g:hier_highlight_group_qf, '\%'.i.lnum.'l')
				elseif i.pattern != ''
					call matchadd(g:hier_highlight_group_qf, i.pattern)
				endif
			endif
		endfor
	endif
	if g:hier_highlight_group_loc != ""
		for i in getloclist(0)
			if i.bufnr == bufnr
				if i.lnum > 0
					call matchadd(g:hier_highlight_group_loc, '\%'.i.lnum.'l')
				elseif i.pattern != ''
					call matchadd(g:hier_highlight_group_loc, i.pattern)
				endif
			endif
		endfor
	endif
endfunction

command! -nargs=0 HierUpdate call s:Hier()
command! -nargs=0 HierClear call clearmatches()

command! -nargs=0 HierStart let g:hier_enabled = 1 | HierUpdate
command! -nargs=0 HierStop let g:hier_enabled = 0 | HierClear

augroup Hier
	au!
	au QuickFixCmdPost,BufEnter,WinEnter * :HierUpdate
augroup END
