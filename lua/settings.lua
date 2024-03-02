-- Global Settings:
-- ----------------

-- Miscellaneous Settings:
-- -----------------------

vim.o.commentstring = "#%s"                               -- set default comment string to octothorpe
vim.o.comments = "b:#,fb:-,fb:*"                          -- Remove some legacy and C comment strings
vim.o.path = ".,,"                                        -- limit path
vim.o.swapfile = true                                     -- write swap files
vim.o.directory = vim.fn.expand("~/.cache/nvim/swap//")   -- place swap files outside the current directory
vim.o.backup = true                                       -- write backup copies
vim.o.backupdir = vim.fn.expand("~/.cache/nvim/backup//") -- place swap files outside the current directory
vim.o.writebackup = true                                  -- write backup before writing a file
vim.o.backupcopy =
"yes"                                                     -- overwrite the original file when modifying it - the default "auto" might break the inotify/watch commands
vim.o.gdefault = true                                     -- substitute all matches by default
vim.o.ignorecase = true                                   -- ignore case by default for search patterns
vim.o.magic = true                                        -- special characters that can be used in search patterns
vim.o.hidden = true                                       -- allow hidden buffers with modifications
vim.o.whichwrap = "<,>"                                   -- Cursor key move the cursor to the next/previous line if pressed at the end/beginning of a line
vim.o.backspace = "indent,eol,start"                      -- more powerful backspacing
vim.o.grepprg = "rg --vimgrep"                            -- use ripgrep

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
  "options",               -- do not store global and local values in a session
  "folds",                 -- do not store folds
})
vim.o.switchbuf = "usetab" -- This option controls the behavior when switching between buffers.
-- set nottimeout                 -- if terminal sends 0x9b ttimeout can be disabled
-- vim.o.printoptions = "paper:a4,syntax:n" -- controls the default paper size and the printing of syntax highlighting (:n -> none)
-- let mapleader='\'              -- change map leader to a key that's more convenient to reach
vim.o.updatetime = 300 -- timeout for triggering the CursorHold auto command

-- enable persistent undo
vim.o.undodir = vim.fn.expand("~/.cache/nvim/undo//")
vim.o.undofile = true
if not vim.fn.isdirectory(vim.o.undodir) then
  vim.fn.mkdir(vim.o.undodir, "p")
end

-- play nicely with fish and nu shell
vim.o.shell = "bash"

-- Visual Settings:
-- ----------------

vim.opt.shortmess:append("c")        -- don't show matching messages
vim.o.lazyredraw = true              -- draw screen updates lazily
vim.o.showmode = true                -- show vim's current mode
vim.o.showcmd = true                 -- show vim's current command
vim.o.showmatch = true               -- highlight mathing brackets
vim.o.hlsearch = false               -- don't highlight search results by default as I'm using them to navigate around
vim.o.wrap = false                   -- don't wrap long lines by default
vim.o.mouse = "a"                    -- Enable the use of a mouse
vim.o.cursorline = true              -- Don't show cursorline
vim.o.errorbells = false             -- disable error bells
vim.o.visualbell = false             -- disable beep
vim.o.wildmode =
"list:longest,full"                  -- Don't start wildmenu immediately but list the alternatives first and then do the completion if the user requests it by pressing wildkey repeatedly
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
vim.o.guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20,a:blinkon0-Cursor/lCursor" -- cursor-blinking off!!
vim.o.foldenable = false -- start editing with all folds open
vim.o.foldmethod = "indent" -- Use indent for folding by default
-- set foldminlines=0             -- number of lines above which a fold can be displayed
vim.o.linebreak = true -- If on Vim will wrap long lines at a character in 'breakat'
vim.o.breakindent = true -- indent wrapped lines visually
vim.o.showtabline = 2 -- always show tabline, even if there is just one tab, avoid redraw problems when Window is displayed in fullscreen mode
-- set foldcolumn=1               -- show folds
vim.o.colorcolumn = "+1" -- color specified column in order to help respecting line widths
vim.o.termguicolors = true -- true color for the terminal
vim.o.number = true
vim.o.relativenumber = true -- show linenumbers
vim.o.signcolumn = "auto" -- display signs in separate column
vim.opt.completeopt = { "menu", "menuone", "preview", "noinsert", "noselect" } -- show the complete menu even if there is just one entry
vim.o.splitright = true -- put the new window right of the current one
vim.o.splitbelow = true -- put the new window below the current one
vim.o.list = true -- list nonprintable characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- list nonprintable characters
vim.o.showbreak = "↪  " -- identifier put in front of wrapped lines
vim.opt.fillchars = { vert = " ", diff = "·", fold = "·", eob = " " } -- get rid of the gab between the vertical bars
-- vim.opt.fillchars = { vert = "│", diff = "·", fold = "·", eob = " " } -- get rid of the gab between the vertical bars
vim.o.scrolloff = 3 -- always show context at top and bottom
-- vim.opt.guioptions = "aegimtc" -- disable scrollbars
vim.o.cpoptions =
"aABceFsq" -- q: When joining multiple lines leave the cursor at the position where it would be when joining two lines.
-- $:  When making a change to one line, don't redisplay the line, but put a '$' at the end of the changed text.
-- v: Backspaced characters remain visible on the screen in Insert mode.
-- J: a sentence is followed by two spaces
-- set synmaxcol=200              -- stop syntax highlighting at a certain column to improve speed
vim.o.inccommand = "split" -- preview changes of substitute commands in a separate window
vim.o.report = 0           -- report every changed line

-- Text Settings:
-- --------------

vim.opt.clipboard:remove({ "autoselect" }) -- disable itegration with X11 clipboard
vim.o.virtualedit = "block,onemore"        -- allow the cursor to move beyond the last character of a line
vim.o.copyindent = true                    -- always copy indentation level from previous line
vim.o.cindent = false                      -- disable cindent - it doesn't go well with formatoptions
vim.o.textwidth = 80                       -- default textwidth
vim.o.shiftwidth = 2                       -- number of spaces to use for each step of indent
vim.o.tabstop = 4                          -- number of spaces a tab counts for
vim.o.softtabstop = 4                      -- number of spaces a tab counts for
vim.o.expandtab = true                     -- insert tabs instead of spaces
vim.o.smartcase = false                    -- smart case search (I don't like it that much since it makes * and # much harder to use)
vim.o.formatoptions = "crqj"               -- no automatic linebreak, no whatsoever expansion
vim.o.pastetoggle = "<F1>"                 -- put vim in pastemode - usefull for pasting in console-mode
vim.opt.iskeyword:append({ "_" })          -- these characters also belong to a word
-- set matchpairs+=<:>          -- angle brackets should also being matched by %
vim.opt.complete:append({ "i" })           -- scan included files and dictionary (if spell checking is enabled)

-- Disable builtin plugins that are not needed
local disabled_built_ins = {
  "2html_plugin",
  "crefvim",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "matchit",
  "netrw",   -- TODO: not quite sure of how to use dirvish but still use netrw for remote file access
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

vim.g.editorconfig = true
