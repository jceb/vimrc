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
            " ColorschemeNord
            ColorschemeTokyoStorm
            let s:colorscheme_changed = 1
        else
            if s:colorscheme_changed == 0 || (exists('g:lightline.colorscheme') && g:lightline.colorscheme != 'PaperColor')
                " ColorschemePaperColor
                ColorschemeTokyoDay
                let s:colorscheme_changed = 1
            endif
        endif

        let s:colorscheme_changed = l:colorscheme_changed
    endif
    " make sure that every window get updated to enable integration with
    " blinds.nvim
    let winnr = winnr()
    windo echo
    exec ":normal " . winnr . ""

    " workaround because the event isn't triggered by the above command for some
    " unknown reason
    doau ColorScheme
endfunction

lua << END
    local w = vim.loop.new_fs_event()
    local function on_change(fullpath, err, fname, status)
      -- Do work...
      vim.api.nvim_command('ColorschemeAuto')
      -- Debounce: stop/start.
      w:stop()
      watch_file(fullpath)
    end
    function watch_file(fname)
      -- local fullpath = vim.api.nvim_call_function('fnamemodify', {fname, ':p'})
      local fullpath = vim.fn.fnamemodify(fname, ':p')
      w:start(fullpath, {}, vim.schedule_wrap(function(...)
        on_change(fullpath, ...) end))
    end
    watch_file("~/.config/colorscheme")
END

command -nargs=0 ColorschemeAuto call AutoSetColorscheme()
au VimEnter * call AutoSetColorscheme()
