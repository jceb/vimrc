return {
  -- https://github.com/tpope/vim-commentary
  "tpope/vim-commentary",
  keys = {
    { "n", "gc" },
    { "v", "gc" },
    { "n", "gcc" },
    { "i", "<C-c>" },
  },
  config = function()
    vim.cmd([[
                    function! InsertCommentstring()
                        let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
                        let col = col('.')
                        let line = line('.')
                        let g:ics_pos = [line, col + strlen(l)]
                        return l.r
                    endfunction
                ]])
    vim.cmd([[
                    function! ICSPositionCursor()
                        call cursor(g:ics_pos[0], g:ics_pos[1])
                        unlet g:ics_pos
                    endfunction
                ]])
    vim.keymap.set("i", "<C-c>", "<C-r>=InsertCommentstring()<CR><C-o>:call ICSPositionCursor()<CR>", { noremap = true })
  end,
}
