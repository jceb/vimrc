map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  ----------------------
  -- ftplugins
  ----------------------
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
    lazy = true,
    ft = { "just" },
  },
  {
    -- https://github.com/cuducos/yaml.nvim
    "cuducos/yaml.nvim",
    lazy = true,
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
  --     lazy = true,
  --     ft = { "solidity" },
  -- },
  -- {
  --     -- https://github.com/posva/vim-vue
  --     "posva/vim-vue", lazy = true, ft = { "vue" } },
  {
    -- https://github.com/asciidoc/vim-asciidoc
    "asciidoc/vim-asciidoc",
    lazy = true,
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
    lazy = true,
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
  --     lazy = true,
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
  {
    -- https://github.com/dag/vim-fish
    "dag/vim-fish",
    lazy = true,
    ft = { "fish" },
  },
  {
    -- https://github.com/LhKipp/nvim-nu
    "LhKipp/nvim-nu",
    lazy = true,
    ft = { "nu" },
    config = function()
      require("nu").setup({
        use_lsp_features = true, -- requires https://github.com/jose-elias-alvarez/null-ls.nvim
        -- lsp_feature: all_cmd_names is the source for the cmd name completion.
        -- It can be
        --  * a string, which is interpreted as a shell command and the returned list is the source for completions (requires plenary.nvim)
        --  * a list, which is the direct source for completions (e.G. all_cmd_names = {"echo", "to csv", ...})
        --  * a function, returning a list of strings and the return value is used as the source for completions
        all_cmd_names = [[nu -c 'help commands | get name | str join "\n"']],
      })
    end,
  },
  -- {
  --     -- https://github.com/jparise/vim-graphql
  --     "jparise/vim-graphql",
  --     lazy = true,
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
  --     "leafOfTree/vim-svelte-plugin", lazy = true, ft = { "svelte" } },
  {
    -- https://github.com/towolf/vim-helm
    "towolf/vim-helm",
    lazy = true,
    ft = { "yaml" },
  },
  {
    -- https://github.com/aklt/plantuml-syntax
    "aklt/plantuml-syntax",
    lazy = true,
    ft = { "plantuml" },
  },
  {
    -- https://github.com/tpope/vim-markdown
    "tpope/vim-markdown",
    lazy = true,
    ft = { "markdown" },
  },
  {
    -- https://github.com/hashivim/vim-terraform
    "hashivim/vim-terraform",
    lazy = true,
    ft = { "terraform" },
    init = function()
      vim.g.terraform_fmt_on_save = 1
      vim.g.terraform_fold_sections = 1
      vim.g.markdown_fenced_languages = {
        "bash=sh",
        "css",
        "html",
        "javascript",
        "json",
        "python",
        "yaml",
      }
    end,
  },
  -- {
  --     -- https://github.com/sukima/vim-tiddlywiki
  --     "sukima/vim-tiddlywiki", lazy = true, ft = { "tiddlywiki" } },
  {
    -- https://github.com/iamcco/markdown-preview.nvim
    "iamcco/markdown-preview.nvim",
    build = { "cd app; yarn install" },
    lazy = true,
    ft = { "markdown" },
    config = function()
      vim.cmd("doau BufEnter")
    end,
  },
  -- {
  --     -- https://github.com/mustache/vim-mustache-handlebars
  --     "mustache/vim-mustache-handlebars",
  --     lazy = true,
  --     ft = { "mustache" },
  -- },
}
