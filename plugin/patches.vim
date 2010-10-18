" patches.vim:	Commands for dealing with failed patches
" Last Modified: Sun 16. May 2010 17:18:34 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_patches") && g:loaded_patches) || &cp
    finish
endif
let g:loaded_patches = 1

" Easy jumping between files with failed patches
" Reject
command! Reject :if expand('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r.rej'|else|execute 'e %.rej'|endif
" Orig
command! Original :if expand('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r.orig'|else|execute 'e %.orig'|endif
" Mine
command! Mine :if expand('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r.mine'|else|execute 'e %.mine'|endif
" Source Code
command! Source :if expand('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r'|else|execute 'e %'|endif
