map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  ----------------------
  -- misc
  ----------------------
  -- {
  --     -- https://github.com/lewis6991/impatient.nvim
  --     "lewis6991/impatient.nvim",
  --     config = function()
  --         -- To profile the cache run :LuaCacheProfile
  --         -- require("impatient").enable_profile()
  --         require("impatient")
  --     end,
  -- },
  {
    -- https://github.com/glacambre/firenvim
    "glacambre/firenvim",
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    config = function()
      vim.cmd([[
        if exists('g:started_by_firenvim')
          set laststatus=0
          set showtabline=0
          set nonumber norelativenumber
          " au BufEnter *.txt set filetype=markdown

          let g:firenvim_config = { 'globalSettings': { 'alt': 'all', }, 'localSettings': { '.*': { 'cmdline': 'firenvim', 'priority': 0, 'selector': 'textarea', 'takeover': 'never', }, } }
          let fc = g:firenvim_config['localSettings']
          let fc['https?://[^/]*twitter\.com/'] = { 'takeover': 'never', 'priority': 1 }
          let fc['https?://[^/]*trello\.com/'] = { 'takeover': 'never', 'priority': 1 }
        else
          set laststatus=2
          " set laststatus=3
          endif
          ]])
    end,
  },
  {
    -- https://github.com/equalsraf/neovim-gui-shim
    "equalsraf/neovim-gui-shim",
  },
  --     -- https://github.com/sjl/gundo.vim
  --     "sjl/gundo.vim",
  -- },
}
