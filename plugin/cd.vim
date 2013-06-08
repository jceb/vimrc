" cd.vim:		Commands for dealing with directory changes
" Last Modified: Sun 20. Jun 2010 20:29:46 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1
" License:		VIM LICENSE, see :h license

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
command! PathAdd :exec "set path+=".expand("%:p:h")
command! PathRem :exec "set path-=".expand("%:p:h")
command! PathAdddeb :exec "set path+=".GetDebianPackageRoot()
command! PathRemdeb :exec "set path-=".GetDebianPackageRoot()
