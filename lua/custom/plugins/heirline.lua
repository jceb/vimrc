return {
  -- https://github.com/rebelot/heirline.nvim
  "rebelot/heirline.nvim",
  dependencies = {
    -- https://github.com/nvim-tree/nvim-web-devicons
    "nvim-tree/nvim-web-devicons",
    -- https://github.com/SmiteshP/nvim-navic
    -- moved to lspconfig
    -- "SmiteshP/nvim-navic",
  },
  config = function()
    require("heirline").setup(require("custom.plugins.statusline.config").config)
    vim.cmd([[
      nnoremap <unique> <A-1> 1gt
      nnoremap <unique> <A-2> 2gt
      nnoremap <unique> <A-3> 3gt
      nnoremap <unique> <A-4> 4gt
      nnoremap <unique> <A-5> 5gt
      nnoremap <unique> <A-6> 6gt
      nnoremap <unique> <A-7> 7gt
      nnoremap <unique> <A-8> 8gt
      nnoremap <unique> <A-9> 9gt
      nnoremap <unique> <A-0> 10gt

      nnoremap <unique> <A-h> gT
      nnoremap <unique> <A-l> gt
      nnoremap <silent> <A-H> :call LiteTabMove(-2)<CR>
      nnoremap <silent> <A-L> :call LiteTabMove(1)<CR>

      function! LiteTabMove(idx)
          let index = tabpagenr() + a:idx
          if (index < 0)
              return
          endif
          silent execute 'tabmove ' . index
      endfunction
      ]])
  end,
}
