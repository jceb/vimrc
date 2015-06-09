" Commands:
" ---------

" create tags file in current working directory
command! MakeTags :silent! !ctags -R *

" create a scratch pad buffer
command! -nargs=* Scratch :if bufname('%') != '' | vs | ene | endif | setlocal buftype=nofile <args>

" move/open (with bang!) current buffer to the specified or a new tab
command! -bang -nargs=? Tabmove :let nr=bufnr('%')|if strlen('<bang>') == 0|close|endif|if strlen('args') > 0|tabn <args>|vsplit|else|tabnew|endif|exec ':b '.nr|unlet nr
