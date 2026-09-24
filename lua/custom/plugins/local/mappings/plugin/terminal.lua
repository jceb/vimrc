-- Mappings for terminals

-- use the same exit key for vim that's also configured in the terminal
vim.keymap.set("i", "<C-\\><C-\\>", "<Esc>", { noremap = true })
vim.keymap.set("i", "", "<Esc>", { noremap = true })
vim.keymap.set("i", "<C-_><C-_>", "<Esc>", { noremap = true })
vim.keymap.set("i", "<C-/><C-/>", "<Esc>", { noremap = true })
vim.keymap.set("c", "<C-\\><C-\\>", "<Esc>", { noremap = true })
vim.keymap.set("c", "", "<Esc>", { noremap = true })
vim.keymap.set("c", "<C-_><C-_>", "<Esc>", { noremap = true })
vim.keymap.set("c", "<C-/><C-/>", "<Esc>", { noremap = true })

-- shortcuts for exiting terminal input mode and navigating to another window
vim.keymap.set("t", "<C-\\><C-\\>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("t", "", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("t", "<C-_><C-_>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("t", "<C-/><C-/>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { noremap = true })
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { noremap = true })
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { noremap = true })
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { noremap = true })
