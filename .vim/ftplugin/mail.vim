" mail.vim -- mail address completion
" @Author       : Jan Christoph Ebersbach (jceb@tzi.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2006-12-24
" @Last Modified: Thu 15. Mar 2007 21:58:37 +0100 CET
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
