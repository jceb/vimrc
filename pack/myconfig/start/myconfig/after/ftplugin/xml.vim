" generate a tag for the current word
imap <buffer> <C-f> <Esc>czta
imap <buffer> <C-z> <Esc>czta
nnoremap <buffer> <silent> czt :call CursorWord2Tag(1)<CR>
nnoremap <buffer> <silent> czz :call CursorWord2Tag(0)<CR>
