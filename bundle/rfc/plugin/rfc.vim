" rfc.vim:		Download specified RFC
" Last Modified: Mon 18. Apr 2011 21:17:58 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_rfc") && g:loaded_rfc) || &cp
    finish
endif
let g:loaded_rfc = 1

" 'RFC number' open the requested RFC number in a new window
function! <SID>RFC(number)
	if a:number =~ '^[0-9]\+$'
		silent exe ":vs http://www.ietf.org/rfc/rfc" . a:number . ".txt"
		setfiletype rfc
	else
		echomsg "Specified argument is not a number, only numbers are allowed!"
	endif
endfunction

" 'RFC number' open the requested RFC number in a new window
command! -nargs=1 RFC :call <SID>RFC(<q-args>)
command! -nargs=1 Rfc :call <SID>RFC(<q-args>)
