" generate a tag out of the current word
" imap <buffer> <C-g>t <Esc>czta
" imap <buffer> <C-g>T <Esc>czza
nnoremap <buffer> <silent> czt :call CursorWord2Tag(1)<CR>
nnoremap <buffer> <silent> czz :call CursorWord2Tag(0)<CR>

" work around markdown plugin that conceals all kinds of stuff
set conceallevel=0
