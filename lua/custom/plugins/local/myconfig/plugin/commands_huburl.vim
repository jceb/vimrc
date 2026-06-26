" Source: https://github.com/jceb/huburl
" Print the (git)hub's URL for the current file
" <bang> behaves like -o and opens then URL
" Manually pass arguments to :Huburl, e.g. -o to open the URL or -c to copy it to the clipboard
function! Huburl(bang, args)
    let l:args = a:args
    if a:bang == "!"
        let l:args = l:args.' -o'
    end
    let l:file = expand('%:p')
    let l:line = ":".line('.')
    if l:file == ""
        let l:file = getcwd()
        let l:line = ""
    end
    exec '!huburl '.fnameescape(l:file).l:line.' '.l:args
endfunction
command! -nargs=* -complete=file -bang Huburl :call Huburl("<bang>", <q-args>)
