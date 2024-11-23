return {
  -- https://github.com/numToStr/Comment.nvim
  "numToStr/Comment.nvim",
  dependencies = {
    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  keys = {
    { "gcc" },
    { "gc" },
    { "gc", mode = "v" },
    { "gb" },
    { "gb", mode = "v" },
    { "<C-c>", mode = "i" },
  },
  config = function()
    require("Comment").setup({
      -- @param ctx Ctx
      pre_hook = function(ctx)
        -- Only calculate commentstring for tsx filetypes
        if
          vim.bo.filetype == "typescriptreact"
          or vim.bo.filetype == "tyescriptjsx"
          or vim.bo.filetype == "javascriptreact"
          or vim.bo.filetype == "javascriptjsx"
        then
          local U = require("Comment.utils")

          -- Detemine whether to use linewise or blockwise commentstring
          local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

          -- Determine the location where to calculate commentstring from
          local location = nil
          if ctx.ctype == U.ctype.block then
            location = require("ts_context_commentstring.utils").get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require("ts_context_commentstring.utils").get_visual_start_location()
          end

          return require("ts_context_commentstring.internal").calculate_commentstring({
            key = type,
            location = location,
          })
        end
      end,
    })
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
    map("i", "<C-c>", "<C-r>=InsertCommentstring()<CR><C-o>:call ICSPositionCursor()<CR>", { noremap = true })
  end,
}
