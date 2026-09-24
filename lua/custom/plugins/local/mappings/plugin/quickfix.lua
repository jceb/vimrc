-- format paragraphs quickly
-- vim.keymap.set("n", "Q", "gwip", { noremap = true }) -- mapping interfers with the multicursor feature
-- vim.keymap.set("x", "Q", "gw", { noremap = true })
-- quick json formatting of selection
vim.keymap.set("n", "<leader>ql", ":QFLoad<CR>", { noremap = true })
vim.keymap.set("n", "<leader>qs", ":QFSave!<CR>", { noremap = true })
vim.keymap.set("n", "<leader>qj", "vip:!jq .<CR>", { noremap = true })
vim.keymap.set("x", "<leader>qj", ":!jq .<CR>", { noremap = true })
