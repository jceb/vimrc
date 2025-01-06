return {
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
  cmd = { "Telescope" },
  keys = {
    "<leader>?",
    "<leader>b/",
    "<leader>bb",
    "<leader>bc",
    "<leader>be",
    "<leader>bH",
    "<leader>bl",
    "<leader>bm",
    "<leader>bs",
    "<leader>f/",
    "<leader>FB",
    "<leader>fb",
    "<leader>fc",
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
    "<leader>fo",
    "<leader>fq",
    "<leader>fr",
    "<leader>fr",
    "<leader>fs",
    "<leader>fv",
    "<leader>fw",
    "<leader>gb",
    "<leader>gf",
    "<leader>gH",
    "<leader>PG",
    "<leader>ss",
    "<leader>gS",
    "<leader>PF",
    "<leader>Pf",
    "<leader>pF",
    "<leader>pf",
    "<leader>pV",
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
        fzf = {},
      },
    })
    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("sessions_picker")
    require("telescope").load_extension("bookmark_picker")
    require("telescope").load_extension("neoclip")
    vim.cmd("highlight link TelescopeMatching IncSearch")

    local find_files_in_directory = function(directory)
      require("telescope.builtin").find_files({
        find_command = { "rg", "--files", "--hidden", "--ignore-vcs", "--glob=!.git" },
        cwd = directory,
        hidden = true,
      })
    end
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
    -- vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>fB", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
    vim.keymap.set("n", "<leader>FG", "<cmd>exec 'Telescope live_grep cwd='.fnameescape(substitute(expand('%:h'), 'oil://', '', ''))<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>PG", "<cmd>exec 'Telescope live_grep cwd='.fnameescape(GetRootDir())<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>pg", "<cmd>exec 'Telescope live_grep cwd='.fnameescape(GetRootDir(getcwd()))<CR>", { noremap = true })
    -- Also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>f/", function()
      builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
    end, { desc = "[F]ind [/] in Open Files" })
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
    vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[F]ind [Old] Files" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind existing [B]uffers" })
    vim.keymap.set("n", "<leader>bb", builtin.buffers, { desc = "[F]ind existing [B]uffers" })
    vim.keymap.set("n", "<leader>fc", function()
      find_files_in_directory(vim.fn.stdpath("config"))
    end, { noremap = true, desc = "[F]ind files in vim [C]onfig" })
    -- vim.keymap.set("n", "<leader>FE", "<cmd>exec 'Telescope file_browser cwd='.fnameescape(expand('%:h'))<CR>", { noremap = true })
    -- vim.keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>FF", function()
      find_files_in_directory(vim.fn.substitute(vim.fn.expand("%:h"), "oil://", "", ""))
    end, { noremap = true })
    vim.keymap.set(
      "n",
      "<leader>FB",
      -- TODO: find file in base directory
      function()
        find_files_in_directory(vim.fn.substitute(vim.fn.expand("%:h"), "oil://", "", ""))
      end,
      { noremap = true }
    )
    vim.keymap.set("n", "<leader>ff", function()
      find_files_in_directory(vim.fn.getcwd())
    end, { noremap = true, desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>fl", "<cmd>Telescope loclist<CR>", { noremap = true })
    -- vim.keymap.set("n", "<leader>fo", "<cmd>Telescope find_files find_command=['rg','--files','--hidden','--ignore-vcs','--glob=!.git'] hidden=true cwd=~/.config/<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>fr", "<cmd>Telescope neoclip<CR>", { noremap = true })
    -- vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { noremap = true })

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
      find_files_in_directory(vim.fn.stdpath("config"))
    end, { desc = "[F]ind Neo[V]im files" })
    vim.keymap.set("n", "<leader>gS", "<cmd>Telescope git_status<CR>", { noremap = true })
    -- vim.keymap.set("n", "<leader>PE", "<cmd>exec 'Telescope file_browser cwd='.fnameescape(GetRootDir())<CR>", { noremap = true })
    -- vim.keymap.set( "n", "<leader>pe", "<cmd>exec 'Telescope file_browser cwd='.fnameescape(GetRootDir(getcwd()))<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>PF", function()
      find_files_in_directory(vim.fn.GetRootDir())
    end, { noremap = true })
    vim.keymap.set("n", "<leader>Pf", function()
      find_files_in_directory(vim.fn.GetRootDir())
    end, { noremap = true })
    vim.keymap.set("n", "<leader>pF", function()
      find_files_in_directory(vim.fn.GetRootDir())
    end, { noremap = true })
    vim.keymap.set("n", "<leader>pf", function()
      find_files_in_directory(vim.fn.GetRootDir(vim.fn.getcwd()))
    end, {
      noremap = true,
    })
    vim.keymap.set("n", "<leader>ss", "<cmd>Telescope sessions_picker<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>fC", "<cmd>Telescope commands<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>?", "<cmd>Telescope man_pages<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>bc", function()
      require("telescope.builtin").git_bcommits({ cwd = vim.fn.substitute(vim.fn.expand("%:h"), "oil://", "", "") })
    end, { noremap = true })
    vim.keymap.set("n", "<leader>be", "<cmd>Telescope lsp_document_diagnostics<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>bH", "<cmd>Telescope git_bcommits<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>bl", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>bm", "<cmd>Telescope bookmark_picker<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>bs", "<cmd>Telescope lsp_document_symbols<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>ps", "<cmd>Telescope lsp_workspace_symbols<CR>", { noremap = true })
    -- vim.keymap.set("n", "<leader>bt", "<cmd>Telescope current_buffer_tags<CR>", { noremap = true })
    -- vim.keymap.set("n", "<leader>bv", "<cmd>Telescope treesitter<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>gb", function()
      require("telescope.builtin").git_branches({ cwd = vim.fn.substitute(vim.fn.expand("%:h"), "oil://", "", "") })
    end, { noremap = true })
    vim.keymap.set("n", "<leader>gf", "<cmd>Telescope git_files<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>gH", "<cmd>Telescope git_commits<CR>", { noremap = true })
  end,
}
