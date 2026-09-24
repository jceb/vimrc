-- Mappings related to yanking text

-- yank to clipboard
vim.cmd([[
function! Yank(type, ...)
    let sel_save = &selection
    let &selection = 'inclusive'
    let reg_save = @@

    if a:0  " Invoked from Visual mode, use '< and '> marks.
        silent exe 'normal! `<'.a:type."`>y"
    elseif a:type == 'line'
        silent exe "normal! '[V']y"
    elseif a:type == 'block'
        silent exe "normal! `[\<C-V>`]y"
    else
        silent exe "normal! `[v`]y"
    endif
    let @+ = @"
    let @* = @"

    let &selection = sel_save
    " enable this to restore the contents of register " otherwise keep them in
    " sync with the clipboard
    " let @@ = reg_save
endfunction
]])

vim.keymap.set("n", "gy", ":<C-u>set opfunc=Yank<CR>g@", { silent = true, noremap = true })
vim.keymap.set("n", "/", "/\\V", { noremap = true })
vim.keymap.set("n", "?", "?\\V", { noremap = true })
vim.keymap.set("n", "gyy", 'yy:<C-u>let @+=@"<CR>:echo "Copied default register to clipboard"<CR>', { silent = true, noremap = true })
vim.keymap.set("n", "gY", 'y$:<C-u>let @+=@"<CR>:echo "Copied default register to clipboard"<CR>', { silent = true, noremap = true })
vim.keymap.set("x", "gy", 'y:<C-u>let @+=@"<CR>:echo "Copied default register to clipboard"<CR>', { silent = true, noremap = true })
vim.keymap.set("n", "yC", ':<C-u>let @"=@+<CR>:echo "Copied clipboard to default register"<CR>', { noremap = true })
vim.keymap.set("n", "gyC", ':<C-u>let @+=@"<CR>:let @*=@+<CR>:echo "Copied default register to clipboard"<CR>', { noremap = true })
vim.keymap.set("n", "ycc", ':<C-u>let @"=@+<CR>:let @*=@+<CR>:echo "Copied clipboard to default register"<CR>', { noremap = true })
-- copy file name of current buffer to clipboard
vim.keymap.set(
  "n",
  "ycl",
  ':<C-u>let @"=substitute(expand("%"), "oil://", "", "").":".line(".")<CR>:echo "Copied filname to default register: ".@"<CR>',
  { noremap = true }
)
vim.keymap.set(
  "n",
  "ycR",
  ':<C-u>let @"=substitute(expand("%:t"), "oil://", "", "").":".line(".")<CR>:echo "Copied filname to default register: ".@"<CR>',
  { noremap = true }
)
vim.keymap.set(
  "n",
  "ycL",
  ':<C-u>let @"=substitute(expand("%:p"), "oil://", "", "").":".line(".")<CR>:echo "Copied filname to default register: ".@"<CR>',
  { noremap = true }
)
vim.keymap.set("n", "<leader>fm", ":<C-u>Move %", { noremap = true })
vim.keymap.set(
  "n",
  "ycF",
  ':<C-u>let @"=substitute(expand("%:p"), "oil://", "", "")<CR>:echo "Copied filname to default register: ".@"<CR>',
  { noremap = true }
)
vim.keymap.set("n", "ycr", ':<C-u>let @"=substitute(expand("%"), "oil://", "", "")<CR>:echo "Copied filname to default register: ".@"<CR>', { noremap = true })
vim.keymap.set(
  "n",
  "ycf",
  ':<C-u>let @"=substitute(expand("%:t"), "oil://", "", "")<CR>:echo "Copied filname to default register: ".@"<CR>',
  { noremap = true }
)
-- vim.keymap.set(
--     "n",
--     "ycp",
--     ":<C-u>let @\"=Yamlpath()<CR>:echo 'Copied YAML path to default register: '.@\"<CR>",
--     { noremap = true }
-- )

vim.keymap.set("n", "ycp", "<cmd>YAMLYankKey<CR>", { noremap = true })
-- vim.keymap.set("n", "yp", "<cmd>Yamlpath<CR>", { noremap = true })
vim.keymap.set("n", "yp", "<cmd>YAMLView<CR>", { noremap = true })

-- Support Shift-Insert in all vim UIs
vim.keymap.set("n", "<S-Insert>", '"*P', { noremap = true })
vim.keymap.set("i", "<S-Insert>", '<C-o>"*P', { noremap = true })
vim.keymap.set("c", "<S-Insert>", "<C-r>*", { noremap = true })
