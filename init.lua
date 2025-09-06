-- vi: ft=lua:tw=120:sw=2:ts=2:sts=-1:et:fdm=marker

-- disable neovide cursor animation
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_floating_shadow = false
vim.g.neovide_position_animation_length = 0
vim.g.neovide_scroll_animation_length = 0
vim.g.neovide_remember_window_size = false

-- disable unused providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

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

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
-- vim.opt.smartcase = true
vim.opt.smartcase = false -- smart case search (I don't like it that much since it makes * and # much harder to use)

vim.opt.numberwidth = 3
vim.opt.statuscolumn = "%l%s"
-- Keep signcolumn on by default
vim.opt.signcolumn = "yes:1"
-- vim.opt.signcolumn = "yes"
-- vim.opt.signcolumn = 'auto' -- display signs in separate column

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

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

-- vim.opt.switchbuf = "usetab" -- This option controls the behavior when switching between buffers.
-- set nottimeout                 -- if terminal sends 0x9b ttimeout can be disabled
-- vim.opt.printoptions = "paper:a4,syntax:n" -- controls the default paper size and the printing of syntax highlighting (:n -> none)
-- let mapleader='\'              -- change map leader to a key that's more convenient to reach
-- Decrease update time
vim.opt.updatetime = 300 -- timeout for triggering the CursorHold auto command
-- vim.opt.timeoutlen = 300

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
vim.opt.wildmode = { "noselect", "list:longest", "full" } -- Don't start wildmenu immediately but list the alternatives first and then do the completion if the user requests it by pressing wildkey repeatedly
-- vim.opt.wildmode = { "list:longest", "full" } -- Don't start wildmenu immediately but list the alternatives first and then do the completion if the user requests it by pressing wildkey repeatedly
vim.opt.wildoptions:append({ "fuzzy" }) -- Don't start wildmenu immediately but list the alternatives first and then do the completion if the user requests it by pressing wildkey repeatedly
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
-- vim.opt.foldenable = false -- start editing with all folds open
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr" -- Use indent for folding by default
-- vim.opt.foldmethod = "indent" -- Use indent for folding by default
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})
-- set foldminlines=0             -- number of lines above which a fold can be displayed
vim.opt.linebreak = true -- If on Vim will wrap long lines at a character in 'breakat'
vim.opt.breakindent = true -- indent wrapped lines visually
vim.opt.showtabline = 2 -- always show tabline, even if there is just one tab, avoid redraw problems when Window is displayed in fullscreen mode
-- set foldcolumn=1               -- show folds
vim.opt.colorcolumn = "+1" -- color specified column in order to help respecting line widths
vim.opt.termguicolors = true -- true color for the terminal
vim.opt.completeopt = { "menu", "menuone", "preview", "noinsert" } -- show the complete menu even if there is just one entry
-- vim.opt.completeopt = { "menu", "menuone", "preview", "noinsert", "noselect" } -- show the complete menu even if there is just one entry

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
vim.opt.textwidth = 120 -- default textwidth
vim.opt.shiftwidth = 2 -- number of spaces to use for each step of indent
vim.opt.tabstop = 2 -- number of spaces a tab counts for
vim.opt.softtabstop = 2 -- number of spaces a tab counts for
vim.opt.expandtab = true -- insert tabs instead of spaces
vim.opt.formatoptions = "crqj" -- no automatic linebreak, no whatsoever expansion
-- vim.opt.pastetoggle = "<F1>"               -- put vim in pastemode - usefull for pasting in console-mode
vim.opt.iskeyword:append({ "_" }) -- these characters also belong to a word

-- set matchpairs+=<:>          -- angle brackets should also being matched by %
vim.opt.complete:append({ "i" }) -- scan included files and dictionary (if spell checking is enabled)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>oe", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>oE", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- -- is not what someone will guess without a bit more experience.
-- --
-- -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- -- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- -- Keybinds to make split navigation easier.
-- --  Use CTRL+<hjkl> to switch between windows
-- --
-- --  See `:help wincmd` for a list of all window commands
-- vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
-- vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

require("keybindings")

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.diagnostic.config({
  float = true,
  severity_sort = true,
  -- signs = true,
  signs = {
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },
  underline = true,
  update_in_insert = false,
  -- virtual_text = { current_line = true },
  -- show errors on a separate new line
  -- virtual_lines = { current_line = true },
})

require("lazy").setup({
  ----------------------
  -- buffer management {{{1
  ----------------------
  require("custom.plugins.vim-sayonara"),
  require("custom.plugins.easybuffer"),

  ----------------------
  -- commands {{{1
  ----------------------
  require("custom.plugins.vim-eunuch"),
  require("custom.plugins.vim-grepper"),
  require("custom.plugins.neomake"),
  require("custom.plugins.vim-helpwrapper"),
  require("custom.plugins.neogen"),

  ----------------------
  -- completion {{{1
  ----------------------
  -- require("custom.plugins.wilder"), -- currently unused
  require("custom.plugins.nvim-dap"),
  require("custom.plugins.lazydev"),
  require("custom.plugins.luavit-meta"),
  require("custom.plugins.nvim-lspconfig"),
  require("custom.plugins.yaml-companion"),
  -- require("custom.plugins.nvim-cmp"), -- replaced by blink
  require("custom.plugins.blink"),

  ----------------------
  -- copy / paste {{{1
  ----------------------
  require("custom.plugins.yanky"),
  -- require("custom.plugins.substitute"), -- replaced by mini.yank
  -- require("custom.plugins.highlight-undo"), -- replaced by yanky
  -- require("custom.plugins.vim-subversive"), -- replaced by mini.yank

  ----------------------
  -- development {{{1
  ----------------------
  -- require("custom.plugins.nvim-silicon"),
  require("custom.plugins.aerial"),
  -- require("custom.plugins.symbols-outline"), -- replaced by aerial
  -- require("custom.plugins.nvim-lint"), -- currently unused
  require("custom.plugins.trouble"),
  require("custom.plugins.cheat"),
  require("custom.plugins.vim-characterize"),
  require("custom.plugins.nvim-luapad"),
  -- require("custom.plugins.nvim-pdb"), -- currently unused
  require("custom.plugins.rest"),
  -- require("custom.plugins.vim-hier"), -- currently unused
  require("custom.plugins.vim-editqf"),
  require("custom.plugins.vim-cd"),
  require("custom.plugins.codecompanion"),

  ----------------------
  -- file management {{{1
  ----------------------
  require("custom.plugins.nvim-tree"), -- replaced by neo-tree
  -- require("custom.plugins.neo-tree"), -- replaced by nvim-tree
  require("custom.plugins.telescope"),
  -- require("custom.plugins.oil"), -- replaced by vim-dirvish
  require("custom.plugins.vim-dirvish"),
  -- require("custom.plugins.netman"),

  ----------------------
  -- ftplugins {{{1
  ----------------------
  -- require("custom.plugins.mdx"),
  require("custom.plugins.nvim-treesitter"),
  require("custom.plugins.vim-sleuth"),
  require("custom.plugins.vim-astro"),
  require("custom.plugins.vim-caddyfile"),
  require("custom.plugins.direnv"),
  require("custom.plugins.vim-apathy"),
  -- require("custom.plugins.d2-vim"),
  require("custom.plugins.vim-just"),
  require("custom.plugins.yaml"),
  -- require("custom.plugins.vim-jsonnet"),
  -- require("custom.plugins.emmet-snippets"),
  -- require("custom.plugins.vim-solidity"),
  -- require("custom.plugins.vim-vue"),
  require("custom.plugins.vim-asciidoc"),
  require("custom.plugins.go"),
  -- require("custom.plugins.vim-fish"),
  -- require("custom.plugins.nvim-nu"), -- incompatible with nu lsp
  -- require("custom.plugins.vim-graphql"),
  -- require("custom.plugins.vim-svelte"),
  require("custom.plugins.vim-helm"),
  require("custom.plugins.plantuml-syntax"),
  -- require("custom.plugins.vim-markdown"), -- replaced by nvim-markdown
  require("custom.plugins.nvim-markdown"),
  -- require("custom.plugins.quarto-nvim"),
  require("custom.plugins.vim-terraform"),
  require("custom.plugins.markdown-preview"),
  -- require("custom.plugins.vim-tiddlywiki"),
  -- require("custom.plugins.zk"),

  ----------------------
  -- git {{{1
  ----------------------
  require("custom.plugins.vim-fugitive"),

  ----------------------
  -- session management {{{1
  ----------------------
  -- require("custom.plugins.vim-obsession"), -- replaced by mini.session

  ----------------------
  -- movement {{{1
  ----------------------
  -- require("custom.plugins.lightspeed"), -- replaced by mini.jump2d
  -- require("custom.plugins.hydra"),
  -- require("custom.plugins.leap"), -- replaced by mini.jump2d
  require("custom.plugins.hop"), -- replaced by mini.jump2d
  -- require("custom.plugins.demicolon"), -- TODO: use
  -- require("custom.plugins.repmo-vim"), -- TODO: replace with demicolon
  require("custom.plugins.jumpy"),
  -- require("custom.plugins.lastpos"), -- replaced by remember
  require("custom.plugins.remember"),
  require("custom.plugins.vim-shootingstar"),
  -- require("custom.plugins.multicursor"), -- replaced by vim-visual-multi
  require("custom.plugins.vim-visual-multi"),
  require("custom.plugins.starrange"),
  require("custom.plugins.vim-unimpaired"),
  require("custom.plugins.vim-rsi"),
  require("custom.plugins.diffwindow_movement"),
  require("custom.plugins.tabout"),
  -- require("custom.plugins.navigator"),

  ----------------------
  -- window management {{{1
  ----------------------
  -- require("custom.plugins.vim-buffset"),
  require("custom.plugins.maximizer"),
  -- require("custom.plugins.vim-maximizer"), -- replace by zen-mode
  require("custom.plugins.zen-mode"),
  -- require("custom.plugins.goyo"), -- replace by zen-mode

  ----------------------
  -- terminal {{{1
  ----------------------
  require("custom.plugins.neoterm"),
  require("custom.plugins.vim-floaterm"),
  -- require("custom.plugins.nvim-toggleterm"),

  ----------------------
  -- text transformation {{{1
  ----------------------
  -- require("custom.plugins.ai"),
  -- require("custom.plugins.icon-picker"),
  -- require("custom.plugins.debugprint"),
  require("custom.plugins.ccc"),
  require("custom.plugins.scratch"),
  require("custom.plugins.vim-abolish"),
  require("custom.plugins.comment"),
  -- require("custom.plugins.vim-commentary"), -- replaced by comment
  -- require("custom.plugins.tcomment"), -- replaced by comment
  -- require("custom.plugins.nvim-autopairs"), -- replaced by ultimate-autopair
  require("custom.plugins.ultimate-autopair"),
  -- require("custom.plugins.vim-easy-align"), -- replaced by mini.align
  -- require("custom.plugins.vim-surround"), -- replaced by mini.surround
  require("custom.plugins.vim-repeat"),
  require("custom.plugins.vim-textobj-uri"),
  require("custom.plugins.visincr"),
  require("custom.plugins.swapit"),
  -- require("custom.plugins.dial"), -- replaced by swapit
  -- require("custom.plugins.thesaurus_query"),
  -- require("custom.plugins.vim-languagetool"), -- replaced by harper_ls, see nvim-lspconfig
  -- require("custom.plugins.refactoring"),
  require("custom.plugins.treesj"),
  require("custom.plugins.conform"),

  ----------------------
  -- visuals {{{1
  ----------------------
  require("custom.plugins.blinds"),
  -- require("custom.plugins.nvim-cursorword"), -- replaced by mini.cursorword
  require("custom.plugins.highlight-current-n"),
  -- require("custom.plugins.indent-blankline"),
  require("custom.plugins.vim-interestingwords"),
  -- require("custom.plugins.lite-tab-page"),
  require("custom.plugins.vim-matchup"),
  require("custom.plugins.nvim-colorizer"),
  -- require("custom.plugins.lightline"), -- replaced by heirline
  -- require("custom.plugins.lualine"), -- replaced by heirline
  require("custom.plugins.heirline"),
  -- require("custom.plugins.papercolor-theme"),
  -- require("custom.plugins.catppuccin"),
  require("custom.plugins.tokyonight"),
  -- require("custom.plugins.nord"),
  -- require("custom.plugins.barbar"),
  -- require("custom.plugins.todo-comments"),
  -- require("custom.plugins.gitsigns"),
  -- require("custom.plugins.which-key"),
  -- require("custom.plugins.nvim-ufo"), -- see also nvim-lspconfig

  ----------------------
  -- misc {{{1
  ----------------------
  -- require("custom.plugins.impatient"),
  require("custom.plugins.firenvim"),
  require("custom.plugins.neovim-gui-shim"),
  require("custom.plugins.mini"),
  require("custom.plugins.snacks"), -- TODO: investigate

  ----------------------
  -- local plugins {{{1
  ----------------------
  {
    name = "debchangelog",
    dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/local/debchangelog",
    ft = { "debchangelog" },
  },
  {
    name = "myconfig",
    dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/local/myconfig",
  },
  {
    name = "pydoc910",
    dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/local/pydoc910",
    ft = { "python" },
  },
  {
    name = "rfc",
    dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/local/rfc",
    ft = { "rfc" },
  },
  {
    name = "dotenv",
    dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/local/dotenv",
  },
  {
    name = "serif",
    dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/local/serif",
  },
}, {
  root = vim.fn.stdpath("config") .. "/lazy",
  ui = {
    custom_keys = {
      ["<localleader>l"] = false,
      ["<localleader>t"] = false,
    },
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
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
        "matchparen",
        "matchit",
        "netrwPlugin",
        "tutor",
        "tohtml",
        "spellfile",
        "tarPlugin",
        "zipPlugin",
        "gzip",
      },
    },
  },
})

-- " set SSH environment variable in case it isn't set, e.g. in nvim-qt
-- if getenv('SSH_AUTH_SOCK') == v:null
--   call setenv('SSH_AUTH_SOCK', systemlist('gpgconf --list-dirs agent-ssh-socket')[0])
-- endif

-- vim: ts=2 sts=2 sw=2 et
