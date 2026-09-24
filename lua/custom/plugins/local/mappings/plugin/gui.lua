-- Mappings and gui settings

vim.g.my_gui_font = "JetBrainsMono Nerd Font:h9"
vim.o.guifont = vim.fn.fnameescape(vim.g.my_gui_font)

vim.cmd([[
command! GuiFontBigger  :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)+1', ''))
command! GuiFontSmaller :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)-1', ''))
]])

vim.keymap.set("n", "<C-0>", ":<C-u>exec ':set guifont='.fnameescape(g:my_gui_font)<CR>", { silent = true })
vim.keymap.set("n", "<C-->", ":<C-u>GuiFontSmaller<CR>", { silent = true })
vim.keymap.set("n", "<C-8>", ":<C-u>GuiFontSmaller<CR>", { silent = true })
vim.keymap.set("n", "<C-ScrollWheelDown>", ":<C-u>GuiFontSmaller<CR>", { silent = true })
vim.keymap.set("n", "<C-=>", ":<C-u>GuiFontBigger<CR>", { silent = true })
vim.keymap.set("n", "<C-+>", ":<C-u>GuiFontBigger<CR>", { silent = true })
vim.keymap.set("n", "<C-9>", ":<C-u>GuiFontBigger<CR>", { silent = true })
vim.keymap.set("n", "<C-ScrollWheelUp>", ":<C-u>GuiFontBigger<CR>", { silent = true })
