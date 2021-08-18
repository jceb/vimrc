" " nvim-lsp {{{1
" lua << END
" local nvim_lsp = require'nvim_lsp'
" nvim_lsp.bashls.setup{}
" nvim_lsp.cssls.setup{}
" nvim_lsp.html.setup{}
" nvim_lsp.jsonls.setup{}
" nvim_lsp.pyls.setup{}
" nvim_lsp.tsserver.setup{}
" nvim_lsp.vimls.setup{}
" nvim_lsp.vuels.setup{}
" nvim_lsp.yamlls.setup{}
" END

let s:colorscheme_changed = 0
function! AutoSetColorscheme(...)
    " idea: use `redshift -p 2>/dev/null | awk '/Period:/ {print $2}'` to
    " determine the colorscheme
    let l:colorscheme_file = expand('~/.config/colorscheme')
    let l:colorscheme = ''
    let l:colorscheme_changed = 0
    if filereadable(l:colorscheme_file)
        let l:colorscheme_changed = getftime(l:colorscheme_file)
        if l:colorscheme_changed > s:colorscheme_changed
            let l:colorscheme_read = readfile(l:colorscheme_file, '', 1)
            if len(l:colorscheme_read) >= 1
                let l:colorscheme = l:colorscheme_read[0]
            endif
        endif
    endif

    if l:colorscheme_changed > s:colorscheme_changed || s:colorscheme_changed == 0
        if l:colorscheme == 'dark' && (s:colorscheme_changed == 0 || (exists('g:lightline.colorscheme') && g:lightline.colorscheme != 'nord'))
            ColorschemeNord
            let s:colorscheme_changed = 1
        else
            if s:colorscheme_changed == 0 || (exists('g:lightline.colorscheme') && g:lightline.colorscheme != 'PaperColor')
                ColorschemePaperColor
                let s:colorscheme_changed = 1
            endif
        endif

        let s:colorscheme_changed = l:colorscheme_changed
    endif
endfunction

call AutoSetColorscheme()
if exists('g:colorscheme_timer')
    call timer_stop(g:colorscheme_timer)
endif
let g:colorscheme_timer = timer_start(15000, 'AutoSetColorscheme', {'repeat': -1})

command -nargs=0 ColorschemeAuto call AutoSetColorscheme()
