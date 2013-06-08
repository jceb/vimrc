" sh.vim:		Commands for opening terminal for the currently edited file or
" directory
" Last Modified: Sun 16. May 2010 17:37:14 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1
" License:		VIM LICENSE, see :h license

if (exists("g:loaded_sh") && g:loaded_sh) || &cp
    finish
endif
let g:loaded_sh = 1

" spawn terminal in current working directory
command! Sh :silent !setsid x-terminal-emulator

" spawn terminal in the directory of the currently edited buffer
command! SH :silent lcd %:p:h|exec "silent !setsid x-terminal-emulator"|silent lcd -
