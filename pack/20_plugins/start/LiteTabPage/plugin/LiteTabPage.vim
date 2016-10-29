"
" Name: LiteTabPage, VIM plugin for GVIM 7.0 or above
" Author: AyuanX ( ayuanx (at) gmail (dot) com )
" Version: 1.2
"
" Description:
"
" This is an (extremely) simple plugin, which makes VIM Tab Page functions more user-friendly. 
"
" <> Features:
" 1. ":E filename"			Open the file in a new tab page instead of in current window.
"
" 2. "<ALt-1>, <Alt-2> to <Alt-0>"	Switch to tab page 1/2/3/4/5/6/7/8/9/10.
"
" 3. "<Alt-h> / <Alt-l>"		Switch to previous/next tab page.
"
" 4. "<Alt-H> / <Alt-L>"		Move current tab page left/right.
"
" 5. Show GUI Tab Labels in format: "[Tab Number]:[+][Buffer Name]"
" 	PS: [+] stands for one or more buffer in that tab page has been modified.
"
" <> How to Install:
"    Simply put "LiteTabPage.vim" into path "~/.vim/plugin/" (unix) or "$VIM/vimfiles/plugin/" (windows).
"
" <> Feedback:
"    You are always encouraged to modify this plugin freely to suit your own needs!
"

if exists('loaded_litetabpage')
  finish
endif

let loaded_litetabpage = 1

set winaltkeys=no

com! -nargs=* -complete=file E tabnew <args>

nnoremap <unique> <A-1> 1gt
nnoremap <unique> <A-2> 2gt
nnoremap <unique> <A-3> 3gt
nnoremap <unique> <A-4> 4gt
nnoremap <unique> <A-5> 5gt
nnoremap <unique> <A-6> 6gt
nnoremap <unique> <A-7> 7gt
nnoremap <unique> <A-8> 8gt
nnoremap <unique> <A-9> 9gt
nnoremap <unique> <A-0> 10gt

nnoremap <unique> <A-h> gT
nnoremap <unique> <A-l> gt
nnoremap <silent> <A-H> :call <SID>LiteTabMove(-2)<CR>
nnoremap <silent> <A-L> :call <SID>LiteTabMove(0)<CR>

function! s:LiteTabMove(idx)
	let index = tabpagenr() + a:idx
	if (index < 0)
		return
	endif
    silent execute 'tabmove ' . index
endfunction

function! LiteTabLabel()
	let label = tabpagenr().':'
	let bufnrlist = tabpagebuflist(v:lnum)

	" Add '+' if one of the buffers in the tab page is modified
	for bufnr in bufnrlist
		if getbufvar(bufnr, "&modified")
			let label .= '+ '
			break
		endif
	endfor

	" Append the buffer name
	return label . fnamemodify(bufname(bufnrlist[tabpagewinnr(v:lnum)-1]), ":t")
endfunction

set guitablabel=%{LiteTabLabel()}

