-- disable neovide cursor animation
vim.g.neovide_cursor_animation_length = 0

-- disable unused providers
vim.g.loaded_python3_provider = 1
vim.g.loaded_perl_provider = 1
vim.g.loaded_ruby_provider = 1
vim.g.loaded_node_provider = 1

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

vim.opt.commentstring = "#%s"                               -- set default comment string to octothorpe
vim.opt.comments = "b:#,fb:-,fb:*"                          -- Remove some legacy and C comment strings
vim.opt.path = ".,,"                                        -- limit path
vim.opt.swapfile = true                                     -- write swap files
vim.opt.directory = vim.fn.expand("~/.cache/nvim/swap//")   -- place swap files outside the current directory
vim.opt.backup = true                                       -- write backup copies
vim.opt.backupdir = vim.fn.expand("~/.cache/nvim/backup//") -- place swap files outside the current directory
vim.opt.writebackup = true                                  -- write backup before writing a file
vim.opt.backupcopy =
"yes"                                                       -- overwrite the original file when modifying it - the default "auto" might break the inotify/watch commands
vim.opt.gdefault = true                                     -- substitute all matches by default
vim.opt.magic = true                                        -- special characters that can be used in search patterns
vim.opt.hidden = true                                       -- allow hidden buffers with modifications
vim.opt.whichwrap =
"<,>"                                                       -- Cursor key move the cursor to the next/previous line if pressed at the end/beginning of a line
vim.opt.backspace = "indent,eol,start"                      -- more powerful backspacing
vim.opt.grepprg = "rg --vimgrep"                            -- use ripgrep

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
  "folds",   -- do not store folds
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
vim.opt.lazyredraw = true     -- draw screen updates lazily
vim.opt.showmatch = true      -- highlight mathing brackets
vim.opt.hlsearch = false      -- don't highlight search results by default as I'm using them to navigate around
-- disable search when redrawing the screen
vim.keymap.set(
  "n",
  "<C-l>",
  ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><Bar>redraw!<Bar>syntax sync fromstart<CR>",
  { silent = true, noremap = true }
)

vim.opt.wrap = false       -- don't wrap long lines by default
vim.opt.mouse = "a"        -- Enable the use of a mouse
vim.opt.cursorline = true  -- Don't show cursorline
vim.opt.errorbells = false -- disable error bells
vim.opt.visualbell = false -- disable beep
vim.opt.wildmode =
"list:longest,full"        -- Don't start wildmenu immediately but list the alternatives first and then do the completion if the user requests it by pressing wildkey repeatedly
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
vim.opt.foldenable = false                                                                -- start editing with all folds open
vim.opt.foldmethod =
"indent"                                                                                  -- Use indent for folding by default
-- set foldminlines=0             -- number of lines above which a fold can be displayed
vim.opt.linebreak = true                                                                  -- If on Vim will wrap long lines at a character in 'breakat'
vim.opt.breakindent = true                                                                -- indent wrapped lines visually
vim.opt.showtabline = 2                                                                   -- always show tabline, even if there is just one tab, avoid redraw problems when Window is displayed in fullscreen mode
-- set foldcolumn=1               -- show folds
vim.opt.colorcolumn =
"+1"                                                                           -- color specified column in order to help respecting line widths
vim.opt.termguicolors = true                                                   -- true color for the terminal
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
vim.opt.cpoptions =
"aABceFsq" -- q: When joining multiple lines leave the cursor at the position where it would be when joining two lines.
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
vim.opt.virtualedit = "block,onemore"      -- allow the cursor to move beyond the last character of a line
vim.opt.copyindent = true                  -- always copy indentation level from previous line
vim.opt.textwidth = 80                     -- default textwidth
vim.opt.shiftwidth = 2                     -- number of spaces to use for each step of indent
vim.opt.tabstop = 4                        -- number of spaces a tab counts for
vim.opt.softtabstop = 4                    -- number of spaces a tab counts for
vim.opt.expandtab = true                   -- insert tabs instead of spaces
vim.opt.formatoptions = "crqj"             -- no automatic linebreak, no whatsoever expansion
vim.opt.pastetoggle = "<F1>"               -- put vim in pastemode - usefull for pasting in console-mode
vim.opt.iskeyword:append({ "_" })          -- these characters also belong to a word

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

require("keybindings")

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

-- " set SSH environment variable in case it isn't set, e.g. in nvim-qt
-- if getenv('SSH_AUTH_SOCK') == v:null
--   call setenv('SSH_AUTH_SOCK', systemlist('gpgconf --list-dirs agent-ssh-socket')[0])
-- endif

-- vim: ts=2 sts=2 sw=2 et
