" rfc.vim:		Download specified RFC
" Last Modified: Sun 16. May 2010 17:26:02 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_rfc") && g:loaded_rfc) || &cp
    finish
endif
let g:loaded_rfc = 1

" 'RFC number' open the requested RFC number in a new window
function! <SID>RFC(number)
	if a:number =~ '^[0-9]+$'
		silent exe ":e http://www.ietf.org/rfc/rfc" . a:number . ".txt"
	else
		echoerr "Specified argument is not a number, only numbers are allowed!"
	endif
endfunction

" 'RFC number' open the requested RFC number in a new window
command! -nargs=1 RFC call <SID>RFC(<q-args>)
