-- quick navigation between windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

-- Store relative line number jumps in the jumplist if they exceed a threshold.
-- thanks to https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.vim/plugin/mappings/normal.vim
vim.keymap.set("n", "k", "(v:count > 2 ? \"m'\" . v:count : '') . 'k'", { noremap = true, expr = true })
vim.keymap.set("n", "j", "(v:count > 2 ? \"m'\" . v:count : '') . 'j'", { noremap = true, expr = true })

-- Use C-g in command and insert mode as well
vim.keymap.set("n", "<C-g>", "1<C-g>", { noremap = true })
vim.keymap.set("c", "<C-g>", "<C-R>=expand('%:h').'/'<CR>", { noremap = true })
-- inoremap <C-g> <C-R>=expand('%:h').'/'<CR>

-- " make n and N always search in the same direction
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { noremap = true, expr = true })

-- http://vim.wikia.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
vim.keymap.set("i", "<Esc>", "<Esc>`^", { silent = true, noremap = true })

-- delete words in insert and command mode like expected - doesn't work properly
-- at the end of lines
vim.keymap.set("i", "<C-BS>", "<C-G>u<C-w>", {})
vim.keymap.set("c", "<C-BS>", "<C-w>", {})
vim.keymap.set("i", "<C-Del>", "<C-o>dw", {})
vim.keymap.set("c", "<C-Del>", "<C-Right><C-w>", {})
-- if !has('gui_running')
--     cmap <C-H> <C-w>
--     imap <C-H> <C-w>
-- endif

-- select last paste visually
vim.keymap.set("n", "gV", "`]v`[", { noremap = true })

-- start new undo sequences when using certain commands in insert mode
vim.keymap.set("i", "<C-U>", "<C-G>u<C-U>", { noremap = true })
vim.keymap.set("i", "<C-W>", "<C-G>u<C-W>", { noremap = true })
-- disable <BS> mapping to improve the autocompletion experience
-- inoremap <BS> <C-G>u<BS>
vim.keymap.set("i", "<C-H>", "<C-G>u<C-H>", { noremap = true })
vim.keymap.set("i", "<Del>", "<C-G>u<Del>", { noremap = true })

-- Enable the same behavior to <C-n> and <Down> / <C-p> and <Up> in command mode
vim.keymap.set("c", "<C-p>", "<Up>", { noremap = true })
vim.keymap.set("c", "<C-n>", "<Down>", { noremap = true })

-- disable <F1> mapping to open vim help - especially on Lenovo laptops <F1> is
-- in the way of <Esc> which is really annoying
vim.keymap.set("i", "<F1>", "<Nop>", { noremap = true })
vim.keymap.set("n", "<F1>", "<Nop>", { noremap = true })
