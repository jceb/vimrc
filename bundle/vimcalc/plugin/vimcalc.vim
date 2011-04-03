"AUTHOR:   Greg Sexton <gregsexton@gmail.com>
"WEBSITE:  https://github.com/gregsexton/VimCalc
"VERSION:  1.3, for Vim 7.0+
"LICENSE:  Same terms as Vim itself (see :help license).

"TODO: move most of the functionality to autoload script if gets more complicated

if has('python')
    let scriptdirpy = expand("<sfile>:h") . '/'
    exec "pyfile " . scriptdirpy . "vimcalc.py"
endif

if exists('g:loaded_vimcalc') || v:version < 700
  finish
endif
let g:loaded_vimcalc = 1

"configurable options
if !exists("g:VCalc_Title")
    let g:VCalc_Title = "__VCALC__"
endif
if !exists("g:VCalc_Prompt")
    let g:VCalc_Prompt = "> "
endif
if !exists("g:VCalc_Win_Size")
    let g:VCalc_Win_Size = 10
endif
if !exists("g:VCalc_Max_History")
    let g:VCalc_Max_History = 100
endif
if !exists("g:VCalc_CWInsert")
    let g:VCalc_CWInsert = 0
endif
if !exists("g:VCalc_InsertOnEnter")
    let g:VCalc_InsertOnEnter = 0
endif
if !exists("g:VCalc_WindowPosition")
    let g:VCalc_WindowPosition = 'top' "other possible values: left,right,bottom
endif

command! -nargs=0 -bar Calc call s:VCalc_Open()

function! s:VCalc_Open()
    "validate
    let valid = <SID>VCalc_ValidateVim()
    if valid == -1
        return
    endif

    "if the window is open, jump to it
    let winnum = bufwinnr(g:VCalc_Title)
    if winnum != -1
        "jump to the existing window
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
        return
    endif

    if g:VCalc_WindowPosition =~ "top\\|left"
        let position = 'aboveleft'
    else
        let position = 'rightbelow'
    endif

    "if the buffer does not already exist create otherwise edit.
    let bufnum = bufnr(g:VCalc_Title)
    if bufnum == -1
        if g:VCalc_WindowPosition =~ "left\\|right"
            let direction = 'vnew' 
        else
            let direction = 'new'
        endif

        let wcmd = direction . ' ' . g:VCalc_Title
        exe 'silent ' . position . ' ' . g:VCalc_Win_Size . wcmd
        call setline(1, g:VCalc_Prompt)
    else
        if g:VCalc_WindowPosition =~ "left\\|right"
            let direction = 'vsplit' 
        else
            let direction = 'split'
        endif

        let wcmd = direction . ' +buffer' . bufnum
        exe 'silent ' . position . ' ' . g:VCalc_Win_Size . wcmd
        call setline(line('$'), g:VCalc_Prompt)
    endif

    let b:VCalc_History = []
    let b:VCalc_History_Index = -1

    call <SID>VCalc_SetLocalSettings()
    call <SID>VCalc_DefineMappingsAndAutoCommands()
    call <SID>VCalc_JumpToPrompt(1)
endfunction

function! s:VCalc_SetLocalSettings()
    silent! setlocal buftype=nofile
    silent! setlocal nobuflisted
    silent! setlocal noswapfile
    silent! setlocal bufhidden=delete
    silent! setlocal nonumber
    silent! setlocal nowrap
    setlocal filetype=vimcalc
endfunction

function! s:VCalc_DefineMappingsAndAutoCommands()
    nnoremap <buffer> <silent> <CR> :call <SID>VCalc_REPL(0)<CR>
    inoremap <buffer> <silent> <CR> <C-o>:call <SID>VCalc_REPL(1)<CR>

    "inserting a new line jumps to the prompt
    nmap <buffer> <silent> o :call <SID>VCalc_JumpToPrompt(1)<CR>
    nmap <buffer> <silent> O :call <SID>VCalc_JumpToPrompt(1)<CR>

    nmap <buffer> <silent> <F1> :help vimcalc-function-list<CR>

    imap <buffer> <silent> <up> <C-o>:call <SID>VCalc_PreviousHistory()<CR>
    imap <buffer> <silent> <down> <C-o>:call <SID>VCalc_NextHistory()<CR>

    au BufEnter <buffer> :call <SID>VCalc_InsertOnEnter()

    call <SId>VCalc_CreateCWInsertMappings()
endfunction

function! s:VCalc_ValidateVim()
    if has('python') != 1
        echohl WarningMsg | echomsg "VCalc requires the Python interface to be installed." | echohl None
        return -1
    endif

    return 0
endfunction

function! s:VCalc_REPL(continueInsert)

    let expr = getline(".")
    if match(expr, g:VCalc_Prompt) != 0
        return
    else
        let expr = strpart(expr, matchend(expr, g:VCalc_Prompt))
    endif

    call <SID>VCalc_RecordHistory(expr)
    "TODO: this breaks if a double quoted string is inputed.
    exe "python repl(\"" . expr . "\")"

    "if executed command don't continue -- may be a ':q'
    if exists("w:vcalc_vim_command")
        stopinsert
        return
    endif

    let failed = append(line('$'), g:VCalc_Prompt)

    let b:VCalc_History_Index = -1

    call <SID>VCalc_JumpToPrompt(a:continueInsert)
endfunction

function! s:VCalc_JumpToPrompt(withInsert)
    call setpos(".", [0, line('$'), col('$'), 0])
    if a:withInsert == 1
        startinsert!
    endif
endfunction

function! s:VCalc_RecordHistory(expr)
    call insert(b:VCalc_History, a:expr)
    if len(b:VCalc_History) > g:VCalc_Max_History
        call remove(b:VCalc_History, -1)
    endif
endfunction

function! s:VCalc_PreviousHistory()
    if b:VCalc_History_Index < len(b:VCalc_History)-1
        let b:VCalc_History_Index += 1
        let failed = setline(line('$'), g:VCalc_Prompt . b:VCalc_History[b:VCalc_History_Index])
        call <SID>VCalc_JumpToPrompt(1)
    endif
endfunction

function! s:VCalc_NextHistory()
    if b:VCalc_History_Index > 0
        let b:VCalc_History_Index -= 1
        let failed = setline(line('$'), g:VCalc_Prompt . b:VCalc_History[b:VCalc_History_Index])
        call <SID>VCalc_JumpToPrompt(1)
    endif
endfunction

function! s:VCalc_InsertOnEnter()
    if g:VCalc_InsertOnEnter
        call <SID>VCalc_JumpToPrompt(1)
    endif
endfunction

function! s:VCalc_CreateCWInsertMappings()
    if g:VCalc_CWInsert
        imap <buffer> <silent> <C-W>l <ESC><C-W>l
        imap <buffer> <silent> <C-W>k <ESC><C-W>k
        imap <buffer> <silent> <C-W>j <ESC><C-W>j
        imap <buffer> <silent> <C-W>h <ESC><C-W>h
        imap <buffer> <silent> <C-W>b <ESC><C-W>b
        imap <buffer> <silent> <C-W>t <ESC><C-W>t
        imap <buffer> <silent> <C-W>w <ESC><C-W>w
        imap <buffer> <silent> <C-W>W <ESC><C-W>W
    endif
endfunction

" **********************************************************************************************************
" **** PYTHON **********************************************************************************************
" **********************************************************************************************************

if has('python')

python << EOF

import vim

def repl(expr):
    if expr != "":
        result = parse(expr)
        #if result is of the form: "!!!.*!!!" it is a vim command to execute.
        m = re.match(r"^!!!(.*)!!!$", result)
        if m:
            vim.command("call append(line('$'), g:VCalc_Prompt)") #add prompt
            vim.command(m.group(1))
            vim.command("let w:vcalc_vim_command = 1")
        else:
            for str in result.split("\n"):
                vim.command("call append(line('$'), \"" + str + "\")")
            vim.command("if exists(\"w:vcalc_vim_command\") | unlet w:vcalc_vim_command | endif")
EOF

endif
