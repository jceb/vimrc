" words.vim:	Mappings for dealing with words - capitalize and swap
" Last Modified: Sun 16. May 2010 17:13:06 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_words") && g:loaded_words) || &cp
    finish
endif
let g:loaded_words = 1

" Captialize word (movent/selection)
function! Capitalize(type, ...)
	let sel_save = &selection
	let &selection = "inclusive"
	let reg_save = @@

	if a:0  " Invoked from Visual mode, use '< and '> marks.
		silent exe "normal! `<" . a:type . "`>y"
	elseif a:type == 'line'
		silent exe "normal! '[V']y"
	elseif a:type == 'block'
		silent exe "normal! `[\<C-V>`]y"
	else
		silent exe "normal! `[v`]y"
	endif

	silent exe "normal! `[gu`]~`]"

	let &selection = sel_save
	let @@ = reg_save
endfunction

" Capitalize words (movement)
nnoremap <silent> gC :set opfunc=Capitalize<CR>g@
vnoremap <silent> gC :<C-U>call Capitalize(visualmode(), 1)<CR>

" swap two words
" http://vim.wikia.com/wiki/VimTip47
nnoremap <silent> gsw "_yiw:s/\(\%#[ÄÖÜäöüßa-zA-Z0-9]\+\)\(\_W\+\)\([ÄÖÜäöüßa-zA-Z0-9]\+\)/\3\2\1/<CR><C-o><C-l>:let @/ = ""<CR>
nnoremap <silent> gsW "_yiW:s/\(\%#[ÄÖÜäöüßa-zA-Z0-9-+*_]\+\)\(\_W\+\)\([ÄÖÜäöüßa-zA-Z0-9-+*_]\+\)/\3\2\1/<CR><C-o><C-l>:let @/ = ""<CR>
