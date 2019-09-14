" qf_toggle:	toggles quickfix window and creats 
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.2
" License:		VIM LICENSE, see :h license

if (exists("g:loaded_qf_toogle") && g:loaded_qf_toogle) || &cp
    finish
endif
let g:loaded_qf_toogle = 1

" inspired by https://github.com/rking/ag.vim/blob/master/autoload/ag.vim
let g:qf_apply_lmappings = exists('g:qf_apply_lmappings') ? g:qf_apply_lmappings : 1

" toggles the quickfix window.
" http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
"command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle()
	if exists("t:qfix_win")
		cclose
		unlet! t:qfix_win
	else
		copen
	endif
endfunction

" toggles the quickfix window.
" http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
"command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! LocationToggle()
	if exists("t:qfix_win")
        lclose
		unlet! t:qfix_win
	else
        lopen
	endif
endfunction

" used to track the quickfix window
augroup QFixToggle
	autocmd!
	autocmd BufWinEnter quickfix let t:qfix_win = bufnr("$")
	" autocmd BufWinLeave * if exists("t:qfix_win") && expand("<abuf>") == t:qfix_win | unlet! t:qfix_win | endif
augroup END

nnoremap <silent> <leader>q :<C-u>call QFixToggle()<CR>
nnoremap <silent> <leader>l :<C-u>call LocationToggle()<CR>

function! SS()
	let s:qf_toggle_switchbuf = &switchbuf
	let &switchbuf = ''
endfunction

function! RS()
	if exists('s:qf_toggle_switchbuf')
		let &switchbuf = s:qf_toggle_switchbuf
		unlet s:qf_toggle_switchbuf
	endif
endfunction

function! QFixMappings()
	nnoremap <silent> <buffer> e :<C-u>call SS()<CR><CR>:call RS()<CR>:call QFixToggle()<CR>
	nnoremap <silent> <buffer> go :<C-u>call SS()<CR><CR><C-w><C-w>"<CR>:call RS()<CR>
	nnoremap <silent> <buffer> t :<C-u>call SS()<CR><C-w><CR><C-w>T<CR>:call RS()<CR>
	nnoremap <silent> <buffer> T :<C-u>call SS()<CR><C-w><CR><C-w>TgT<C-w><C-w>:call RS()<CR>
	if &splitbelow
		nnoremap <silent> <buffer> h :<C-u>call SS()<CR><C-w><CR><C-w>p<C-w>J<C-w>p:call RS()<CR>
		nnoremap <silent> <buffer> H :<C-u>call SS()<CR><C-w><CR><C-w>p<C-w>J:call RS()<CR>
		nnoremap <silent> <buffer> s :<C-u>call SS()<CR><C-w><CR><C-w>p<C-w>J<C-w>p:call RS()<CR>
		nnoremap <silent> <buffer> S :<C-u>call SS()<CR><C-w><CR><C-w>p<C-w>J:call RS()<CR>
	else
		nnoremap <silent> <buffer> h :<C-u>call SS()<CR><C-w><CR><C-w>K:call RS()<CR>
		nnoremap <silent> <buffer> H :<C-u>call SS()<CR><C-w><CR><C-w>K<C-w>b:call RS()<CR>
		nnoremap <silent> <buffer> s :<C-u>call SS()<CR><C-w><CR><C-w>K:call RS()<CR>
		nnoremap <silent> <buffer> S :<C-u>call SS()<CR><C-w><CR><C-w>K<C-w>b:call RS()<CR>
	endif
	if &splitright
		nnoremap <silent> <buffer> v :<C-u>call SS()<CR><C-w><CR><C-w>L<C-w>p<C-w>J<C-w>p:call RS()<CR>
		nnoremap <silent> <buffer> V :<C-u>call SS()<CR><C-w><CR><C-w>L<C-w>p<C-w>J:call RS()<CR>
	else
		nnoremap <silent> <buffer> v :<C-u>call SS()<CR><C-w><CR><C-w>H<C-w>p<C-w>J<C-w>p:call RS()<CR>
		nnoremap <silent> <buffer> V :<C-u>call SS()<CR><C-w><CR><C-w>H<C-w>p<C-w>J:call RS()<CR>
	endif
	nnoremap <silent> <buffer> q :<C-u>cclose<CR>
	nnoremap <silent> <buffer> <Esc> :<C-u>cclose<CR>
endfunction

if g:qf_apply_lmappings && ! exists('g:ag_apply_lmappings')
	augroup qf_toggle
		au BufReadPost quickfix call QFixMappings()
	augroup END
endif
