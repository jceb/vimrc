" Commands and functions related to changing the colorscheme

function! s:SetTheme(theme, background, blinds, cursor)
    exec "set background=".a:background
    let g:blinds_guibg = a:blinds
    exec "colorscheme ".a:theme
    " Don't remove the background color inside neovide, just in regular terminals
    if $TERM != "" && $TERM != "dumb" && $TERM != "linux"
        " Remove background color in order to use to the terminal's background color
        highlight Normal ctermbg=NONE guibg=NONE
        highlight nonText ctermbg=NONE guibg=NONE
        highlight CursorLineNr ctermbg=NONE guibg=NONE
        highlight LineNr ctermbg=NONE guibg=NONE
    endif
    exec "hi Cursor guibg=".a:cursor
    call v:lua.require'blinds'.setGuibg(a:blinds)
    " Cleanup some mini highlithing settings I dont like
    hi clear MiniCursorword
    hi clear MiniCursorwordCurrent
    call v:lua.require'heirline'.reset_highlights()
    call v:lua.require'heirline'.load_colors(v:lua.require'custom.plugins.statusline.config'.getColors())
endfunction

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
        ColorschemeTokyoMoon
        " ColorschemeTokyoStorm
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

" command! -nargs=0 ColorschemeCatppuccinMocha      :call luaeval("require('catppuccin').setup({ flavour = 'mocha'})")     | call s:SetTheme("catppuccin-mocha", "dark", "#414c61", "#87afd7")
" command! -nargs=0 ColorschemeCatppuccinMacchiato  :call luaeval("require('catppuccin').setup({ flavour = 'macchiato'})") | call s:SetTheme("catppuccin-macchiato", "dark", "#414c61", "#87afd7")
" command! -nargs=0 ColorschemeCatppuccinFrappe     :call luaeval("require('catppuccin').setup({ flavour = 'frappe'})")    | call s:SetTheme("catppuccin-frappe", "dark", "#414c61", "#87afd7")
" command! -nargs=0 ColorschemeCatppuccinLatte      :call luaeval("require('catppuccin').setup({ flavour = 'latte'})")     | call s:SetTheme("catppuccin-latte", "light", "#cdcdcd", "#87afd7")
" command! -nargs=0 ColorschemePaperColor           :call s:SetTheme("PaperColor", "light", "#cdcdcd", "#87afd7")
" command! -nargs=0 ColorschemeNord                 :call s:SetTheme("nord", "dark", "#414c61", "#87afd7")
" command! -nargs=0 ColorschemeTokyoNight           :let g:tokyonight_style = "night" | call s:SetTheme("tokyonight-night", "dark", "#414c61", "#87afd7")
" command! -nargs=0 ColorschemeTokyoStorm           :let g:tokyonight_style = "storm" | call s:SetTheme("tokyonight-storm", "dark", "#414c61", "#87afd7")
" command! -nargs=0 ColorschemeTokyoDay             :let g:tokyonight_style = "day"   | call s:SetTheme("tokyonight-day", "light", "#cdcdcd", "#87afd7")
" command! -nargs=0 ColorschemeTokyoMoon            :let g:tokyonight_style = "moon"  | call s:SetTheme("tokyonight-moon", "dark", "#414c61", "#87afd7")
command! -nargs=0 ColorschemeTokyoNight           :let g:tokyonight_style = "night" | call s:SetTheme("mytokyonight", "dark", "#414c61", "#87afd7")
command! -nargs=0 ColorschemeTokyoStorm           :let g:tokyonight_style = "storm" | call s:SetTheme("mytokyonight", "dark", "#414c61", "#87afd7")
command! -nargs=0 ColorschemeTokyoDay             :let g:tokyonight_style = "day"   | call s:SetTheme("mytokyonight", "light", "#cdcdcd", "#87afd7")
command! -nargs=0 ColorschemeTokyoMoon            :let g:tokyonight_style = "moon"  | call s:SetTheme("mytokyonight", "dark", "#414c61", "#87afd7")
" command! -nargs=0 ColorschemeOne :packadd one | set background=dark | let g:blinds_guibg = "#414c61" | colorscheme one | let g:lightline.colorscheme = "one" | call lightline#init() | call lightline#update() | hi Cursor guibg=#87afd7
" command! -nargs=0 ColorschemeOneLight :packadd one | set background=light | let g:blinds_guibg = "#cdcdcd" | colorscheme one | let g:lightline.colorscheme = "PaperColor" | call lightline#init() | call lightline#update() | hi Cursor guibg=#87afd7

command -nargs=0 -bang ColorschemeAuto call AutoSetColorscheme("<bang>")
if exists("g:colorscheme_auto_set") && g:colorscheme_auto_set
  au VimEnter * ColorschemeAuto!
endif
