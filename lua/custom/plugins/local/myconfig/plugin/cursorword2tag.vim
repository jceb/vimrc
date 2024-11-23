" cursorword2tag.vim:		Convert the word under the cursor into a tag
" Last Modified: Wed 24. Jan 2018 16:22:56 +0100 CET
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1
" License:		VIM LICENSE, see :h license

" Example mappings that could be put in after/ftplugin/html.vim
" imap <buffer> <C-f> <Esc>czta
" imap <buffer> <C-z> <Esc>czza
" nnoremap <buffer> <silent> czt :call CursorWord2Tag(1)<CR>
" nnoremap <buffer> <silent> czz :call CursorWord2Tag(0)<CR>

function! CursorWord2Tag(inline) abort
    " extract cursor word
    let l:linenr = line('.')
    let l:colnr = col('.')
    let l:line = getline(l:linenr)

    " find the start of the word under the cursor
    let l:wordStart = match(l:line[:l:colnr-1], '\k\+\s*$')
    if l:wordStart == -1
        " currently not on a word
        echom "No word found under cusor position that can be turned into a tag."
        return
    endif
    let l:wordEnd = l:wordStart + match(l:line[l:wordStart:], '\k\+\zs\s*')
    let l:word = l:line[l:wordStart:l:wordEnd-1]

    " construct tag
    let l:tag = ['<'.l:word.'>', '</'.l:word.'>']
    let l:lines = []
    if a:inline
        let l:lineStart = l:wordStart < 1 ? "" : l:line[:l:wordStart-1]
        let l:lines = [l:lineStart . join(l:tag, '') . l:line[l:wordEnd:]]
        let l:cursor = [l:linenr, l:wordStart + len(l:tag[0])]
    else
        if ! &et
            let l:sw = repeat("\t", &sw/&ts) . repeat(' ', &sw%&ts)
        else
            let l:sw = repeat(' ', &sw)
        endif
        let l:indentidx = match(l:line, '^\s*\zs\k')
        let l:indentspace = l:indentidx < 1 ?  "" : l:line[:l:indentidx-1]
        let l:line_offset = 1
        if l:wordStart > 0 && l:wordStart != l:indentidx
            call add(l:lines, l:line[:l:wordStart-1])
            let l:indentspace = l:indentspace . l:sw
            let l:line_offset = 2
        endif
        call add(l:lines, l:indentspace . l:tag[0])
        let l:cursor_indent = l:indentspace . l:sw
        call add(l:lines, l:cursor_indent)
        call add(l:lines, l:indentspace . l:tag[1])
        if strlen(l:line[l:wordEnd:]) > 0
            call add(l:lines, l:indentspace . l:line[l:wordEnd:])
        endif
        let l:cursor = [l:linenr + l:line_offset, len(l:cursor_indent)]
    endif

    " replace line(s)
    call setline(l:linenr, l:lines[0])
    let l:idx = 1
    while l:idx < len(l:lines)
        call append(l:linenr + l:idx-1, l:lines[l:idx])
        let l:idx += 1
    endwhile

    " position cursor
    call cursor(l:cursor)
endfunction
