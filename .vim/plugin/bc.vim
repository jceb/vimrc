" bc.vim:	Adds support for bc calculator
" Last Modified: Sun 16. May 2010 17:35:14 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_bc") && g:loaded_bc) || &cp
    finish
endif
let g:loaded_bc = 1

" Let 'Bc' compute the given expression with bc command
fun! <SID>Bc(exp)
	let s:bc = ""
	try
		let s:bc = system ('which bc')
	catch
	endtry
	if s:bc == ""
		echoerr "Unable to locate bc command"
		return
	endif
	let s:paste = &paste
	setlocal paste
	normal mao
	exe ":.!echo 'scale=2; " . a:exp . "' | ".s:bc
	normal 0i"bDdd`i"bp
	if s:paste == 1
		setlocal paste
	else
		setlocal nopaste
	endif
	unlet s:paste
	unlet s:bc
endfun

command! -nargs=1 Bc call <SID>Bc(<q-args>)
