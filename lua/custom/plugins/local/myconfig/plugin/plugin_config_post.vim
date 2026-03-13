let s:colorscheme_changed = 0
let s:colorscheme = ""
function! AutoSetColorscheme(bang = "", ...)
  let l:colorscheme = ''
  let l:colorscheme_changed = 0
  " idea: use `redshift -p 2>/dev/null | awk '/Period:/ {print $2}'` to determine the colorscheme
  let l:colorscheme_file = expand('~/.config/colorscheme')
  if filereadable(l:colorscheme_file)
    let l:colorscheme_changed = getftime(l:colorscheme_file)
    if a:bang == "!" || l:colorscheme_changed > s:colorscheme_changed
      let l:colorscheme_read = readfile(l:colorscheme_file, '', 1)
      if len(l:colorscheme_read) >= 1
        " echom "colorscheme changed: " .. l:colorscheme_read[0] .. " current: " ..s:colorscheme
        let l:colorscheme = l:colorscheme_read[0]
      endif
    endif
  endif

  if a:bang == "!" || l:colorscheme_changed > s:colorscheme_changed || s:colorscheme_changed == 0
    " echom "Updating colorscheme"
    if l:colorscheme == 'light' && (l:colorscheme != s:colorscheme || a:bang == "!")
      let s:colorscheme = l:colorscheme
      " ColorschemePaperColor
      ColorschemeTokyoDay
    else
      if l:colorscheme != s:colorscheme || a:bang == "!"
        let s:colorscheme = l:colorscheme
        ColorschemeTokyoStorm
        " ColorschemeNord
      endif
    end
    let s:colorscheme_changed = l:colorscheme_changed
    " make sure that every window get updated to enable integration with
    " blinds.nvim
    " let winnr = winnr()
    " windo echo
    " exec ":normal " . winnr . ""

    " workaround because the event isn't triggered by the above command for some
    " unknown reason
    " doau ColorScheme
  endif
endfunction

lua << END
  local w = vim.loop.new_fs_event()
  function watch_file(fname)
    local fullpath = vim.fn.fnamemodify(fname, ':p')
    w:start(fullpath, {}, function(err, filename, events)
      if events.change then
        vim.schedule(function()
          vim.fn.AutoSetColorscheme()
        end)
      end
    end)
  end
  watch_file("~/.config/colorscheme")
END

command -nargs=0 -bang ColorschemeAuto call AutoSetColorscheme("<bang>")
au VimEnter * call AutoSetColorscheme()
