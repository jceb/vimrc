" cursorword2tag.vim:		Convert the word under the cursor into a tag
" Last Modified: Wed 24. Jan 2018 16:22:56 +0100 CET
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1
" License:		VIM LICENSE, see :h license

" Example mappings that could be put in after/ftplugin/html.vim
" imap <buffer> <C-f> <Esc>czta
" imap <buffer> <C-z> <Esc>czta
" nnoremap <buffer> <silent> czt :call CursorWord2Tag(1)<CR>
" nnoremap <buffer> <silent> czz :call CursorWord2Tag(0)<CR>

function! CursorWord2Tag(inline) abort
    " extract cursor word
    let l:l = line('.')
    let l:c = col('.')
    let l:line = getline(l:l)
    let l:ws = match(l:line[:l:c-1], '\k\+\s*$')
    if l:ws == -1
        return
    endif
    let l:we = l:ws + match(l:line[l:ws:], '\k\+\zs\s*')
    let l:word = l:line[l:ws:l:we-1]

    " construct tag
    let l:tag = ['<'.l:word.'>', '</'.l:word.'>']
    let l:lines = []
    if a:inline
        let l:lines = [l:line[:l:ws-1] . join(l:tag, '') . l:line[l:we:]]
        let l:cursor = [l:l, l:ws + len(l:tag[0])]
    else
        let l:indent = match(l:line, '^\s*\zs\k')
        let l:is = l:line[:l:indent-1]
        let l:line_offset = 1
        if l:ws > 0 && l:ws != l:indent
            call add(l:lines, l:line[:l:ws-1])
            let l:is = l:is.repeat(' ', &sw)
            let l:line_offset = 2
        endif
        call add(l:lines, l:is.l:tag[0])
        let l:cursor_indent = l:is.repeat(' ', &sw)
        call add(l:lines, l:cursor_indent)
        call add(l:lines, l:is.l:tag[1])
        call add(l:lines, l:line[l:we:])
        let l:cursor = [l:l + l:line_offset, len(l:cursor_indent)]
    endif

    " replace line
    let l:idx = 0
    while l:idx < len(l:lines)
        if l:idx == 0
            call setline(l:l, l:lines[l:idx])
        else
            call append(l:l + l:idx-1, l:lines[l:idx])
        endif
        let l:idx += 1
    endwhile

    " position cursor
    call cursor(l:cursor)
endfunction
