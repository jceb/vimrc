map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  ----------------------
  -- development
  ----------------------
  -- {
  --   -- https://github.com/michaelrommel/nvim-silicon
  --   "michaelrommel/nvim-silicon",
  --   cmd = { "Silicon" },
  -- },
  {
    -- https://github.com/danymat/neogen
    "danymat/neogen",
    dependencies = {
      -- https://github.com/nvim-treesitter/nvim-treesitter
      "nvim-treesitter/nvim-treesitter" },
    cmd = { "Neogen" },
  },
  {
    -- https://github.com/stevearc/aerial.nvim
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle" },
    config = function()
      require("aerial").setup({})
    end,
  },
  -- {
  --     -- https://github.com/liuchengxu/vista.vim
  --     "liuchengxu/vista.vim",
  --     cmd = { "Vista" },
  --     config = function()
  --         vim.g.vista_sidebar_width = 50
  --     end,
  -- },
  -- {
  --     -- https://github.com/simrat39/symbols-outline.nvim
  --     "simrat39/symbols-outline.nvim",
  --     cmd = {
  --         "SymbolsOutline",
  --         "SymbolsOutlineOpen",
  --         "SymbolsOutlineClose",
  --     },
  -- },
  -- {
  --     -- https://github.com/mfussenegger/nvim-lint
  --     "mfussenegger/nvim-lint",
  --     config = function()
  --         vim.cmd([[
  --             au BufWritePost <buffer> lua require('lint').try_lint()
  --             au BufWritePost <buffer> markdown require('lint').try_lint()
  --             au BufWritePost <buffer> javascript,javascriptjsx require('lint').try_lint()
  --             au BufWritePost <buffer> typescript,typescriptjsx require('lint').try_lint()
  --             au BufWritePost <buffer> go require('lint').try_lint()
  --             au BufWritePost <buffer> html require('lint').try_lint()
  --         ]])
  --         require("lint").linters_by_ft = {
  --             asciidoc = { "value", "languagetool" },
  --             css = { "stylint" },
  --             dockerfile = { "hadolint" },
  --             go = { "golangcilint" },
  --             html = { "tidy", "stylint", "vale" },
  --             javascript = { "eslint" },
  --             javascriptjsx = { "eslint" },
  --             lua = { "luacheck" },
  --             markdown = { "stylint", "value", "languagetool" },
  --             nix = { "nix" },
  --             sh = { "shellcheck" },
  --             txt = { "languagetool" },
  --             typescript = { "eslint" },
  --             typescriptjsx = { "eslint" },
  --         }
  --     end,
  -- },
  {
    -- https://github.com/folke/trouble.nvim
    "folke/trouble.nvim",
    branch = "dev",
    cmd = { "Trouble" },
    keys = {
      {
        "<leader>,,",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      -- {
      --   "<leader>xX",
      --   "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      --   desc = "Buffer Diagnostics (Trouble)",
      -- },
      -- {
      --   "<leader>cs",
      --   "<cmd>Trouble symbols toggle focus=false<cr>",
      --   desc = "Symbols (Trouble)",
      -- },
      -- {
      --   "<leader>cl",
      --   "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      --   desc = "LSP Definitions / references / ... (Trouble)",
      -- },
      {
        "<leader>,l",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>,l",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    -- https://github.com/dbeniamine/cheat.sh-vim
    "dbeniamine/cheat.sh-vim",
    cmd = { "Cheat" },
    init = function()
      vim.g.CheatSheetDoNotMap = 1
      vim.g.CheatDoNotReplaceKeywordPrg = 1
    end,
  },
  {
    -- https://github.com/tpope/vim-characterize
    "tpope/vim-characterize",
    keys = { { "ga" } },
    config = function()
      map("n", "ga", "<Plug>(characterize)", {})
    end,
  },

  -- use ({
  --     -- https://github.com/raghur/vim-ghost
  --     "raghur/vim-ghost"})
  {
    -- https://github.com/rafcamlet/nvim-luapad
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad" },
  },
  -- {
  --     -- https://github.com/sakhnik/nvim-gdb
  --     "sakhnik/nvim-gdb",
  --     cmd = {
  --         "GdbStart",
  --         "GdbStartLLDB",
  --         "GdbStartPDB",
  --         "GdbStartBashDB",
  --         "GdbBreakpointToggle",
  --         "GdbUntil",
  --         "GdbContinue",
  --         "GdbNext",
  --         "GdbStep",
  --         "GdbFinish",
  --         "GdbFrameUp",
  --         "GdbFrameDown",
  --     },
  -- },
  -- use {'diepm/vim-rest-console', setup=function()
  --     vim.cmd([[
  --         augroup ft_rest
  --           au!
  --           au BufReadPost,BufNewFile *.rest		packadd rest-console|setf rest
  --         augroup END
  --         command! -nargs=0 Restconsole :packadd rest-console|if &ft != "rest"|new|set ft=rest|endif
  --         " let g:vrc_show_command = 1
  --         let g:vrc_show_command = 0
  --         let g:vrc_curl_opts = { '--connect-timeout' : 10, '-L': '', '-i': '', '--max-time': 60, '-k': '', '-sS': '', }
  --                     " \ '-v': '',
  --                     " \ '-H': 'accept: application/json',
  --         let g:vrc_auto_format_response_patterns = { 'json': 'jq .', 'xml': 'xmllint --format -', }
  --     ]])
  --
  -- end}
  {
    -- https://github.com/NTBBloodbath/rest.nvim
    "NTBBloodbath/rest.nvim",
    dependencies = {
      -- https://github.com/nvim-lua/plenary.nvim
      "nvim-lua/plenary.nvim",
      {
        -- https://github.com/vhyrro/luarocks.nvim
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
        opts = {
          rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
        }
      },
    },
    -- FIXMED: opt doesn't seem to work
    ft = { "http" },
    config = function()
      require("rest-nvim").setup()
      vim.cmd([[
        au FileType http nmap <buffer> <silent> <C-j> <Plug>RestNvim
        au FileType http nmap <buffer> <silent> <C-q> <Plug>RestNvimPreview
        ]])
    end,
  },
  -- {
  --     -- https://github.com/jceb/vim-hier
  --     "jceb/vim-hier",
  -- },
  -- {
}
