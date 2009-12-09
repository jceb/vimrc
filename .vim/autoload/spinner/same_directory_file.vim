
function! spinner#same_directory_file#next()
    call spinner#same_directory_file#open_next_file(1)
endfunction

function! spinner#same_directory_file#previous()
    call spinner#same_directory_file#open_next_file(0)
endfunction

function! spinner#same_directory_file#load()
    let g:spinner#same_directory_file#exeextmap = {}
    if exists('$PATHEXT')
        let l:list = split($PATHEXT, ';')
        for l:i in l:list
            let g:spinner#same_directory_file#exeextmap[l:i] = 1
        endfor
    endif
endfunction


func! spinner#same_directory_file#warn(msg)
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunc

func! spinner#same_directory_file#get_idx_of_list(lis, elem)
    let l:i = 0
    while l:i < len(a:lis)
        if a:lis[l:i] ==# a:elem
            return l:i
        endif
        let l:i = l:i + 1
    endwhile
    throw "not found"
endfunc

func! spinner#same_directory_file#glob_list(expr)
    let l:files = split(glob(a:expr), '\n')
    " get rid of '.' and '..'
    call filter(l:files, 'fnamemodify(v:val, ":t") !=# "." && fnamemodify(v:val, ":t") !=# ".."')
    return l:files
endfunc

func! spinner#same_directory_file#sort_compare(i, j)
    " alphabetically
    return a:i > a:j
endfunc

func! spinner#same_directory_file#get_files_list(...)
    " get files list
    let l:glob_expr = a:0 == 0 ? '*' : a:1
    let l:globed = spinner#same_directory_file#glob_list(expand('%:p:h') . '/' . l:glob_expr)

    let l:files = []
    for l:i in l:globed
        if isdirectory(l:i)
            continue
        endif
        if ! filereadable(l:i)
            continue
        endif
        let l:ext = fnamemodify(l:i, ":e")
        if has_key(g:spinner#same_directory_file#exeextmap, l:ext)
            continue
        endif

        call add(l:files, l:i)
    endfor

    return sort(l:files, 'spinner#same_directory_file#sort_compare')
endfunc

func! spinner#same_directory_file#get_next_idx(files, advance, cnt)
    try
        " get current file idx
        let l:tailed = map(copy(a:files), 'fnamemodify(v:val, ":t")')
        let l:idx = spinner#same_directory_file#get_idx_of_list(l:tailed, expand('%:t'))
        " move to next or previous
        let l:idx = a:advance ? l:idx + a:cnt : l:idx - a:cnt
    catch /^not found$/
        " open the first file.
        let l:idx = 0
    endtry
    return l:idx
endfunc

func! spinner#same_directory_file#open_next_file(advance)
    if expand('%') ==# ''
        return spinner#same_directory_file#warn("current file is empty.")
    endif

    let l:files = spinner#same_directory_file#get_files_list()
    if empty(l:files) | return | endif
    let l:idx   = spinner#same_directory_file#get_next_idx(l:files, a:advance, v:count1)

    if 0 <= l:idx && l:idx < len(l:files)
        " can access to files[l:idx]
        execute 'edit ' . fnameescape(l:files[l:idx])
    else
        " wrap around
        if l:idx < 0
            " fortunately recent LL languages support negative index :)
            let l:idx = -(abs(l:idx) % len(l:files))
            " But if you want to access to 'real' index:
            " if l:idx != 0
            "     let l:idx = len(l:files) + l:idx
            " endif
        else
            let l:idx = l:idx % len(l:files)
        endif
        execute 'edit ' . fnameescape(l:files[l:idx])
    endif
endfunc


