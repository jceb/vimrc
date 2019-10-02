" Commands:
" ---------

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

" print the git/gitlab URL for the current file
command! -nargs=? Huburl :exec '!huburl '.fnameescape(expand('%')).':'.line('.')

command! -nargs=0 ColorschemePaperColor :set background=light | let g:blinds_guibg = "#cdcdcd" | colorscheme PaperColor | let lightline.colorscheme = "PaperColor" | call lightline#init() | call lightline#update()
command! -nargs=0 ColorschemeOne :packadd one | set background=dark | let g:blinds_guibg = "#414c61" | colorscheme one | let lightline.colorscheme = "one" | call lightline#init() | call lightline#update()
command! -nargs=0 ColorschemeOneLight :packadd one | set background=light | let g:blinds_guibg = "#cdcdcd" | colorscheme one | let lightline.colorscheme = "PaperColor" | call lightline#init() | call lightline#update()
