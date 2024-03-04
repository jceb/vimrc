map = vim.keymap.set
unmap = vim.keymap.unset

return {
  ----------------------
  -- file management
  ----------------------
  {
    -- https://github.com/nvim-tree/nvim-tree.lua
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = { "NvimTreeOpen", "NvimTreeToggle" },
    dependencies = {
      -- https://github.com/nvim-tree/nvim-web-devicons
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = false,
        hijack_netrw = false,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          ignore_list = { ".git", "node_modules", ".cache" },
        },
        actions = {
          open_file = {
            quit_on_open = false,
            -- quit_on_open = true,
            window_picker = {
              enable = false, -- open files in the previous window
            },
          },
        },
        renderer = {
          indent_markers = {
            enable = true,
          },
        },
      })
      local api = require("nvim-tree.api")
      vim.g.nvim_tree_bindings = {
        {
          key = { "<CR>", "o", "<2-LeftMouse>" },
          cb = api.node.open.edit,
        },
        { key = { "<2-RightMouse>", "<C-]>" }, cb = api.tree.change_root_to_node },
        { key = "<C-v>",                       cb = api.node.open.vertical },
        { key = "<C-x>",                       cb = api.node.open.horizontal },
        { key = "<C-t>",                       cb = api.node.open.tab },
        { key = "<",                           cb = api.node.navigate.sibling.prev },
        { key = ">",                           cb = api.node.navigate.sibling.next },
        { key = "P",                           cb = api.node.navigate.parent },
        { key = "<BS>",                        cb = api.tree.close },
        { key = "<S-CR>",                      cb = api.tree.close },
        { key = "<Tab>",                       cb = api.node.open.preview },
        { key = "K",                           cb = api.node.navigate.sibling.first },
        { key = "J",                           cb = api.node.navigate.sibling.last },
        { key = "I",                           cb = api.tree.toggle_gitignore_filter },
        { key = "H",                           cb = api.tree.toggle_hidden_filter },
        { key = "R",                           cb = api.tree.reload },
        { key = "a",                           cb = api.fs.create },
        { key = "d",                           cb = api.fs.remove },
        { key = "r",                           cb = api.fs.rename },
        { key = "<C-r>",                       cb = api.fs.full_rename },
        { key = "x",                           cb = api.fs.cut },
        { key = "c",                           cb = api.fs.copy },
        { key = "p",                           cb = api.fs.paste },
        { key = "y",                           cb = api.fs.copy.filename },
        { key = "Y",                           cb = api.fs.copy.relative_path },
        { key = "gy",                          cb = api.fs.copy.absolute_path },
        { key = "[c",                          cb = api.node.navigate.git.prev },
        { key = "]c",                          cb = api.node.navigate.git.next },
        { key = "-",                           cb = api.tree.change_root_to_parent },
        { key = "q",                           cb = api.tree.close },
        { key = "g?",                          cb = api.tree.toggle_help },
      }
    end,
  },
  {
    -- https://github.com/nvim-telescope/telescope.nvim
    "nvim-telescope/telescope.nvim",
    -- event = "VimEnter",
    dependencies = {
      -- -- https://github.com/nvim-lua/popup.nvim
      -- "nvim-lua/popup.nvim",
      -- https://github.com/nvim-lua/plenary.nvim
      "nvim-lua/plenary.nvim",
      {
        -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
        "nvim-telescope/telescope-fzf-native.nvim",
        build = { "make" },
        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      -- https://github.com/nvim-telescope/telescope-ui-select.nvim
      "nvim-telescope/telescope-ui-select.nvim",
      -- https://github.com/nvim-tree/nvim-web-devicons
      "nvim-tree/nvim-web-devicons",
      -- https://github.com/JoseConseco/telescope_sessions_picker.nvim
      "JoseConseco/telescope_sessions_picker.nvim",
      -- https://github.com/jceb/telescope_bookmark_picker.nvim
      "jceb/telescope_bookmark_picker.nvim",
      -- https://github.com/AckslD/nvim-neoclip.lua
      {
        "AckslD/nvim-neoclip.lua",
        config = function()
          require("neoclip").setup({
            history = 100,
            keys = {
              telescope = {
                i = {
                  paste = "<c-j>",
                },
              },
            },
          })
        end,
      },
    },
    -- lazy = true, -- FIXME opt doesn't work for some unknown reason
    cmd = { "Telescope" },
    keys = {
      "<leader>?",
      "<leader>b/",
      "<leader>bb",
      "<leader>bc",
      "<leader>be",
      "<leader>bh",
      "<leader>bl",
      "<leader>bm",
      "<leader>bs",
      "<leader>f/",
      "<leader>FB",
      "<leader>fb",
      "<leader>fC",
      "<leader>fd",
      "<leader>FF",
      "<leader>ff",
      "<leader>ff",
      "<leader>FG",
      "<leader>fg",
      "<leader>fh",
      "<leader>fk",
      "<leader>fka",
      "<leader>fkd",
      "<leader>fl",
      "<leader>fm",
      "<leader>fo",
      "<leader>fq",
      "<leader>fr",
      "<leader>fr",
      "<leader>fs",
      "<leader>fv",
      "<leader>fw",
      "<leader>gb",
      "<leader>gf",
      "<leader>gh",
      "<leader>PG",
      "<leader>ss",
      "<Space>gS",
      "<Space>PF",
      "<Space>Pf",
      "<Space>pF",
      "<Space>pf",
      "<Space>pV",
    },
    config = function()
      local actions = require("telescope.actions")
      -- local sorters = require("telescope.sorters")
      -- local trouble = require("trouble.providers.telescope")
      -- Global remapping
      ------------------------------
      require("telescope").load_extension("fzf")
      -- require("telescope").load_extension("neoclip")
      require("telescope").setup({
        defaults = {
          -- file_ignore_patterns = {
          --     ".git/",
          --     "%.bak",
          -- },
          mappings = {
            i = {
              ["<c-x>"] = false,
              ["<C-s>"] = actions.file_split,
              ["<esc>"] = actions.close,
              -- ["<c-t>"] = trouble.open_with_trouble,
            },
            n = {
              ["<esc>"] = actions.close,
              -- ["<c-t>"] = trouble.open_with_trouble,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
          sessions_picker = {
            sessions_dir = vim.env.HOME .. "/.sessions/",
          },
          bookmark_picker = {},
        },
      })
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("sessions_picker")
      require("telescope").load_extension("bookmark_picker")
      require("telescope").load_extension("neoclip")
      vim.cmd("highlight link TelescopeMatching IncSearch")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
      vim.keymap.set("n", "<leader>FG",
        "<cmd>exec 'Telescope live_grep cwd='.fnameescape(substitute(expand('%:h'), 'oil://', '', ''))<CR>",
        { noremap = true })
      vim.keymap.set("n", "<leader>PG", "<cmd>exec 'Telescope live_grep cwd='.fnameescape(GetRootDir())<CR>",
        { noremap = true })
      vim.keymap.set("n", "<Space>pg", "<cmd>exec 'Telescope live_grep cwd='.fnameescape(GetRootDir(getcwd()))<CR>",
        { noremap = true })
      -- Also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set("n", "<leader>f/",
        function() builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files", }) end,
        { desc = "[F]ind [/] in Open Files" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
      vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
      vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[F]ind [Old] Files" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind existing [B]uffers" })
      vim.keymap.set("n", "<leader>bb", builtin.buffers, { desc = "[F]ind existing [B]uffers" })
      vim.keymap.set(
        "n",
        "<leader>fc",
        "<cmd>Telescope find_files find_command=['rg','--files','--hidden','--ignore-vcs','--glob=!.git'] hidden=true cwd=~/.config/<CR>",
        { noremap = true }
      )
      -- vim.keymap.set("n", "<leader>FE", "<cmd>exec 'Telescope file_browser cwd='.fnameescape(expand('%:h'))<CR>", { noremap = true })
      -- vim.keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser<CR>", { noremap = true })
      vim.keymap.set(
        "n",
        "<leader>FF",
        '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=\'.fnameescape(substitute(expand("%:h"), "oil://", "", ""))<CR>',
        { noremap = true }
      )
      vim.keymap.set(
        "n",
        "<leader>FB",
        -- TODO: find file in base directory
        '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=\'.fnameescape(substitute(expand("%:h"), "oil://", "", ""))<CR>',
        { noremap = true }
      )
      vim.keymap.set(
        "n",
        "<leader>ff",
        "<cmd>Telescope find_files find_command=['rg','--files','--hidden','--ignore-vcs','--glob=!.git'] hidden=true<CR>",
        { noremap = true }
      )
      vim.keymap.set("n", "<leader>fl", "<cmd>Telescope loclist<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>fm", ":<C-u>Move %", { noremap = true })
      -- vim.keymap.set("n", "<leader>fo", "<cmd>Telescope find_files find_command=['rg','--files','--hidden','--ignore-vcs','--glob=!.git'] hidden=true cwd=~/.config/<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>fr", "<cmd>Telescope neoclip<CR>", { noremap = true })
      -- vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { noremap = true })
      vim.keymap.set(
        "n",
        "<leader>fv",
        "<cmd>Telescope find_files find_command=['rg','--files','--hidden','--ignore-vcs','--glob=!.git'] hidden=true cwd=~/.config/nvim/<CR>",
        { noremap = true }
      )

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>b/", function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- Shortcut for searching your neovim configuration files
      vim.keymap.set("n", "<leader>fv", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[F]ind Neo[V]im files" })
      vim.keymap.set("n", "<Space>gS", "<cmd>Telescope git_status<CR>", { noremap = true })
      -- vim.keymap.set("n", "<Space>PE", "<cmd>exec 'Telescope file_browser cwd='.fnameescape(GetRootDir())<CR>", { noremap = true })
      -- vim.keymap.set( "n", "<Space>pe", "<cmd>exec 'Telescope file_browser cwd='.fnameescape(GetRootDir(getcwd()))<CR>", { noremap = true })
      vim.keymap.set(
        "n",
        "<Space>PF",
        '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=\'.fnameescape(GetRootDir())<CR>',
        { noremap = true }
      )
      vim.keymap.set(
        "n",
        "<Space>Pf",
        '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=\'.fnameescape(GetRootDir())<CR>',
        { noremap = true }
      )
      vim.keymap.set(
        "n",
        "<Space>pF",
        '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=\'.fnameescape(GetRootDir())<CR>',
        { noremap = true }
      )
      vim.keymap.set(
        "n",
        "<Space>pf",
        '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=\'.fnameescape(GetRootDir(getcwd()))<CR>',
        {
          noremap = true,
        }
      )
      vim.keymap.set(
        "n",
        "<Space>pV",
        '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=~/.config/nvim\'<CR>',
        { noremap = true }
      )
      vim.keymap.set("n", "<leader>ss", "<cmd>Telescope sessions_picker<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>fC", "<cmd>Telescope commands<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>?", "<cmd>Telescope man_pages<CR>", { noremap = true })
      vim.keymap.set(
        "n",
        "<leader>bc",
        "<cmd>exec 'Telescope git_bcommits cwd='.fnameescape(substitute(expand('%:h'), 'oil://', '', ''))<CR>",
        { noremap = true }
      )
      vim.keymap.set("n", "<leader>be", "<cmd>Telescope lsp_document_diagnostics<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>bh", "<cmd>Telescope git_bcommits<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>bl", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>bm", "<cmd>Telescope bookmark_picker<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>bs", "<cmd>Telescope lsp_document_symbols<CR>", { noremap = true })
      -- vim.keymap.set("n", "<leader>bt", "<cmd>Telescope current_buffer_tags<CR>", { noremap = true })
      -- vim.keymap.set("n", "<leader>bv", "<cmd>Telescope treesitter<CR>", { noremap = true })
      vim.keymap.set(
        "n",
        "<leader>gb",
        "<cmd>exec 'Telescope git_branches cwd='.fnameescape(substitute(expand('%:h'), 'oil://', '', ''))<CR>",
        { noremap = true }
      )
      vim.keymap.set("n", "<leader>gf", "<cmd>Telescope git_files<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>gh", "<cmd>Telescope git_commits<CR>", { noremap = true })
    end,
  },
  {
    -- https://github.com/stevearc/oil.nvim
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Oil" },
    keys = { "-" },
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
      })
      map("n", "-", ":Oil<CR>", {})
    end,
  },
  -- {
  --   -- https://github.com/justinmk/vim-dirvish
  --   "justinmk/vim-dirvish",
  --   -- dependencies = {
  --   --     -- https://github.com/bounceme/remote-viewer
  --   --     "bounceme/remote-viewer",
  --   -- },
  --   -- lazy = true,
  --   -- cmd = { "Dirvish" },
  --   -- keys = { "<Plug>(dirvish_up)", "-" },
  --   init = function()
  --     vim.g.dirvish_mode = [[ :sort ,^.*[\/], ]]
  --
  --     vim.g.netrw_browsex_viewer = "xdg-open-background"
  --     local opts = { noremap = true, silent = true }
  --     map(
  --       "n",
  --       "<Plug>NetrwBrowseX",
  --       ':call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : "<cfile>")),netrw#CheckIfRemote())<CR>',
  --       opts
  --     )
  --     map("n", "gx", "<Plug>NetrwBrowseX", {})
  --     map("v", "<Plug>NetrwBrowseXVis", ":<c-u>call netrw#BrowseXVis()<CR>", opts)
  --     map("v", "gx", "<Plug>NetrwBrowseXVis", {})
  --     map("n", "-", "<Plug>(dirvish_up)", {})
  --
  --     vim.cmd("command! -nargs=? -complete=dir Explore Dirvish <args>")
  --     vim.cmd("command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>")
  --     vim.cmd("command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>")
  --   end,
  --   config = function()
  --     vim.cmd([[
  --                     augroup my_dirvish_events
  --                     autocmd!
  --                     " Map t to "open in new tab".
  --                     autocmd FileType dirvish  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>|xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
  --                     " Enable :Gstatus and friends.
  --                     " autocmd FileType dirvish call fugitive#detect(@%)
  --
  --                     " Map `gh` to hide dot-prefixed files.
  --                     " To "toggle" this, just press `R` to reload.
  --                     autocmd FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>
  --                     " autocmd FileType dirvish nnoremap <buffer> <space>e :e %/
  --                     autocmd FileType dirvish nnoremap <buffer> <space>ck :e %/kustomization.yaml
  --                     autocmd FileType dirvish nnoremap <buffer> <space>cR :e %/README.md
  --                     autocmd FileType dirvish nnoremap <buffer> % :e %/
  --                     augroup END
  --                     ]])
  --   end,
  -- },
}
