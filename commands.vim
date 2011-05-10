" Commands:
" ---------

" edit/reload .vimrc-Configuration
command! ConfigEdit :e $MYVIMRC
command! ConfigEditPersonal :e $HOME/.vim/personal.vim
command! ConfigVerticalSplit :vs $MYVIMRC
command! ConfigSplit :sp $MYVIMRC
command! ConfigReload :source $MYVIMRC|echo "Configuration reloaded"

" spellcheck off, german, englisch
command! -nargs=1 Spell :setlocal spell spelllang=<args>
command! -nargs=0 Nospell :setlocal nospell

" delete buffer while keeping the window structure
command! Bk :enew<CR>bw #<CR>bn<CR>bw #

" create tags file in current working directory
command! MakeTags :silent !ctags -R *

" set the textwidth and update the printmarign highlighting in one step
command! -nargs=1 Tw set tw=<args> | call HighlightPrintmargin()

" Make current file executeable
command! -nargs=0 Chmodx :silent !chmod +x %

command! -nargs=0 Diffoff :diffoff | set nowrap
