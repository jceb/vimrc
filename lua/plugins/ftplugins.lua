map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  ----------------------
  -- ftplugins
  ----------------------
  {
    -- https://github.com/davidmh/mdx.nvim
    "davidmh/mdx.nvim",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" }
  },
  {
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
  },
  {
    -- https://github.com/tpope/vim-sleuth
    -- Detects settings
    "tpope/vim-sleuth",
  },
  {
    -- https://github.com/wuelnerdotexe/vim-astro
    "wuelnerdotexe/vim-astro",
  },
  {
    -- https://github.com/isobit/vim-caddyfile
    "isobit/vim-caddyfile",
  },
  {
    -- https://github.com/direnv/direnv.vim
    "direnv/direnv.vim",
  },
  {
    -- https://github.com/tpope/vim-apathy
    "tpope/vim-apathy",
  },
  -- {
  --     -- https://github.com/nathom/filetype.nvim
  --     "nathom/filetype.nvim",
  -- },
  -- {
  --     -- https://github.com/jceb/yaml-path
  --     "jceb/yaml-path",
  --     build = { "go install" },
  -- },
  -- {
  --     -- https://github.com/terrastruct/d2-vim
  --     "terrastruct/d2-vim",
  -- },
  {
    -- https://github.com/NoahTheDuke/vim-just.git
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },
  {
    -- https://github.com/cuducos/yaml.nvim
    "cuducos/yaml.nvim",
    ft = { "yaml" }, -- optional
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
    },
  },
  -- {
  --     -- https://github.com/google/vim-jsonnet
  --     "google/vim-jsonnet",
  -- },
  -- {
  --     -- https://github.com/jceb/emmet.snippets
  --     "jceb/emmet.snippets",
  --     lazy = true,
  -- },
  -- {
  --     -- https://github.com/tomlion/vim-solidity
  --     "tomlion/vim-solidity",
  --     ft = { "solidity" },
  -- },
  -- {
  --     -- https://github.com/posva/vim-vue
  --     "posva/vim-vue",
  --     ft = { "vue" } },
  {
    -- https://github.com/asciidoc/vim-asciidoc
    "asciidoc/vim-asciidoc",
    ft = { "asciidoc" },
  },
  {
    -- https://github.com/ray-x/go.nvim
    "ray-x/go.nvim",
    dependencies = {
      {
        -- https://github.com/ray-x/guihua.lua
        "ray-x/guihua.lua",
        -- build = { "cd lua/fzy; make" },
      },
    },
    ft = { "go" },
    build = { ":GoUpdateBinaries" },
    config = function()
      -- TODO: integrate debugging: https://github.com/ray-x/go.nvim#debug-with-dlv
      require("go").setup({})
      vim.cmd([[
        " nmap <C-]> gd
        au Filetype go
        \  exec "command! -bang A GoAlt"
        \ | exec "command! -bang AV GoAltV"
        \ | exec "command! -bang AS GoAltS"
        ]])
    end,
  },
  -- {
  --     -- https://github.com/fatih/vim-go
  --     "fatih/vim-go",
  --     ft = { "go" },
  --     build = { ":GoUpdateBinaries" },
  --     config = function()
  --         vim.cmd([[
  --         nmap grd <Plug>(go-referrers)
  --         ]])
  --         vim.cmd([[
  --           au Filetype go
  --                 \  exec "command! -bang A call go#alternate#Switch(<bang>0, 'edit')"
  --                 \| exec "command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')"
  --                 \| exec "command! -bang AS call go#alternate#Switch(<bang>0, 'split')"
  --         ]])
  --     end,
  -- },
  -- {
  --   -- https://github.com/dag/vim-fish
  --   "dag/vim-fish",
  --   ft = { "fish" },
  -- },
  -- {
  --   -- https://github.com/LhKipp/nvim-nu
  --   "LhKipp/nvim-nu",
  --   ft = { "nu" },
  --   config = function()
  --     require("nu").setup({
  --       use_lsp_features = true, -- requires https://github.com/jose-elias-alvarez/null-ls.nvim
  --       -- lsp_feature: all_cmd_names is the source for the cmd name completion.
  --       -- It can be
  --       --  * a string, which is interpreted as a shell command and the returned list is the source for completions (requires plenary.nvim)
  --       --  * a list, which is the direct source for completions (e.G. all_cmd_names = {"echo", "to csv", ...})
  --       --  * a function, returning a list of strings and the return value is used as the source for completions
  --       all_cmd_names = [[nu -c 'help commands | get name | str join "\n"']],
  --     })
  --   end,
  -- },
  -- {
  --     -- https://github.com/jparise/vim-graphql
  --     "jparise/vim-graphql",
  --     ft = {
  --         "javascript",
  --         "javascriptreact",
  --         "typescript",
  --         "typescriptreact",
  --         "vue",
  --         "php",
  --         "reason",
  --     },
  -- },
  -- {
  --     -- https://github.com/leafOfTree/vim-svelte-plugin
  --     "leafOfTree/vim-svelte-plugin",
  --     ft = { "svelte" } },
  {
    -- https://github.com/towolf/vim-helm
    "towolf/vim-helm",
    ft = { "yaml" },
  },
  {
    -- https://github.com/aklt/plantuml-syntax
    "aklt/plantuml-syntax",
    ft = { "plantuml" },
  },
  -- {
  --   -- https://github.com/tpope/vim-markdown
  --   "tpope/vim-markdown",
  --   ft = { "markdown" },
  --   config = function()
  --     vim.g.markdown_fenced_languages = {
  --       "bash=sh",
  --       "css",
  --       "html",
  --       "javascript",
  --       "json",
  --       "python",
  --       "yaml",
  --       "nu",
  --     }
  --   end,
  -- },
  {
    -- https://github.com/ixru/nvim-markdown.git
    "ixru/nvim-markdown",
    ft = { "markdown" },
    -- config = function()
    -- end,
    init = function()
      vim.g.vim_markdown_conceal = 0 -- disable concealing of text
      vim.g.vim_markdown_frontmatter = 1
      vim.g.markdown_fenced_languages = {
        "bash=sh",
        "css",
        "html",
        "javascript",
        "json",
        "python",
        "yaml",
        "toml",
        "nu",
      }
    end,
  },
  {
    -- https://github.com/quarto-dev/quarto-nvim
    "quarto-dev/quarto-nvim",
    cmd = { "QuartoPreview", "QuartoActivate" },
  },
  {
    -- https://github.com/hashivim/vim-terraform
    "hashivim/vim-terraform",
    ft = { "terraform" },
    init = function()
      vim.g.terraform_fmt_on_save = 1
      vim.g.terraform_fold_sections = 1
    end,
  },
  -- {
  --     -- https://github.com/sukima/vim-tiddlywiki
  --     "sukima/vim-tiddlywiki", lazy = true, ft = { "tiddlywiki" } },
  {
    -- https://github.com/iamcco/markdown-preview.nvim
    "iamcco/markdown-preview.nvim",
    build = { "cd app; yarn install" },
    ft = { "markdown" },
    config = function()
      vim.cmd("doau BufEnter")
    end,
  },
  -- {
  --     -- https://github.com/mustache/vim-mustache-handlebars
  --     "mustache/vim-mustache-handlebars",
  --     ft = { "mustache" },
  -- },
}
