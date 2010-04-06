" mail.vim -- mail address completion
" @Author       : Jan Christoph Ebersbach (jceb@tzi.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2006-12-24
" @Last Modified: Mon 05. Apr 2010 19:50:50 +0200 CEST
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=8
" 
" @Description  : completes emailaddresses
" @Usage        : you need to define g:emailQueryProg that takes the query
"                 string and returns a list of emailaddresses - one per line
" @TODO         :
" @CHANGES      :

if &cp || exists("b:loaded_mail")
    finish
endif
let b:loaded_mail = 1

if !exists('g:emailAddrQueryProg')
    finish
endif

fun! CompleteMailAddresses(findstart, base)
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '[^[:punct:] \t]'
            let start -= 1
        endwhile
        return start
    else
        " find email addresses matching with "a:base"
        return split(system(g:emailAddrQueryProg . a:base), "\n")
    endif
endfun

set omnifunc=CompleteMailAddresses

" Reformat e-mail
function! FormatMail()
	" unset formatoptions to avoid interference with this function
	let old_fo = &fo
	set fo=
	" workaround for the annoying mutt send-hook behavoir
	silent! 1,/^$/g/^X-To: .*/exec 'normal gg'|exec '/^To: /,/^Cc: /-1d'|1,/^$/s/^X-To: /To: /|exec 'normal dd'|exec '?Cc'|normal P
	silent! 1,/^$/g/^X-Cc: .*/exec 'normal gg'|exec '/^Cc: /,/^Bcc: /-1d'|1,/^$/s/^X-Cc: /Cc: /|exec 'normal dd'|exec '?Bcc'|normal P
	silent! 1,/^$/g/^X-Bcc: .*/exec 'normal gg'|exec '/^Bcc: /,/^Subject: /-1d'|1,/^$/s/^X-Bcc: /Bcc: /|exec 'normal dd'|exec '?Subject'|normal P

	" delete signature
	silent! /^> --[\t ]*$/,/^-- $/-2d
	" fix quotation
	silent! /^\(On\|In\) .*$/,/^-- $/-1:s/>>/> >/g
	silent! /^\(On\|In\) .*$/,/^-- $/-1:s/>\([^\ \t]\)/> \1/g
	" delete inner and trailing spaces
	normal :%s/[\xa0\x0d\t ]\+$//g
	normal :%s/\([^\xa0\x0d\t ]\)[\xa0\x0d\t ]\+\([^\xa0\x0d\t ]\)/\1 \2/g
	" format text
	normal gg
	" convert bad formated umlauts to real characters
	normal :%s/\\\([0-9]*\)/\=nr2char(submatch(1))/g
	normal :%s/&#\([0-9]*\);/\=nr2char(submatch(1))/g
	" break undo sequence
	normal iu
	exec 'silent! /\(^\(On\|In\) .*$\|\(schrieb\|wrote\):$\)/,/^-- $/-1!par '.&tw.'gqs0'
	" place the cursor before my signature
	silent! /^-- $/-1
	" clear search buffer
	let @/ = ""
	exe 'set fo='.old_fo
	unlet old_fo
endfunction
