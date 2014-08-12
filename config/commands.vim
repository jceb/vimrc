" Commands:
" ---------

" create tags file in current working directory
command! MakeTags :silent! !ctags -R *

" set the textwidth and update the printmarign highlighting in one step
command! -nargs=1 Tw set tw=<args> | call HighlightPrintmargin()

" create a scratch pad buffer
command! -nargs=* Scratch :if bufname('%') != '' | vs | ene | endif | setlocal buftype=nofile <args>

" move/open (with bang!) current buffer to the specified or a new tab
command! -bang -nargs=? Tabbuf :let nr=bufnr('%')|if strlen('<bang>') == 0|close|endif|if strlen('args') > 0|tabn <args>|vsplit|else|tabnew|endif|exec ':b '.nr|unlet nr

" minimalistic tmux integration - run a command in a split window
command! -nargs=+ -complete=shellcmd T :silent! !tmux split-window -d -h <q-args>
