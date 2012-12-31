" Commands:
" ---------

" spellcheck off, german, englisch
command! -nargs=1 Spell :setlocal spell spelllang=<args>
command! -nargs=0 Nospell :setlocal nospell

" create tags file in current working directory
command! MakeTags :silent !ctags -R *

" set the textwidth and update the printmarign highlighting in one step
command! -nargs=1 Tw set tw=<args> | call HighlightPrintmargin()

" Make current file executeable
command! -nargs=0 Chmodx :silent !chmod +x %

" disable diff mode and disable line wrapping
command! -bang -nargs=0 Diffoff :diffoff<bang> | set nowrap

" create a scratch pad buffer
command! -nargs=* Scratch :if bufname('%') != "" | vs | ene | endif | setlocal buftype=nofile <args>

" shortcut for changing languages
command! -nargs=0 DE :language de_DE.utf-8
command! -nargs=0 EN :language en_US.utf-8
