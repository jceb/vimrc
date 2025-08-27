local map = vim.keymap.set
return {
  -- https://github.com/tomtom/tcomment_vim
  "tomtom/tcomment_vim",
  name = "tcomment",
  keys = { { "n", "gc" }, { "v", "gc" }, { "n", "gcc" }, { "i", "<C-c>" } },
  init = function()
    vim.g.tcomment_maps = 0
    -- vim.g.tcomment_mapleader1 = ""
    -- vim.g.tcomment_mapleader2 = ""
  end,
  config = function()
    vim.cmd([[
                     function! InsertCommentstring()
                         let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
                         let col = col('.')
                         let line = line('.')
                         let g:ics_pos = [line, col + strlen(l)]
                         return l.r
                     endfunction
                     nmap <silent> gc <Plug>TComment_gc
                     xmap <silent> gc <Plug>TComment_gcb
                 ]])
    vim.cmd([[
                     function! ICSPositionCursor()
                         call cursor(g:ics_pos[0], g:ics_pos[1])
                         unlet g:ics_pos
                     endfunction
                 ]])

    map("i", "<C-c>", "<C-r>=InsertCommentstring()<CR><C-o>:call ICSPositionCursor()<CR>", { noremap = true })
  end,
}
