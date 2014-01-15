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
	if exists("g:qfix_win")
		cclose
		unlet! g:qfix_win
	else
		copen
	endif
endfunction

" used to track the quickfix window
augroup QFixToggle
	autocmd!
	autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
	autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END

nnoremap <silent> <leader>q :call QFixToggle()<CR>

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
	nnoremap <silent> <buffer> e :call SS()<CR><CR>:call RS()<CR>:call QFixToggle()<CR>
	nnoremap <silent> <buffer> go :call SS()<CR><CR><C-w><C-w>"<CR>:call RS()<CR>
	nnoremap <silent> <buffer> t :call SS()<CR><C-w><CR><C-w>T<CR>:call RS()<CR>
	nnoremap <silent> <buffer> T :call SS()<CR><C-w><CR><C-w>TgT<C-w><C-w>:call RS()<CR>
	if &splitbelow
		nnoremap <silent> <buffer> h :call SS()<CR><C-w><CR><C-w>p<C-w>J<C-w>p:call RS()<CR>
		nnoremap <silent> <buffer> H :call SS()<CR><C-w><CR><C-w>p<C-w>J:call RS()<CR>
	else
		nnoremap <silent> <buffer> h :call SS()<CR><C-w><CR><C-w>K:call RS()<CR>
		nnoremap <silent> <buffer> H :call SS()<CR><C-w><CR><C-w>K<C-w>b:call RS()<CR>
	endif
	if &splitright
		nnoremap <silent> <buffer> v :call SS()<CR><C-w><CR><C-w>L<C-w>p<C-w>J<C-w>p:call RS()<CR>
		nnoremap <silent> <buffer> V :call SS()<CR><C-w><CR><C-w>L<C-w>p<C-w>J:call RS()<CR>
	else
		nnoremap <silent> <buffer> v :call SS()<CR><C-w><CR><C-w>H<C-w>p<C-w>J<C-w>p:call RS()<CR>
		nnoremap <silent> <buffer> V :call SS()<CR><C-w><CR><C-w>H<C-w>p<C-w>J:call RS()<CR>
	endif
	nnoremap <silent> <buffer> q :cclose<CR>
	nnoremap <silent> <buffer> <Esc> :cclose<CR>
endfunction

if g:qf_apply_lmappings && ! exists('g:ag_apply_lmappings')
	augroup qf_toggle
		au BufReadPost quickfix call QFixMappings()
	augroup END
endif
