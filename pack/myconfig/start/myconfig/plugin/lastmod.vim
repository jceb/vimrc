" lastmod.vim:	Update lines containing string Last Modified with the
" date of the last modification
" Last Modified: Mon 18. Apr 2011 21:07:18 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1
" License:		VIM LICENSE, see :h license
" Usage:		With the variables g:lastmod and b:lastmod the update of last
" modified lines can be omitted
"
" Add the following to your vimrc to update the Last Modified tag on every
" write action.
"augroup lastmod
"	autocmd!
"	" replace "Last Modified: with the current time"
"	au BufWritePre,FileWritePre *	if (exists('g:lastmod') && g:lastmod == 1) || (exists('b:lastmod') && b:lastmod == 1) | call <SID>LastMod() | endif
"augroup END

if (exists("g:loaded_lastmod") && g:loaded_lastmod) || &cp
    finish
endif
let g:loaded_lastmod = 1

if ! exists('g:lastmod')
	" set g:lastmod or b:lastmod to 0 or 1 to dis-/enable updating of
	" last modified lines
	let g:lastmod = 1
endif

" Update line starting with "Last Modified:"
fun! <SID>LastMod()
	let line = line(".")
	let column = col(".")
	let search = @/

	" replace Last Modified in the first 20 lines
	if line("$") > 10
		let l = 10
	else
		let l = line("$")
	endif
	" replace only if the buffer was modified
	"if &mod == 1
	silent exe "1," . l . "g/Last Modified:/s/Last Modified:.*/Last Modified: " . strftime("%a %d. %b %Y %T %z %Z") . "/"
	"endif
	let @/ = search

	" set cursor to last position before substitution
	call cursor(line, column)
endfun

command! -nargs=0 UpdateLastModified :call <SID>LastMod()
