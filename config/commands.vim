" Commands:
" ---------

" Integration with other editors
function s:OpenEditor(editor, file)
    if a:file == ""
        return
    endif
    if has('nvim')
        " not yet perfect
        call termopen(a:editor . " ". shellescape(a:file))
        startinsert
    else
        exec "!" . a:editor . " ". shellescape(a:file)
        redraw!
    endif
endfunction

command! Kak :call s:OpenEditor("kak", expand("%:p"))
command! Vis :call s:OpenEditor("vis", expand("%:p"))

if has('nvim')
    command! Vim :call s:OpenEditor("vim", expand("%:p"))
else
    command! Nvim :call s:OpenEditor("nvim", expand("%:p"))
endif

" create tags file in current working directory
command! MakeTags :silent! !ctags -R *

" create a scratch pad buffer
command! -nargs=* Scratch :if bufname('%') != '' | vs | ene | endif | setlocal buftype=nofile <args>

" move/open (with bang!) current buffer to the specified or a new tab
command! -bang -nargs=? Tabmove :let nr=bufnr('%')|if strlen('<bang>') == 0|close|endif|if strlen('args') > 0|tabn <args>|vsplit|else|tabnew|endif|exec ':b '.nr|unlet nr
