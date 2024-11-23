" Commands:
" ---------

" Source: https://vi.stackexchange.com/questions/27104/efficient-way-of-cleaning-up-the-buffer-list
" Wipe all deleted (unloaded & unlisted) or all unloaded buffers
function! Bwipeouts(listed) abort
    let l:buffers = filter(getbufinfo(), {_, v -> !v.loaded && (!v.listed || a:listed)})
    if !empty(l:buffers)
        execute 'bwipeout' join(map(l:buffers, {_, v -> v.bufnr}))
    endif
endfunction

command! -bar -bang Bwipeouts call Bwipeouts(<bang>0)

function! <SID>Rcd(...)
    if has('nvim')
        tabclose
    endif
    let l:attachments = []
    for dir in readfile(s:dir)
        exec 'cd '.escape(dir, " \t\\")
        break
    endfor
    call delete(s:dir)
endfunction

function! <SID>Cd(...)
    let s:dir= tempname()
    if has('nvim')
        tabe
        call termopen('ranger --choosedir='.s:dir, {'on_exit': function('<SID>Rcd')})
        startinsert
    else
        silent exec '!ranger --choosedir='.s:dir
        call s:Rcd()
    endif
endfun

command! -buffer -nargs=* -complete=file Rcd :call <SID>Cd(<f-args>)

" Integration with other editors
function! s:OpenEditor(editor, file)
    if a:file == ""
        return
    endif
    if has('nvim')
        " not yet perfect
        tabe
        call termopen(a:editor . " ". shellescape(a:file))
        startinsert
    else
        exec "!" . a:editor . " ". shellescape(a:file)
        redraw!
    endif
endfunction

command! Kak :call s:OpenEditor("kak", expand("%:p"))
command! Vis :call s:OpenEditor("vis", expand("%:p"))

if has('nvim')
    command! Vim :call s:OpenEditor("vim", expand("%:p"))
else
    command! Nvim :call s:OpenEditor("nvim", expand("%:p"))
endif

" dealing with patch artifacts
let s:fts = {'Source': '', 'Orig': 'orig', 'Rej': 'rej'}
let s:cmd = {' ': 'e', 's': 'sp', 'v': 'vs'}
function! s:GetArtifactName(ft)
    let l:artifact = expand('%')
    let l:extension = expand('%:e')
    if index(values(s:fts), l:extension) != -1
        let l:artifact = expand('%:r')
    endif
    if strlen(s:fts[a:ft])
        let l:artifact = l:artifact.'.'.s:fts[a:ft]
    endif
    return l:artifact
endfunction

function! s:EditArtifact(ft, split)
    let l:file = expand('%')
    if !strlen(l:file)
        return
    endif
    let l:artifact = s:GetArtifactName(a:ft)

    if l:file != l:artifact
        if filereadable(l:artifact)
            exec s:cmd[a:split].' '.fnameescape(l:artifact)
        else
            echom "File does not exist: ".l:artifact
        endif
    else
        echom "You're editing the requested file already"
    endif
endfunction

for ft in keys(s:fts)
    for cmd in keys(s:cmd)
        exec 'command! '.ft.cmd.' :call s:EditArtifact("'.ft.'", "'.cmd.'")'
    endfor
endfor

command! RmArtifacts :for i in [fnameescape(s:GetArtifactName('Orig')), fnameescape(s:GetArtifactName('Rej'))] | if filereadable(i) | call delete(i) | echom "Deleted" i | else | echom "File does not exist" i | endif | endfor

" create tags file in current working directory
command! MakeTags :silent! !ctags -R *

" move/open (with bang!) current buffer to the specified or a new tab
command! -bang -nargs=? Tabmove :let nr=bufnr('%')|if strlen('<bang>') == 0|close|endif|if strlen('args') > 0|tabn <args>|vsplit|else|tabnew|endif|exec ':b '.nr|unlet nr

function! OpenHuburl(bang)
    let l:cmd = '!huburl '.fnameescape(expand('%:p')).':'.line('.')
    if a:bang == ""
        exec l:cmd
    else
        exec l:cmd.'|xargs -r xdg-open'
    endif
endfunction

" print the git/gitlab URL for the current file
command! -nargs=? -bang Huburl :call OpenHuburl("<bang>")

function! UseTermBackground()
    if $TERM != "" && $TERM != "dumb"
        " Remove background color in order to fall back to the terminal's color
        highlight Normal ctermbg=NONE guibg=NONE
        highlight nonText ctermbg=NONE guibg=NONE
        highlight CursorLineNr ctermbg=NONE guibg=NONE
        highlight LineNr ctermbg=NONE guibg=NONE
    endif
endfunction

function! s:SetTheme(theme, background, blinds, cursor)
    exec "set background=".a:background
    let g:blinds_guibg = a:blinds
    exec "colorscheme ".a:theme
    call UseTermBackground()
    exec "hi Cursor guibg=".a:cursor
    hi clear MiniCursorword
    hi clear MiniCursorwordCurrent
    call luaeval("require('heirline').reset_highlights()")
    call luaeval("require('heirline').load_colors(require('custom.plugins.statusline.config').getColors())")
endfunction
"
" command! -nargs=0 ColorschemeCatppuccinMocha      :call luaeval("require('catppuccin').setup({ flavour = 'mocha'})")     | call s:SetTheme("catppuccin-mocha", "dark", "#414c61", "#87afd7")
" command! -nargs=0 ColorschemeCatppuccinMacchiato  :call luaeval("require('catppuccin').setup({ flavour = 'macchiato'})") | call s:SetTheme("catppuccin-macchiato", "dark", "#414c61", "#87afd7")
" command! -nargs=0 ColorschemeCatppuccinFrappe     :call luaeval("require('catppuccin').setup({ flavour = 'frappe'})")    | call s:SetTheme("catppuccin-frappe", "dark", "#414c61", "#87afd7")
" command! -nargs=0 ColorschemeCatppuccinLatte      :call luaeval("require('catppuccin').setup({ flavour = 'latte'})")     | call s:SetTheme("catppuccin-latte", "light", "#cdcdcd", "#87afd7")
" command! -nargs=0 ColorschemePaperColor           :call s:SetTheme("PaperColor", "light", "#cdcdcd", "#87afd7")
" command! -nargs=0 ColorschemeNord                 :call s:SetTheme("nord", "dark", "#414c61", "#87afd7")
command! -nargs=0 ColorschemeTokyoNight           :let g:tokyonight_style = "night" | call s:SetTheme("mytokyonight", "dark", "#414c61", "#87afd7")
command! -nargs=0 ColorschemeTokyoStorm           :let g:tokyonight_style = "storm" | call s:SetTheme("mytokyonight", "dark", "#414c61", "#87afd7")
command! -nargs=0 ColorschemeTokyoDay             :let g:tokyonight_style = "day"   | call s:SetTheme("mytokyonight", "light", "#cdcdcd", "#87afd7")
command! -nargs=0 ColorschemeTokyoMoon            :let g:tokyonight_style = "moon"  | call s:SetTheme("mytokyonight", "dark", "##414c61", "#87afd7")
" command! -nargs=0 ColorschemeOne :packadd one | set background=dark | let g:blinds_guibg = "#414c61" | colorscheme one | let g:lightline.colorscheme = "one" | call lightline#init() | call lightline#update() | hi Cursor guibg=#87afd7
" command! -nargs=0 ColorschemeOneLight :packadd one | set background=light | let g:blinds_guibg = "#cdcdcd" | colorscheme one | let g:lightline.colorscheme = "PaperColor" | call lightline#init() | call lightline#update() | hi Cursor guibg=#87afd7
