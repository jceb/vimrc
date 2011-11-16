" Download: https://gist.github.com/1290527
" Place in ~/.vim/after/plugin/speeddating.vim

" In Vim, -4 % 3 == -1. Let's return 2 instead.
function! s:mod(a,b)
    if (a:a < 0 && a:b > 0 || a:a > 0 && a:b < 0) && a:a % a:b != 0
        return (a:a % a:b) + a:b
    else
        return a:a % a:b
    endif
endfunction

let s:cycles = [
            \ ['true', 'false'],
            \ ['TRUE', 'FALSE'],
            \ ['True', 'False'],
            \ ['on', 'off'],
            \ ['ON', 'OFF'],
            \ ['On', 'Off'],
            \ ['yes', 'no'],
            \ ['YES', 'NO'],
            \ ['Yes', 'No']
            \ ]

function! KeywordIncrement(word, offset, increment)
    for set in s:cycles
        let index = index(set, a:word)
        if index >= 0
            let index = s:mod(index + a:increment, len(set))
            return [set[index], -1]
        endif
    endfor
endfunction

let s:handler = {'regexp': '\<\%('.join(map(copy(s:cycles),'join(v:val,"\\|")'),'\|').'\)\>', 'increment': function("KeywordIncrement")}
let g:speeddating_handlers += [s:handler]
