" formatmail.vim -- reformat e-mail before editing
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2010-08-31
" @Last Modified: Tue 31. Aug 2010 21:40:03 +0200 CEST
" @Revision     : 0.1
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  : reformat e-mail before editing
" @Usage        : add something like this to your .vimrc
"                 au FileType mail			call formatmail#FormatMail()
" @TODO         :
" @CHANGES      :

" Reformat e-mail
function! formatmail#FormatMail()
    " unset formatoptions to avoid interference with this function
    let old_fo = &fo
    set fo=
    " workaround for the annoying mutt send-hook behavoir
    silent! 1,/^$/s/\v^X-(To|Cc|Bcc):( .*)/\1: \2/
    silent! /^Bcc:\s?$/d
    " silent! 1,/^$/g/^X-To: .*/exec 'normal! gg'|exec '/^To: /,/^Cc: /-1d'|1,/^$/s/^X-To: /To: /|exec 'normal! dd'|exec '?Cc'|normal! P
    " silent! 1,/^$/g/^X-Cc: .*/exec 'normal! gg'|exec '/^Cc: /,/^Bcc: /-1d'|1,/^$/s/^X-Cc: /Cc: /|exec 'normal! dd'|exec '?Bcc'|normal! P
    " silent! 1,/^$/g/^X-Bcc: .*/exec 'normal! gg'|exec '/^Bcc: /,/^Subject: /-1d'|1,/^$/s/^X-Bcc: /Bcc: /|exec 'normal! dd'|exec '?Subject'|normal! P

    " delete signature
    silent! /^> --[\t ]*$/,/^-- $/-2d
    " fix quotation
    silent! /\v^(On|In) .*$/,/^-- $/-1:s/>>/> >/g
    silent! /\v^(On|In) .*$/,/^-- $/-1:s/>\([^\ \t]\)/> \1/g
    " format text
    " convert bad formated umlauts to real characters
    silent! %s/\v\\([0-9]*)/\=nr2char(submatch(1))/g
    silent! %s/\v&#([0-9]*);/\=nr2char(submatch(1))/g
    " break undo sequence
    normal! iu
    if 0
        1
        " exec 'silent! /\(^\(On\|In\) .*$\|\(schrieb\|wrote\):$\)/,/^-- $/-1!par '.&tw.'gqs0'
        silent! /\v(^(On|In) .*$|(schrieb|wrote):$)/,/^-- $/-1y|let &fo = old_fo|exec "normal! '[V']gq"|set fo=
    endif
    " delete inner and trailing spaces
    silent! 1,/^$/s/\v^(To|Cc|Bcc|Subject):$/\1: /
    1
    silent! /^$/,$s/\v([^\xa0\x0d\t ])[\xa0\x0d\t ]+([^\xa0\x0d\t ])/\1 \2/g
    1
    silent! /^$/,/-- /-1s/\v[\xa0\x0d\t ]+$//

    " place the cursor at the beginning of the mail
    " normal! gg}j
    " if getline('.') != ''
    "     normal! k
    " endif
    normal! /^To:/$

    " clear search buffer
    let @/ = ""
    let &fo = old_fo
    unlet old_fo
endfunction
