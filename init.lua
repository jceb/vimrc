-- disable neovide cursor animation
vim.g.neovide_cursor_animation_length = 0

-- disable unused providers
vim.g.loaded_python3_provider = 1
vim.g.loaded_perl_provider = 1
vim.g.loaded_ruby_provider = 1
vim.g.loaded_node_provider = 1

require("keybindings")

-- Disable builtin plugins that are not needed
local disabled_built_ins = {
  "2html_plugin",
  "crefvim",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "matchit",
  "netrw", -- TODO: not quite sure of how to use dirvish but still use netrw for remote file access
  "netrwFileHandlers",
  "netrwPlugin",
  "netrwSettings",
  "rrhelper",
  "spellfile_plugin",
  "tar",
  "tarPlugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
vim.g.no_mail_maps = 1

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
-- vim.opt.smartcase = true
vim.opt.smartcase = false -- smart case search (I don't like it that much since it makes * and # much harder to use)

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
-- vim.opt.signcolumn = 'auto' -- display signs in separate column

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Miscellaneous Settings:
-- -----------------------

vim.opt.commentstring = "#%s" -- set default comment string to octothorpe
vim.opt.comments = "b:#,fb:-,fb:*" -- Remove some legacy and C comment strings
vim.opt.path = ".,," -- limit path
vim.opt.swapfile = true -- write swap files
vim.opt.directory = vim.fn.expand("~/.cache/nvim/swap//") -- place swap files outside the current directory
vim.opt.backup = true -- write backup copies
vim.opt.backupdir = vim.fn.expand("~/.cache/nvim/backup//") -- place swap files outside the current directory
vim.opt.writebackup = true -- write backup before writing a file
vim.opt.backupcopy = "yes" -- overwrite the original file when modifying it - the default "auto" might break the inotify/watch commands
vim.opt.gdefault = true -- substitute all matches by default
vim.opt.magic = true -- special characters that can be used in search patterns
vim.opt.hidden = true -- allow hidden buffers with modifications
vim.opt.whichwrap = "<,>" -- Cursor key move the cursor to the next/previous line if pressed at the end/beginning of a line
vim.opt.backspace = "indent,eol,start" -- more powerful backspacing
vim.opt.grepprg = "rg --vimgrep" -- use ripgrep

-- Suffixes that get lower priority when doing tab completion for filenames.
-- These are files we are not likely to want to edit or read.
vim.opt.suffixes = {
  ".bak",
  "~",
  ".swp",
  ".o",
  ".info",
  ".aux",
  ".log",
  ".dvi",
  ".bbl",
  ".blg",
  ".brf",
  ".cb",
  ".ind",
  ".idx",
  ".ilg",
  ".inx",
  ".out",
  ".toc",
  ".pdf",
  ".exe",
}
vim.opt.sessionoptions:remove({
  "options", -- do not store global and local values in a session
  "folds", -- do not store folds
})

vim.opt.switchbuf = "usetab" -- This option controls the behavior when switching between buffers.
-- set nottimeout                 -- if terminal sends 0x9b ttimeout can be disabled
-- vim.opt.printoptions = "paper:a4,syntax:n" -- controls the default paper size and the printing of syntax highlighting (:n -> none)
-- let mapleader='\'              -- change map leader to a key that's more convenient to reach
vim.opt.updatetime = 300 -- timeout for triggering the CursorHold auto command

-- enable persistent undo
vim.opt.undodir = vim.fn.expand("~/.cache/nvim/undo//")
vim.opt.undofile = true
if not vim.fn.isdirectory(vim.o.undodir) then
  vim.fn.mkdir(vim.o.undodir, "p")
end

-- play nicely with fish and nu shell
vim.opt.shell = "bash"

-- Visual Settings:
-- ----------------

vim.opt.shortmess:append("c") -- don't show matching messages
vim.opt.lazyredraw = true -- draw screen updates lazily
vim.opt.showmatch = true -- highlight mathing brackets
vim.opt.hlsearch = false -- don't highlight search results by default as I'm using them to navigate around
-- disable search when redrawing the screen
vim.keymap.set(
  "n",
  "<C-l>",
  ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><Bar>redraw!<Bar>syntax sync fromstart<CR>",
  { silent = true, noremap = true }
)

vim.opt.wrap = false -- don't wrap long lines by default
vim.opt.mouse = "a" -- Enable the use of a mouse
vim.opt.cursorline = true -- Don't show cursorline
vim.opt.errorbells = false -- disable error bells
vim.opt.visualbell = false -- disable beep
vim.opt.wildmode = "list:longest,full" -- Don't start wildmenu immediately but list the alternatives first and then do the completion if the user requests it by pressing wildkey repeatedly
vim.opt.wildignore:remove({ "tmp" })
vim.opt.wildignore:append({
  "*.DS_STORE",
  "*~",
  "*.bak",
  "*.o",
  "*.obj",
  "*.pyc",
  ".git",
  ".svn",
  ".hg",
  "node_modules",
  ".pc",
})
-- set wildcharm=<C-Z>            -- Shortcut to open the wildmenu when you are in the command mode - it's similar to <C-D>
vim.opt.guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20,a:blinkon0-Cursor/lCursor" -- cursor-blinking off!!
vim.opt.foldenable = false -- start editing with all folds open
vim.opt.foldmethod = "indent" -- Use indent for folding by default
-- set foldminlines=0             -- number of lines above which a fold can be displayed
vim.opt.linebreak = true -- If on Vim will wrap long lines at a character in 'breakat'
vim.opt.breakindent = true -- indent wrapped lines visually
vim.opt.showtabline = 2 -- always show tabline, even if there is just one tab, avoid redraw problems when Window is displayed in fullscreen mode
-- set foldcolumn=1               -- show folds
vim.opt.colorcolumn = "+1" -- color specified column in order to help respecting line widths
vim.opt.termguicolors = true -- true color for the terminal
vim.opt.completeopt = { "menu", "menuone", "preview", "noinsert", "noselect" } -- show the complete menu even if there is just one entry

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- list nonprintable characters
vim.opt.showbreak = "↪  " -- identifier put in front of wrapped lines
vim.opt.fillchars = { vert = " ", diff = "·", fold = "·", eob = " " } -- get rid of the gab between the vertical bars
-- vim.opt.fillchars = { vert = "│", diff = "·", fold = "·", eob = " " } -- get rid of the gab between the vertical bars
vim.opt.scrolloff = 3 -- Minimal number of screen lines to keep above and below the cursor.
-- vim.opt.guioptions = "aegimtc" -- disable scrollbars
vim.opt.cpoptions = "aABceFsq" -- q: When joining multiple lines leave the cursor at the position where it would be when joining two lines.
-- $:  When making a change to one line, don't redisplay the line, but put a '$' at the end of the changed text.
-- v: Backspaced characters remain visible on the screen in Insert mode.
-- J: a sentence is followed by two spaces
-- set synmaxcol=200              -- stop syntax highlighting at a certain column to improve speed

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

vim.opt.report = 0 -- report every changed line

-- Text Settings:
-- --------------

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'
vim.opt.clipboard:remove({ "autoselect" }) -- disable itegration with X11 clipboard
vim.opt.virtualedit = "block,onemore" -- allow the cursor to move beyond the last character of a line
vim.opt.copyindent = true -- always copy indentation level from previous line
vim.opt.textwidth = 80 -- default textwidth
vim.opt.shiftwidth = 2 -- number of spaces to use for each step of indent
vim.opt.tabstop = 4 -- number of spaces a tab counts for
vim.opt.softtabstop = 4 -- number of spaces a tab counts for
vim.opt.expandtab = true -- insert tabs instead of spaces
vim.opt.formatoptions = "crqj" -- no automatic linebreak, no whatsoever expansion
vim.opt.pastetoggle = "<F1>" -- put vim in pastemode - usefull for pasting in console-mode
vim.opt.iskeyword:append({ "_" }) -- these characters also belong to a word

-- set matchpairs+=<:>          -- angle brackets should also being matched by %
vim.opt.complete:append({ "i" }) -- scan included files and dictionary (if spell checking is enabled)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- -- Highlight when yanking (copying) text
-- --  Try it with `yap` in normal mode
-- --  See `:help vim.highlight.on_yank()`
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--   callback = function()
--     vim.highlight.on_yank()
--   end,
-- })

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  root = vim.fn.stdpath("config") .. "/lazy",
  ui = {
    custom_keys = {
      ["<localleader>l"] = false,
      ["<localleader>t"] = false,
    },
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false, -- get a notification when changes are found
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "matchit",
        "netrwPlugin",
        "tutor",
        "tohtml",
        "tarPlugin",
        "zipPlugin",
        "gzip",
      },
    },
  },
})

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
-- require("lazy").setup({
-- -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
-- "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

-- NOTE: Plugins can also be added by using a table,
-- with the first argument being the link and the following
-- keys can be used to configure plugin behavior/loading/etc.
--
-- Use `opts = {}` to force a plugin to be loaded.
--
--  This is equivalent to:
--    require('Comment').setup({})

-- -- "gc" to comment visual regions/lines
-- { "numToStr/Comment.nvim", opts = {} },

-- -- Here is a more advanced example where we pass configuration
-- -- options to `gitsigns.nvim`. This is equivalent to the following lua:
-- --    require('gitsigns').setup({ ... })
-- --
-- -- See `:help gitsigns` to understand what the configuration keys do
-- { -- Adds git related signs to the gutter, as well as utilities for managing changes
--   "lewis6991/gitsigns.nvim",
--   opts = {
--     signs = {
--       add = { text = "+" },
--       change = { text = "~" },
--       delete = { text = "_" },
--       topdelete = { text = "‾" },
--       changedelete = { text = "~" },
--     },
--   },
-- },

-- NOTE: Plugins can also be configured to run lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

-- {                     -- Useful plugin to show you pending keybinds.
--   "folke/which-key.nvim",
--   event = "VimEnter", -- Sets the loading event to 'VimEnter'
--   config = function() -- This is the function that runs, AFTER loading
--     require("which-key").setup()
--     -- Document existing key chains
--     require("which-key").register({
--       ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
--       ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
--       ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
--       ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
--       ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
--     })
--   end,
-- },

-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

-- { -- Fuzzy Finder (files, lsp, etc)
--   "nvim-telescope/telescope.nvim",
--   event = "VimEnter",
--   branch = "0.1.x",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     { -- If encountering errors, see telescope-fzf-native README for install instructions
--       "nvim-telescope/telescope-fzf-native.nvim",
--
--       -- `build` is used to run some command when the plugin is installed/updated.
--       -- This is only run then, not every time Neovim starts up.
--       build = "make",
--
--       -- `cond` is a condition used to determine whether this plugin should be
--       -- installed and loaded.
--       cond = function()
--         return vim.fn.executable("make") == 1
--       end,
--     },
--     { "nvim-telescope/telescope-ui-select.nvim" },
--
--     -- Useful for getting pretty icons, but requires special font.
--     --  If you already have a Nerd Font, or terminal set up with fallback fonts
--     --  you can enable this
--     -- { 'nvim-tree/nvim-web-devicons' }
--   },
--   config = function()
--     -- Telescope is a fuzzy finder that comes with a lot of different things that
--     -- it can fuzzy find! It's more than just a "file finder", it can search
--     -- many different aspects of Neovim, your workspace, LSP, and more!
--     --
--     -- The easiest way to use telescope, is to start by doing something like:
--     --  :Telescope help_tags
--     --
--     -- After running this command, a window will open up and you're able to
--     -- type in the prompt window. You'll see a list of help_tags options and
--     -- a corresponding preview of the help.
--     --
--     -- Two important keymaps to use while in telescope are:
--     --  - Insert mode: <c-/>
--     --  - Normal mode: ?
--     --
--     -- This opens a window that shows you all of the keymaps for the current
--     -- telescope picker. This is really useful to discover what Telescope can
--     -- do as well as how to actually do it!
--
--     -- [[ Configure Telescope ]]
--     -- See `:help telescope` and `:help telescope.setup()`
--     require("telescope").setup({
--       -- You can put your default mappings / updates / etc. in here
--       --  All the info you're looking for is in `:help telescope.setup()`
--       --
--       -- defaults = {
--       --   mappings = {
--       --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
--       --   },
--       -- },
--       -- pickers = {}
--       extensions = {
--         ["ui-select"] = {
--           require("telescope.themes").get_dropdown(),
--         },
--       },
--     })
--
--     -- Enable telescope extensions, if they are installed
--     pcall(require("telescope").load_extension, "fzf")
--     pcall(require("telescope").load_extension, "ui-select")
--
--     -- See `:help telescope.builtin`
--     local builtin = require("telescope.builtin")
--     vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
--     vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
--     vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
--     vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
--     vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
--     vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
--     vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
--     vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
--     vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
--     vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
--
--     -- Slightly advanced example of overriding default behavior and theme
--     vim.keymap.set("n", "<leader>/", function()
--       -- You can pass additional configuration to telescope to change theme, layout, etc.
--       builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
--         winblend = 10,
--         previewer = false,
--       }))
--     end, { desc = "[/] Fuzzily search in current buffer" })
--
--     -- Also possible to pass additional configuration options.
--     --  See `:help telescope.builtin.live_grep()` for information about particular keys
--     vim.keymap.set("n", "<leader>s/", function()
--       builtin.live_grep({
--         grep_open_files = true,
--         prompt_title = "Live Grep in Open Files",
--       })
--     end, { desc = "[S]earch [/] in Open Files" })
--
--     -- Shortcut for searching your neovim configuration files
--     vim.keymap.set("n", "<leader>sn", function()
--       builtin.find_files({ cwd = vim.fn.stdpath("config") })
--     end, { desc = "[S]earch [N]eovim files" })
--   end,
-- },

-- { -- LSP Configuration & Plugins
--   "neovim/nvim-lspconfig",
--   dependencies = {
--     -- Automatically install LSPs and related tools to stdpath for neovim
--     "williamboman/mason.nvim",
--     "williamboman/mason-lspconfig.nvim",
--     "WhoIsSethDaniel/mason-tool-installer.nvim",
--
--     -- Useful status updates for LSP.
--     -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
--     { "j-hui/fidget.nvim", opts = {} },
--   },
--   config = function()
--     -- Brief Aside: **What is LSP?**
--     --
--     -- LSP is an acronym you've probably heard, but might not understand what it is.
--     --
--     -- LSP stands for Language Server Protocol. It's a protocol that helps editors
--     -- and language tooling communicate in a standardized fashion.
--     --
--     -- In general, you have a "server" which is some tool built to understand a particular
--     -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
--     -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
--     -- processes that communicate with some "client" - in this case, Neovim!
--     --
--     -- LSP provides Neovim with features like:
--     --  - Go to definition
--     --  - Find references
--     --  - Autocompletion
--     --  - Symbol Search
--     --  - and more!
--     --
--     -- Thus, Language Servers are external tools that must be installed separately from
--     -- Neovim. This is where `mason` and related plugins come into play.
--     --
--     -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
--     -- and elegantly composed help section, `:help lsp-vs-treesitter`
--
--     --  This function gets run when an LSP attaches to a particular buffer.
--     --    That is to say, every time a new file is opened that is associated with
--     --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--     --    function will be executed to configure the current buffer
--     vim.api.nvim_create_autocmd("LspAttach", {
--       group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
--       callback = function(event)
--         -- NOTE: Remember that lua is a real programming language, and as such it is possible
--         -- to define small helper and utility functions so you don't have to repeat yourself
--         -- many times.
--         --
--         -- In this case, we create a function that lets us more easily define mappings specific
--         -- for LSP related items. It sets the mode, buffer and description for us each time.
--         local map = function(keys, func, desc)
--           vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
--         end
--
--         -- Jump to the definition of the word under your cursor.
--         --  This is where a variable was first declared, or where a function is defined, etc.
--         --  To jump back, press <C-T>.
--         map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
--
--         -- Find references for the word under your cursor.
--         map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
--
--         -- Jump to the implementation of the word under your cursor.
--         --  Useful when your language has ways of declaring types without an actual implementation.
--         map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
--
--         -- Jump to the type of the word under your cursor.
--         --  Useful when you're not sure what type a variable is and you want to see
--         --  the definition of its *type*, not where it was *defined*.
--         map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
--
--         -- Fuzzy find all the symbols in your current document.
--         --  Symbols are things like variables, functions, types, etc.
--         map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
--
--         -- Fuzzy find all the symbols in your current workspace
--         --  Similar to document symbols, except searches over your whole project.
--         map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
--
--         -- Rename the variable under your cursor
--         --  Most Language Servers support renaming across files, etc.
--         map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
--
--         -- Execute a code action, usually your cursor needs to be on top of an error
--         -- or a suggestion from your LSP for this to activate.
--         map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
--
--         -- Opens a popup that displays documentation about the word under your cursor
--         --  See `:help K` for why this keymap
--         map("K", vim.lsp.buf.hover, "Hover Documentation")
--
--         -- WARN: This is not Goto Definition, this is Goto Declaration.
--         --  For example, in C this would take you to the header
--         map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
--
--         -- The following two autocommands are used to highlight references of the
--         -- word under your cursor when your cursor rests there for a little while.
--         --    See `:help CursorHold` for information about when this is executed
--         --
--         -- When you move your cursor, the highlights will be cleared (the second autocommand).
--         local client = vim.lsp.get_client_by_id(event.data.client_id)
--         if client and client.server_capabilities.documentHighlightProvider then
--           vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--             buffer = event.buf,
--             callback = vim.lsp.buf.document_highlight,
--           })
--
--           vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--             buffer = event.buf,
--             callback = vim.lsp.buf.clear_references,
--           })
--         end
--       end,
--     })
--
--     -- LSP servers and clients are able to communicate to each other what features they support.
--     --  By default, Neovim doesn't support everything that is in the LSP Specification.
--     --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--     --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
--     local capabilities = vim.lsp.protocol.make_client_capabilities()
--     capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
--
--     -- Enable the following language servers
--     --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--     --
--     --  Add any additional override configuration in the following tables. Available keys are:
--     --  - cmd (table): Override the default command used to start the server
--     --  - filetypes (table): Override the default list of associated filetypes for the server
--     --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--     --  - settings (table): Override the default settings passed when initializing the server.
--     --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--     local servers = {
--       -- clangd = {},
--       -- gopls = {},
--       -- pyright = {},
--       -- rust_analyzer = {},
--       -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
--       --
--       -- Some languages (like typescript) have entire language plugins that can be useful:
--       --    https://github.com/pmizio/typescript-tools.nvim
--       --
--       -- But for many setups, the LSP (`tsserver`) will work just fine
--       -- tsserver = {},
--       --
--
--       lua_ls = {
--         -- cmd = {...},
--         -- filetypes { ...},
--         -- capabilities = {},
--         settings = {
--           Lua = {
--             runtime = { version = "LuaJIT" },
--             workspace = {
--               checkThirdParty = false,
--               -- Tells lua_ls where to find all the Lua files that you have loaded
--               -- for your neovim configuration.
--               library = {
--                 "${3rd}/luv/library",
--                 unpack(vim.api.nvim_get_runtime_file("", true)),
--               },
--               -- If lua_ls is really slow on your computer, you can try this instead:
--               -- library = { vim.env.VIMRUNTIME },
--             },
--             completion = {
--               callSnippet = "Replace",
--             },
--             -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
--             -- diagnostics = { disable = { 'missing-fields' } },
--           },
--         },
--       },
--     }
--
--     -- Ensure the servers and tools above are installed
--     --  To check the current status of installed tools and/or manually install
--     --  other tools, you can run
--     --    :Mason
--     --
--     --  You can press `g?` for help in this menu
--     require("mason").setup()
--
--     -- You can add other tools here that you want Mason to install
--     -- for you, so that they are available from within Neovim.
--     local ensure_installed = vim.tbl_keys(servers or {})
--     vim.list_extend(ensure_installed, {
--       "stylua", -- Used to format lua code
--     })
--     require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
--
--     require("mason-lspconfig").setup({
--       handlers = {
--         function(server_name)
--           local server = servers[server_name] or {}
--           -- This handles overriding only values explicitly passed
--           -- by the server configuration above. Useful when disabling
--           -- certain features of an LSP (for example, turning off formatting for tsserver)
--           server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
--           require("lspconfig")[server_name].setup(server)
--         end,
--       },
--     })
--   end,
-- },

-- { -- Autoformat
--   'stevearc/conform.nvim',
--   opts = {
--     notify_on_error = false,
--     format_on_save = {
--       timeout_ms = 500,
--       lsp_fallback = true,
--     },
--     formatters_by_ft = {
--       lua = { 'stylua' },
--       -- Conform can also run multiple formatters sequentially
--       -- python = { "isort", "black" },
--       --
--       -- You can use a sub-list to tell conform to run *until* a formatter
--       -- is found.
--       -- javascript = { { "prettierd", "prettier" } },
--     },
--   },
-- },

-- { -- Autocompletion
--   'hrsh7th/nvim-cmp',
--   event = 'InsertEnter',
--   dependencies = {
--     -- Snippet Engine & its associated nvim-cmp source
--     {
--       'L3MON4D3/LuaSnip',
--       build = (function()
--         -- Build Step is needed for regex support in snippets
--         -- This step is not supported in many windows environments
--         -- Remove the below condition to re-enable on windows
--         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
--           return
--         end
--         return 'make install_jsregexp'
--       end)(),
--     },
--     'saadparwaiz1/cmp_luasnip',
--
--     -- Adds other completion capabilities.
--     --  nvim-cmp does not ship with all sources by default. They are split
--     --  into multiple repos for maintenance purposes.
--     'hrsh7th/cmp-nvim-lsp',
--     'hrsh7th/cmp-path',
--
--     -- If you want to add a bunch of pre-configured snippets,
--     --    you can use this plugin to help you. It even has snippets
--     --    for various frameworks/libraries/etc. but you will have to
--     --    set up the ones that are useful for you.
--     -- 'rafamadriz/friendly-snippets',
--   },
--   config = function()
--     -- See `:help cmp`
--     local cmp = require 'cmp'
--     local luasnip = require 'luasnip'
--     luasnip.config.setup {}
--
--     cmp.setup {
--       snippet = {
--         expand = function(args)
--           luasnip.lsp_expand(args.body)
--         end,
--       },
--       completion = { completeopt = 'menu,menuone,noinsert' },
--
--       -- For an understanding of why these mappings were
--       -- chosen, you will need to read `:help ins-completion`
--       --
--       -- No, but seriously. Please read `:help ins-completion`, it is really good!
--       mapping = cmp.mapping.preset.insert {
--         -- Select the [n]ext item
--         ['<C-n>'] = cmp.mapping.select_next_item(),
--         -- Select the [p]revious item
--         ['<C-p>'] = cmp.mapping.select_prev_item(),
--
--         -- Accept ([y]es) the completion.
--         --  This will auto-import if your LSP supports it.
--         --  This will expand snippets if the LSP sent a snippet.
--         ['<C-y>'] = cmp.mapping.confirm { select = true },
--
--         -- Manually trigger a completion from nvim-cmp.
--         --  Generally you don't need this, because nvim-cmp will display
--         --  completions whenever it has completion options available.
--         ['<C-Space>'] = cmp.mapping.complete {},
--
--         -- Think of <c-l> as moving to the right of your snippet expansion.
--         --  So if you have a snippet that's like:
--         --  function $name($args)
--         --    $body
--         --  end
--         --
--         -- <c-l> will move you to the right of each of the expansion locations.
--         -- <c-h> is similar, except moving you backwards.
--         ['<C-l>'] = cmp.mapping(function()
--           if luasnip.expand_or_locally_jumpable() then
--             luasnip.expand_or_jump()
--           end
--         end, { 'i', 's' }),
--         ['<C-h>'] = cmp.mapping(function()
--           if luasnip.locally_jumpable(-1) then
--             luasnip.jump(-1)
--           end
--         end, { 'i', 's' }),
--       },
--       sources = {
--         { name = 'nvim_lsp' },
--         { name = 'luasnip' },
--         { name = 'path' },
--       },
--     }
--   end,
-- },

-- { -- You can easily change to a different colorscheme.
--   -- Change the name of the colorscheme plugin below, and then
--   -- change the command in the config to whatever the name of that colorscheme is
--   --
--   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
--   'folke/tokyonight.nvim',
--   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
--   config = function()
--     -- Load the colorscheme here
--     vim.cmd.colorscheme 'tokyonight-night'
--
--     -- You can configure highlights by doing something like
--     vim.cmd.hi 'Comment gui=none'
--   end,
-- },

-- -- Highlight todo, notes, etc in comments
-- {
--   'folke/todo-comments.nvim',
--   event = 'VimEnter',
--   dependencies = { 'nvim-lua/plenary.nvim' },
--   opts = { signs = false },
-- },

-- { -- Collection of various small independent plugins/modules
--   'echasnovski/mini.nvim',
--   config = function()
--     -- Better Around/Inside textobjects
--     --
--     -- Examples:
--     --  - va)  - [V]isually select [A]round [)]paren
--     --  - yinq - [Y]ank [I]nside [N]ext [']quote
--     --  - ci'  - [C]hange [I]nside [']quote
--     require('mini.ai').setup { n_lines = 500 }
--
--     -- Add/delete/replace surroundings (brackets, quotes, etc.)
--     --
--     -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
--     -- - sd'   - [S]urround [D]elete [']quotes
--     -- - sr)'  - [S]urround [R]eplace [)] [']
--     require('mini.surround').setup()
--
--     -- Simple and easy statusline.
--     --  You could remove this setup call if you don't like it,
--     --  and try some other statusline plugin
--     local statusline = require 'mini.statusline'
--     statusline.setup()
--
--     -- You can configure sections in the statusline by overriding their
--     -- default behavior. For example, here we disable the section for
--     -- cursor information because line numbers are already enabled
--     ---@diagnostic disable-next-line: duplicate-set-field
--     statusline.section_location = function()
--       return ''
--     end
--
--     -- ... and there is more!
--     --  Check out: https://github.com/echasnovski/mini.nvim
--   end,
-- },

-- { -- Highlight, edit, and navigate code
--   'nvim-treesitter/nvim-treesitter',
--   build = ':TSUpdate',
--   config = function()
--     -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
--
--     ---@diagnostic disable-next-line: missing-fields
--     require('nvim-treesitter.configs').setup {
--       ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
--       -- Autoinstall languages that are not installed
--       auto_install = true,
--       highlight = { enable = true },
--       indent = { enable = true },
--     }
--
--     -- There are additional nvim-treesitter modules that you can use to interact
--     -- with nvim-treesitter. You should go explore a few and see what interests you:
--     --
--     --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
--     --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
--     --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--   end,
-- },

-- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
-- init.lua. If you want these files, they are in the repository, so you can just download them and
-- put them in the right spots if you want.

-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for kickstart
--
--  Here are some example plugins that I've included in the kickstart repository.
--  Uncomment any of the lines below to enable them (you will need to restart nvim).

-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
--    This is the easiest way to modularize your config.
--
--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
--    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
--   { import = "plugins" },
-- })

-- The line beneath this is called `modeline`. See `:help modeline`

vim.g.my_gui_font = "JetBrainsMono Nerd Font:h9"
vim.o.guifont = vim.fn.fnameescape(vim.g.my_gui_font)
vim.cmd([[
command! GuiFontBigger  :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)+1', ''))
command! GuiFontSmaller :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)-1', ''))
]])

map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

map("n", "<C-0>", ":<C-u>exec ':set guifont='.fnameescape(g:my_gui_font)<CR>", { silent = true })
map("n", "<C-->", ":<C-u>GuiFontSmaller<CR>", { silent = true })
map("n", "<C-8>", ":<C-u>GuiFontSmaller<CR>", { silent = true })
map("n", "<C-ScrollWheelDown>", ":<C-u>GuiFontSmaller<CR>", { silent = true })
map("n", "<C-=>", ":<C-u>GuiFontBigger<CR>", { silent = true })
map("n", "<C-+>", ":<C-u>GuiFontBigger<CR>", { silent = true })
map("n", "<C-9>", ":<C-u>GuiFontBigger<CR>", { silent = true })
map("n", "<C-ScrollWheelUp>", ":<C-u>GuiFontBigger<CR>", { silent = true })

-- vim: ts=2 sts=2 sw=2 et
