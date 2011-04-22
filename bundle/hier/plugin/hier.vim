" hier.vim:		Highlight quickfix errors
" Last Modified: Sat 23. Apr 2011 03:00:49 +0900 JST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		1.0
" Description:	Highlight quickfix errors in buffer. This plugin was designed
"               to support the editqf vim script
"               (http://www.vim.org/scripts/script.php?script_id=3557).
"
"               Two commands are provided:
"               	:HierUpdate		" update error highlighting for current buffer
"               	:HierClear		" remove highlighting - it will be when the buffer is revisited or :HierUpdate is called
"
"               The hightlight group can be customized by setting the
"               following variable:
"               	let g:hier_highlight_group = 'ErrorMsg'
" Installation:	Download hier.vim and copy it into your $HOME/.vim/plugin
"               directory.

if (exists("g:loaded_hier") && g:loaded_hier) || &cp
    finish
endif
let g:loaded_hier = 1

if ! exists('g:hier_highlight_group')
	let g:hier_highlight_group = 'ErrorMsg'
endif

function! s:Hier()
	call clearmatches()
	let bufnr = bufnr('%')
	for i in getqflist()
		if i.bufnr == bufnr && i.lnum > 0
			call matchadd(g:hier_highlight_group, '\%'.i.lnum.'l')
		endif
	endfor
endfunction

command! -nargs=0 HierUpdate call s:Hier()
command! -nargs=0 HierClear call clearmatches()

augroup Hier
	au!
	au QuickFixCmdPost,BufEnter,WinEnter * :HierUpdate
augroup END
