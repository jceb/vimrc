" File:        chapa.vim
" Description: Go to or visually select the next/previous class, method or
"              function in Python.
" Maintainer:  Alfredo Deza <alfredodeza AT gmail.com>
" License:     MIT
" Notes:       A lot of the code within was adapted/copied from python.vim 
"              and python_fn.vim authored by Jon Franklin and Mikael Berthe
"
"============================================================================

if exists("g:loaded_chapa") || &cp 
  finish
endif

"{{{ Default Mappings 
if (exists('g:chapa_default_mappings'))
    " Function Movement
    nmap fnf <Plug>ChapaNextFunction
    nmap fpf <Plug>ChapaPreviousFunction

    " Function Visual Select
    nmap vnf <Plug>ChapaVisualNextFunction
    nmap vif <Plug>ChapaVisualThisFunction
    nmap vpf <Plug>ChapaVisualPreviousFunction

    " Comment Function 
    nmap cif <Plug>ChapaCommentThisFunction
    nmap cnf <Plug>ChapaCommentNextFunction
    nmap cpf <Plug>ChapaCommentPreviousFunction

    " Repeat Mappings
    nmap <C-h> <Plug>ChapaOppositeRepeat
    nmap <C-l> <Plug>ChapaRepeat
endif

"{{{ Helpers

" In certain situations, it allows you to echo something without 
" having to hit Return again to do exec the command.
" It looks if the global message variable is set or set to 0 or set to 1
function! s:Echo(msg)
  if (! exists('g:chapa_messages') || exists('g:chapa_messages') && g:chapa_messages)
    let x=&ruler | let y=&showcmd
    set noruler noshowcmd
    redraw
    echo a:msg
    let &ruler=x | let &showcmd=y
  endif
endfun

" Wouldn't it be nice if you could just repeat the effing Movements
" instead of typing mnemonics to keep going forward or backwards?
" Exactly.
function! s:Repeat()
    if (exists('g:chapa_last_action'))
        let cmd = "call " . g:chapa_last_action 
        exe cmd
    else 
        echo "No command to repeat"
    endif 
endfunction

function! s:BackwardRepeat()
    let act_map = {'s:NextFunction(0)' : 's:PreviousFunction(0)',
                \'s:PreviousFunction(0)' : 's:NextFunction(0)'}
    if (exists('g:chapa_last_action'))
        let fwd = g:chapa_last_action 
        let cmd = "call " . act_map[fwd]
        exe cmd
    else 
        echo "No opposite command to repeat"
    endif
endfunction
"}}}

"{{{ Main Functions 
" Range for commenting 
function! s:JSCommentObject(obj, direction, count)
    let orig_line = line('.')
    let orig_col = col('.')

    " Go to the object declaration
    normal $
    let go_to_obj = s:FindObject(a:obj, a:direction, a:count)
        
    if (! go_to_obj)
        exec orig_line
        exe "normal " orig_col . "|"
        return
    endif

    let beg = line('.')

    let until = s:NextIndent(1)

    " go to the line we need
    exec beg

    " catch same line definitions 
    
    let line_moves = until - beg

    " check if we have comments or not 
    let has_comments = s:HasComments(beg, until)
    if (has_comments == 1)
        let regex = ' s/^\/\///'
    else
        let regex = ' s/^/\/\//'
    endif

    if (until == beg)
        execute regex    
        return 1
    endif
        
    if line_moves > 0
        execute beg . "," . until . regex
    else
        execute "%" . regex
    endif
    let @/ = ""
    return 1
endfunction

" Find if a Range has comments or not 
function! s:HasComments(from, until)
    let regex =  's/^\/\///gn'
    try 
        silent exe a:from . "," . a:until . regex
        return 1
    catch /^Vim\%((\a\+)\)\=:E/
        return 0
    endtry
endfunction

" Find the last commented line 
function! s:LastComment(from_line)
    let line = a:from_line
    while ((getline(line) =~ '^\s*\/\/') && (line <= line('$')))
        let line = line+1
    endwhile 
    return line 
endfunction

" Select an object ("class"/"function")
function! s:PythonSelectObject(obj, direction, count)
    let orig_line = line('.')
    let orig_col = col('.')

    " Go to the object declaration
    normal $
    let go_to_obj = s:FindObject(a:obj, a:direction, a:count)
        
    if (! go_to_obj)
        exec orig_line
        exe "normal " orig_col . "|"
        return
    endif

    let beg = line('.')

    let until = s:NextIndent(1)

    " go to the line we need
    exec beg

    " catch a one line definition 
    if (until == beg)
        execute "normal v$"
    else
        let line_moves = until - beg

        if line_moves > 0
            execute "normal V" . line_moves . "j"
        else
            execute "normal VG" 
        endif
    endif
endfunction


function! s:NextIndent(fwd)
    let line = line('.')
    let column = col('.')
    let lastline = line('$')
    let indent = indent(line)
    let stepvalue = a:fwd ? 1 : -1

    exe 'normal f{'
    exe 'normal %'

    let closing_brace = line('.')
    " return to initial line 
    exe line 

    return closing_brace 


endfunction
 

" Go to previous (-1) or next (1) function definition
" return a line number that matches a function
function! s:FindObject(obj, direction, count)
    let orig_line = line('.')
    let orig_col = col('.')
    let objregexp = '\v^\s*(.*function)\s*\('
    let flag = "W"
    if (a:direction == -1)
        let flag = flag."b"
    endif
    let _count = a:count
    let matched_search = 0
    if (_count == 0)
        let result = search(objregexp, flag)
        if result 
            let matched_search = result 
        endif
    else    
        while _count > 0
            let result = search(objregexp, flag)
            if result 
                let matched_search = result 
            endif
            let _count = _count - 1
        endwhile
    endif
    if (matched_search != 0)
        return matched_search
    endif
endfunction


function! s:IsInside(object)
    let beg = line('.')
    let column = col('.')
    " Verifies you are actually inside 
    " of the object you are referring to 
    let function = s:PreviousObjectLine("function")
    exe 'normal f{'
    exe 'normal %'
    let c_brace = line('.')

    "get back to the beginning 
    exe beg 
    exe "normal " column . "|"

    if (function == -1)
        return -1
    elseif (beg < c_brace) && (beg > function)
        return 1
    else 
        return 0
    endif
endfunction 

function! s:PreviousObjectLine(obj)
    let beg = line('.')
    let objregexp = '\v^\s*(.*function)\s*\('

    let flag = 'Wb' 

    " are we on THE actual beginning of the object? 
    if (getline('.') =~ objregexp)
        return -1
    else
        let result = search(objregexp, flag)
        if (line('.') == beg)
            return 0
        endif
        if result
            return line('.')
        else 
            return 0
        endif
    endif

endfunction
"}}}

"{{{ Proxy Functions 
"
"
" Comment Function Selections:
"
function! s:CommentPreviousFunction()
    let inside = s:IsInside("function")
    let times = v:count1+inside
    if (! s:JSCommentObject("function", -1, times))
        call s:Echo("Could not match previous function for commenting")
    endif 
endfunction

function! s:CommentNextFunction()
    if (! s:JSCommentObject("function", 1, v:count1))
        call s:Echo("Could not match next function for commenting")
    endif 
endfunction

function! s:CommentThisFunction()
    if (! s:JSCommentObject("function", -1, 1))
        call s:Echo("Could not match inside of function for commenting")
    endif 
endfunction

"
" Visual Selections:
"
" Visual Function Selections:
function! s:VisualNextFunction()
    if (! s:PythonSelectObject("function", 1, v:count1))
        call s:Echo("Could not match next function for visual selection")
    endif
endfunction

function! s:VisualPreviousFunction()
    let inside = s:IsInside("function")
    let times = v:count1+inside
    if (! s:PythonSelectObject("function", -1, times))
        call s:Echo("Could not match previous function for visual selection")
    endif 
endfunction

function! s:VisualThisFunction()
    if (! s:PythonSelectObject("function", -1, 1))
        call s:Echo("Could not match inside of function for visual selection")
    endif 
endfunction


" 
" Movements:
" 
" Function:
function! s:PreviousFunction(record)
    if (a:record == 1)
        let g:chapa_last_action = "s:PreviousFunction(0)"
    endif
    let inside = s:IsInside("function")
    let times = v:count1+inside
    if (! s:FindObject("function", -1, times))
        call s:Echo("Could not match previous function")
    endif 
endfunction
        
function! s:NextFunction(record)
    if (a:record == 1)
        let g:chapa_last_action = "s:NextFunction(0)"
    endif
    if (! s:FindObject("function", 1, v:count1))
        call s:Echo("Could not match next function")
    endif 
endfunction
"}}}

"{{{ Misc 
" Comment Function: 
nnoremap <silent> <Plug>ChapaCommentPreviousFunction   :<C-U>call <SID>CommentPreviousFunction()  <CR>
nnoremap <silent> <Plug>ChapaCommentNextFunction       :<C-U>call <SID>CommentNextFunction()      <CR>
nnoremap <silent> <Plug>ChapaCommentThisFunction       :<C-U>call <SID>CommentThisFunction()      <CR>

" Visual Select Function:
nnoremap <silent> <Plug>ChapaVisualNextFunction     :<C-U>call <SID>VisualNextFunction()    <CR>
nnoremap <silent> <Plug>ChapaVisualPreviousFunction :<C-U>call <SID>VisualPreviousFunction()<CR>
nnoremap <silent> <Plug>ChapaVisualThisFunction     :<C-U>call <SID>VisualThisFunction()    <CR>

" Function Movement:
nnoremap <silent> <Plug>ChapaPreviousFunction       :<C-U>call <SID>PreviousFunction(1)     <CR>
nnoremap <silent> <Plug>ChapaNextFunction           :<C-U>call <SID>NextFunction(1)         <CR>

" Repeating Movements:
nnoremap <silent> <Plug>ChapaOppositeRepeat         :<C-U>call <SID>BackwardRepeat()        <CR>
nnoremap <silent> <Plug>ChapaRepeat                 :<C-U>call <SID>Repeat()                <CR>
"}}}
