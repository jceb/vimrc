" Commands:
" ---------

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

" create a scratch pad buffer
command! -nargs=* Scratch :if bufname('%') != '' | vs | ene | endif | setlocal buftype=nofile <args>
command! -nargs=* ScratchOrg :Scratch | setf org

" move/open (with bang!) current buffer to the specified or a new tab
command! -bang -nargs=? Tabmove :let nr=bufnr('%')|if strlen('<bang>') == 0|close|endif|if strlen('args') > 0|tabn <args>|vsplit|else|tabnew|endif|exec ':b '.nr|unlet nr
