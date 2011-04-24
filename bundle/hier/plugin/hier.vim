" hier.vim:		Highlight quickfix errors
" Last Modified: Sat 23. Apr 2011 22:02:47 +0900 JST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		1.1
" Description:
" Highlight quickfix errors and location list entries in buffer. This plugin
" was designed to support the editqf vim script
" (http://www.vim.org/scripts/script.php?script_id=3557).
"
" The following commands are provided:
" 	:HierStart		" enable hier highlighting
" 	:HierStop		" disable hier highlighting
" 	:HierUpdate		" update error highlighting for current buffer
" 	:HierClear		" remove highlighting - it will be when the buffer is revisited or :HierUpdate is called
"
" The hightlight group can be customized by setting the following variable.
" Setting a variable to the empty string "" will disable highlighting of that
" group:
" 	let g:hier_highlight_group_qf  = 'ErrorMsg'
" 	let g:hier_highlight_group_loc = 'Search'
"
" 	let g:hier_enabled             = 1
"
" Installation:
" Download hier.vim and copy it into your $HOME/.vim/plugin directory.
"
" History:
" 1.1
" - add commands :HierStart and :HierStop
" - add support for highlighting location list entries
" - add support for highlighting pattern entries
"
" 1.0
" - inital release

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
