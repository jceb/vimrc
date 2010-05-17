" cd.vim:		Commands for dealing with directory changes
" Last Modified: Sun 16. May 2010 17:33:19 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_cd") && g:loaded_cd) || &cp
    finish
endif
let g:loaded_cd = 1

" Get root directory of the debian package you are currently in
function! GetDebianPackageRoot()
	let sd = getcwd()
	let owd = sd
	let cwd = owd
	let dest = sd
	while !isdirectory('debian')
		lcd ..
		let owd = cwd
		let cwd = getcwd()
		if cwd == owd
			break
		endif
	endwhile
	if cwd != sd && isdirectory('debian')
		let dest = cwd
	endif
	return dest
endfunction

" change to directory of the current buffer
command! Lcd :lcd %:p:h
command! Cd :cd %:p:h
command! CD :Cd
command! LCD :Lcd

" chdir to directory with subdirector ./debian (very useful if you do
" Debian development)
command! Cddeb :exec "lcd ".GetDebianPackageRoot()

" add directories to the path variable which eases the use of gf and
" other commands operating on the path
command! PathAdddeb :exec "set path+=".GetDebianPackageRoot()
command! PathSubdeb :exec "set path-=".GetDebianPackageRoot()
command! PathAdd :exec "set path+=".expand("%:p:h")
command! PathSub :exec "set path-=".expand("%:p:h")
