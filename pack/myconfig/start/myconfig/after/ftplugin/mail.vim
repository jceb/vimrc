" mail.vim -- mail address completion
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2006-12-24
" @Last Modified: Tue 31. Aug 2010 21:31:31 +0200 CEST
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=8
" 
" @Description  : completes emailaddresses
" @Usage        : you need to define g:emailQueryProg that takes the query
"                 string and returns a list of emailaddresses - one per line
" @TODO         :
" @CHANGES      :

if &cp || exists("b:loaded_mail_after")
    finish
endif
let b:loaded_mail_after = 1


" attach files from within mutt
function! <SID>AppendFiles(...)
    if has('nvim')
        tabclose
    endif
    let l:attachments = []
    for fn in readfile(s:files)
        call add(l:attachments, 'Attach: '.escape(fn, " \t\\"))
    endfor
    if len(l:attachments) > 0
        normal! gg}
        call append(line('.')-1, l:attachments)
        redraw!
    endif
    call delete(s:files)
endfunction

function! <SID>AttachFile(...)
    let s:files = tempname()
    if has('nvim')
        tabe
        call termopen('ranger --choosefiles='.s:files, {'on_exit': function('<SID>AppendFiles')})
        startinsert
    else
        silent exec '!ranger --choosefiles='.s:files
        call s:AppendFiles()
    endif
endfun

command! -buffer -nargs=* -complete=file Attach :call <SID>AttachFile(<f-args>)

" nnoremap <localleader>t :<C-u>keeppatterns /^To:<CR>:startinsert!<CR>
" nnoremap <localleader>s :<C-u>keeppatterns /^Subject:<CR>:startinsert!<CR>
" nnoremap <localleader>c :<C-u>keeppatterns /^Cc:<CR>:startinsert!<CR>


if !exists('g:emailAddrQueryProg')
    finish
endif

function! CompleteMailAddresses(findstart, base)
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
endfunction

set completefunc=CompleteMailAddresses
set omnifunc=CompleteMailAddresses
