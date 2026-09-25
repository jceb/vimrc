-- Miscellaneous mappings

-- in addition to the gf and gF commands:
-- edit file and create it in case it doesn't exist
vim.keymap.set("n", "gcf", ":<C-u>e %:h/<cfile><CR>", { noremap = true })
--- WARNING: gcf binding in visual mode is in conflict with vim commentary!
vim.keymap.set("x", "<leader>gcf", 'y:exec ":e ".fnameescape(substitute(expand("%:h"), "oil://", "", "")."/".getreg(\'"\'))<CR>', { noremap = true })

-- swap current word with next word
vim.keymap.set(
  "n",
  "<Plug>SwapWords",
  ':<C-u>keeppatterns s/\\v(<\\k*%#\\k*>)(\\_.{-})(<\\k+>)/\\3\\2\\1/<Bar>:echo<Bar>:silent! call repeat#set("\\<Plug>SwapWords")<Bar>:normal ``<CR>',
  { silent = true, noremap = true }
)
-- swap current word with next word
vim.keymap.set("n", "cx", "<Plug>SwapWordsw", { desc = "Swap words" })
vim.keymap.set("n", "cX", "<Plug>SwapWords", { desc = "Swap Words" })

-- readline input bindings
vim.keymap.set("i", "<M-f>", "<C-o>w", { noremap = true, desc = "Move cursor one word forward" })
vim.keymap.set("i", "<M-b>", "<C-o>b", { noremap = true, desc = "Move cursor one word back" })

-- Reload colorscheme
vim.keymap.set("n", "<F5>", ":<C-u>ColorschemeAuto!<CR>", { silent = true, noremap = true, desc = "Trigger auto colorscheme" })

-- Toggle paste
vim.keymap.set("n", "<F11>", ":<C-u>set invpaste<CR>", { silent = true, noremap = true, desc = "Toggle past mode" })
vim.keymap.set("i", "<F11>", "<C-o>:<C-u>set invpaste<CR>", { silent = true, noremap = true, desc = "Toggle past mode" })

-- Changes To The Default Behavior:
-- --------------------------------

-- ie = inner entire buffer - replaced by al in neovim 0.13
vim.keymap.set("o", "ie", ":exec 'normal! ggVG'<cr>", { noremap = true, desc = "inner entire buffer" })

-- iv = current viewable text in the buffer
vim.keymap.set("o", "iv", ":exec 'normal! HVL'<cr>", { noremap = true, desc = "inner visible buffer" })

-- replace within the visual selection
vim.keymap.set("x", "S", ":<C-u>%s/\\%V", { noremap = true, desc = "Replace within the visual selection" })

-- change default behavior of search, don't jump to the next matching word, stay
-- on the current one end
-- have a look at :h restore-position
-- nnoremap <silent> *  :let @/='\<'.expand('<cword>').'\>'<CR>:call histadd('search', @/)<CR>:if &hlsearch<Bar>set hlsearch<Bar>endif<CR>
-- nnoremap <silent> g* :let @/=expand('<cword>')<CR>:call histadd('search', @/)<CR>:if &hlsearch<Bar>set hlsearch<Bar>endif<CR>
-- nnoremap <silent> #  :let stay_star_view = winsaveview()<cr>#:call winrestview(stay_star_view)<CR>
-- nnoremap <silent> g# :let stay_star_view = winsaveview()<cr>g#:call winrestview(stay_star_view)<CR>

-- jump to the end of the previous word by
-- nmap <BS> ge

-- Search for the occurrence of the word under the cursor
-- nnoremap <silent> [I [I:let nr = input('Item: ')<Bar>if nr != ''<Bar>exe 'normal '.nr.'[\t'<Bar>endif<CR>
-- nnoremap <silent> ]I ]I:let nr = input('Item: ')<Bar>if nr != ''<Bar>exe 'normal '.nr.']\t'<Bar>endif<CR>
