" words.vim:	Mappings for dealing with words - capitalize and swap
" Last Modified: Mon 10. Jan 2011 22:47:52 +0100 CET
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
nnoremap <silent> gxp "_yiw:s/\(\%#[ÄÖÜäöüßa-zA-Z0-9]\+\)\(\_W\+\)\([ÄÖÜäöüßa-zA-Z0-9]\+\)/\3\2\1/<CR><C-o><C-l>:let @/ = ""<CR>
nnoremap <silent> gxP "_yiW:s/\(\%#[ÄÖÜäöüßa-zA-Z0-9-+*_]\+\)\(\_W\+\)\([ÄÖÜäöüßa-zA-Z0-9-+*_]\+\)/\3\2\1/<CR><C-o><C-l>:let @/ = ""<CR>


" copied from http://code.google.com/p/lh-vim/source/browse/misc/trunk/plugin/vim-tip-swap-word.vim

" Swap the current word with the previous, keeping cursor on current word:
" (This feels like "pushing" the word to the left.) 
" nnoremap <silent> gl "_yiw?\w\+\_W\+\%#<CR>:PopSearch<cr>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>:PopSearch<cr><c-o><c-l>
"nnoremap <silent> gXp :call <sid>SwapWithPrev('left', 'w')<cr>

" Swap the current word with the next, keeping cursor on current word: (This
" feels like "pushing" the word to the right.) (See note.)
" nnoremap <silent> gr "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>:PopSearch<cr><c-o>/\w\+\_W\+<CR>:PopSearch<cr>
"nnoremap <silent> gxp :call <sid>SwapWithNext('right', 'w')<cr>

" ======================================================================
" LH, 27th Apr 2010
" Swap functions with no side effect on the search history or on the screen.
" Moreover, when undone, these version put the cursor back to its first
" position

" Function: SwapWithNext(cursor_pos)
" {cursor_pos} values:
" 'keep' : stays at the same position
" 'follow' : stays with the current word, at the same relative offset
" 'right' : put the cursor at the start of the new right word
" 'left' : put the cursor at the start of the new left word
" todo: move to an autoplugin
" todo: support \w or \k ...


let s:k_entity_pattern = {}
let s:k_entity_pattern.w = {}
let s:k_entity_pattern.w.in = '\w'
let s:k_entity_pattern.w.out = '\W'
let s:k_entity_pattern.w.prev_end = '\zs\w\W\+$'
let s:k_entity_pattern.k = {}
let s:k_entity_pattern.k.in = '\k'
let s:k_entity_pattern.k.out = '\k\@!'
let s:k_entity_pattern.k.prev_end = '\k\(\k\@!.\)\+$'


function! s:SwapWithNext(cursor_pos, type)
  let s = getline('.')
  let l = line('.')
  let c = col('.')-1
  let in  = s:k_entity_pattern[a:type].in
  let out = s:k_entity_pattern[a:type].out

  let crt_word_start = match(s[:c], in.'\+$')
  let crt_word_end  = match(s, in.out, crt_word_start)
  if crt_word_end == -1
    throw "No next word to swap the current word with"
  endif
  let next_word_start = match(s, in, crt_word_end+1)
  if next_word_start == -1
    throw "No next word to swap the current word with"
  endif
  let next_word_end  = match(s, in.out, next_word_start)
  let crt_word = s[crt_word_start : crt_word_end]
  let next_word = s[next_word_start : next_word_end]

  " echo  '['.crt_word_start.','.crt_word_end.']='.crt_word 
  " \   .'### ['.next_word_start.','.next_word_end.']='.next_word
  let s2 = (crt_word_start>0 ? s[:crt_word_start-1] : '')
        \ . next_word
        \ . s[crt_word_end+1 : next_word_start-1]
        \ . crt_word 
        \ . (next_word_end==-1 ? '' : s[next_word_end+1 : -1])
  " echo s2
  call setline(l, s2) 
  if     a:cursor_pos == 'keep'   | let c2 = c+1
  elseif a:cursor_pos == 'follow' | let c2 = c + strlen(next_word) + (next_word_start-crt_word_end)
  elseif a:cursor_pos == 'left'   | let c2 = crt_word_start+1
  elseif a:cursor_pos == 'right'  | let c2 = strlen(next_word) + next_word_start - crt_word_end + crt_word_start
  endif
  call cursor(l,c2)
endfunction

" Function: SwapWithPrev(cursor_pos)
" {cursor_pos} values:
" 'keep' : stays at the same position
" 'follow' : stays with the current word, at the same relative offset
" 'right' : put the cursor at the start of the new right word
" 'left' : put the cursor at the start of the new left word
" todo: move to an autoplugin
function! s:SwapWithPrev(cursor_pos, type)
  let s = getline('.')
  let l = line('.')
  let c = col('.')-1
  let in  = s:k_entity_pattern[a:type].in
  let out = s:k_entity_pattern[a:type].out
  let prev_end = s:k_entity_pattern[a:type].prev_end

  let crt_word_start = match(s[:c], in.'\+$')
  if crt_word_start == -1
    throw "No previous word to swap the current word with"
  endif
  let crt_word_end  = match(s, in.out, crt_word_start)
  let crt_word = s[crt_word_start : crt_word_end]

  let prev_word_end = match(s[:crt_word_start-1], prev_end)
  let prev_word_start = match(s[:prev_word_end], in.'\+$')
  if prev_word_end == -1
    throw "No previous word to swap the current word with"
  endif
  let prev_word = s[prev_word_start : prev_word_end]

  " echo  '['.crt_word_start.','.crt_word_end.']='.crt_word 
  " \   .'### ['.prev_word_start.','.prev_word_end.']='.prev_word
  let s2 = (prev_word_start>0 ? s[:prev_word_start-1] : '')
        \ . crt_word 
        \ . s[prev_word_end+1 : crt_word_start-1]
        \ . prev_word
        \ . (crt_word_end==-1 ? '' : s[crt_word_end+1 : -1])
  " echo s2
  call setline(l, s2) 
  if     a:cursor_pos == 'keep'   | let c2 = c+1
  elseif a:cursor_pos == 'follow' | let c2 = prev_word_start + c - crt_word_start + 1 
  elseif a:cursor_pos == 'left'   | let c2 = prev_word_start+1
  elseif a:cursor_pos == 'right'  | let c2 = strlen(crt_word) + crt_word_start - prev_word_end + prev_word_start
  endif
  call cursor(l,c2)
endfunction
