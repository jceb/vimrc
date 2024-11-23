return {
  -- https://github.com/nvim-treesitter/nvim-treesitter
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    "JoosepAlviste/nvim-ts-context-commentstring",
    -- -- https://github.com/nvim-treesitter/nvim-treesitter-context
    -- "nvim-treesitter/nvim-treesitter-context",
    -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    -- "nvim-treesitter/nvim-treesitter-textobjects"
    -- {
  },
  config = function()
    -- Workaround for broken parsers https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#troubleshooting
    -- Enable custom compilers if parsers fail to compile; some plugins
    -- require C++ others C
    -- require("nvim-treesitter.install").compilers = { "clang" }
    -- require("nvim-treesitter.install").compilers = { "clang++", "clang" }
    vim.g.skip_ts_context_commentstring_module = true
    require("ts_context_commentstring").setup({})
    ---@diagnostic disable-next-line: missing-fields
    -- require("nvim-treesitter.install").prefer_git = true
    require("nvim-treesitter.configs").setup({
      -- integration with ./vim-matchup.lua plugin
      matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
      },
      ensure_installed = {
        "bash",
        "c",
        "go",
        "html",
        "javascript",
        "lua",
        "markdown",
        -- "nu",
        "python",
        "rust",
        "typescript",
        "vim",
        "vimdoc",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    })
    -- Enable support for rest.nvim https://github.com/NTBBloodbath/rest.nvim
    local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
    parser_configs.http = {
      install_info = {
        url = "https://github.com/NTBBloodbath/tree-sitter-http",
        files = { "src/parser.c" },
        branch = "main",
      },
    }
    parser_configs.just = {
      install_info = {
        url = "https://github.com/IndianBoy42/tree-sitter-just",
        -- url = "https://github.com/IndianBoy42/tree-sitter-just",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
      },
      -- filetype = "just",
      maintainers = { "@IndianBoy42" },
    }
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "nvim_treesitter#foldexpr()"
  end,
}
