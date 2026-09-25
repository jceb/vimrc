-- Leader key mappings

-- use space key for something useful
vim.keymap.set(
  "n",
  "<leader>PS",
  "<cmd>lua require('luasnip').snippets = { all = {}}; require('luasnip/loaders/from_vscode').load({})<CR>",
  { noremap = true, desc = "Reload lua snippets" }
) -- reset snippets and then reload them to avoid a duplication of snippets
vim.keymap.set("n", "<leader>1", "1<C-w>w", { noremap = true, desc = "Jump to window with this number" })
vim.keymap.set("n", "<leader>2", "2<C-w>w", { noremap = true, desc = "Jump to window with this number" })
vim.keymap.set("n", "<leader>3", "3<C-w>w", { noremap = true, desc = "Jump to window with this number" })
vim.keymap.set("n", "<leader>4", "4<C-w>w", { noremap = true, desc = "Jump to window with this number" })
vim.keymap.set("n", "<leader>5", "5<C-w>w", { noremap = true, desc = "Jump to window with this number" })
vim.keymap.set("n", "<leader>6", "6<C-w>w", { noremap = true, desc = "Jump to window with this number" })
vim.keymap.set("n", "<leader>7", "7<C-w>w", { noremap = true, desc = "Jump to window with this number" })
vim.keymap.set("n", "<leader>8", "8<C-w>w", { noremap = true, desc = "Jump to window with this number" })
vim.keymap.set("n", "<leader>9", "9<C-w>w", { noremap = true, desc = "Jump to window with this number" })
vim.keymap.set("n", "<leader><leader>", "<cmd>update<CR>", { noremap = true, desc = "Save buffer" })
vim.keymap.set("n", "<leader>bW", "<cmd>bw #<CR>", { noremap = true, desc = "Wipe alternate buffer" })
vim.keymap.set("n", "<leader>bw", "<cmd>bw<CR>", { noremap = true, desc = "Wipe buffer" })
vim.keymap.set("n", "<leader>cd", "<cmd>WindoTcd<CR>", { noremap = true, desc = "Change directory for all windows to the buffer's directory" })
vim.keymap.set("n", "<leader>cr", "<cmd>WindoTcdroot<CR>", { noremap = true, desc = "Change directory for all windows to the buffer's root directory" })
vim.keymap.set("n", "<leader>E", "<cmd>e!<CR>", { noremap = true, desc = "Reload buffer and abandon unsaved changes" })
vim.keymap.set("n", "<leader>ec", ":<C-u>e ~/.config/", { noremap = true, desc = "Edit file in ~/.config" })
vim.keymap.set("n", "<leader>ee", ":<C-u>e %/", { noremap = true, desc = "Edit file in the current directory" })
vim.keymap.set("n", "<leader>eh", ":<C-u>e ~/", { noremap = true, desc = "Edit file in ~/" })
vim.keymap.set("n", "<leader>eR", "<cmd>e!<CR>", { noremap = true, desc = "Reload buffer and abandon unsaved changes" })
vim.keymap.set("n", "<leader>er", "<cmd>e<CR>", { noremap = true, desc = "Reload buffer" })
vim.keymap.set("n", "<leader>eR", "<cmd>exec 'e '.fnameescape(GetRootDir())<CR>", { noremap = true, desc = "Edit root directory" })
vim.keymap.set("n", "<leader>er", "<cmd>exec 'e '.fnameescape(GetRootDir(getcwd()))<CR>", { noremap = true, desc = "Edit root directory" })
vim.keymap.set("n", "<leader>et", ":<C-u>e /tmp/", { noremap = true, desc = "Edit file in /tmp" })
vim.keymap.set("n", "<leader>ev", "<cmd>e ~/.config/nvim<CR>", { noremap = true, desc = "Edit vim" })
vim.keymap.set("n", "<leader>fka", ":<C-U>!kubectl apply -f %", { noremap = true, desc = "kubectl apply current file" })
vim.keymap.set("n", "<leader>fkd", ":<C-u>!kubectl delete -f %", { noremap = true, desc = "kubectl delete current file" })
vim.keymap.set("n", "<leader>fm", ":<C-u>Move %", { noremap = true, desc = "Move file to a new name" })
vim.keymap.set("n", "<leader>w", "<C-w>", { noremap = true, desc = "Alias for <C-w>" })
vim.keymap.set("n", "<leader>H", "<C-w>H", { noremap = true, desc = "Alias for <C-w>H" })
vim.keymap.set("n", "<leader>h", "<C-w>h", { noremap = true, desc = "Alias for <C-w>h" })
vim.keymap.set("n", "<leader>J", "<C-w>J", { noremap = true, desc = "Alias for <C-w>J" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { noremap = true, desc = "Alias for <C-w>j" })
vim.keymap.set("n", "<leader>K", "<C-w>K", { noremap = true, desc = "Alias for <C-w>K" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { noremap = true, desc = "Alias for <C-w>k" })
vim.keymap.set("n", "<leader>L", "<C-w>L", { noremap = true, desc = "Alias for <C-w>L" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { noremap = true, desc = "Alias for <C-w>l" })
vim.keymap.set("n", "<leader>pp", "<C-w>p<CR>", { noremap = true, desc = "Alias for <C-w>p" })
vim.keymap.set("n", "<leader>PP", "<cmd>pwd<CR>", { noremap = true, desc = "Print current directory" })
vim.keymap.set("n", "<leader>PU", "<cmd>Lazy<CR>", { noremap = true, desc = "Open lazy" })

vim.cmd([[
function! Unload()
    let l:loaded = 'g:loaded_'.expand('%:t:r')
    if exists(l:loaded)
        echom "Unloaded."
        exec 'unlet '.l:loaded
    endif
endfunction
]])
vim.keymap.set(
  "n",
  "<leader>so",
  "<cmd>if &filetype == 'vim' || &filetype == 'lua'<Bar>call Unload()<Bar>so %<Bar>echom 'Reloaded.'<Bar>else<Bar>echom 'Reloading only works for ft=vim.'<Bar>endif<CR>",
  { noremap = true }
)

vim.keymap.set("n", "<leader>te", "<cmd>tabe<CR>", { noremap = true, desc = "Alias for :tabe" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { noremap = true, desc = "Alias for :tabnew" })
vim.keymap.set("n", "<leader>u", "<cmd>Undotree<CR>", { noremap = true, desc = "Toggle Undotree" })
vim.keymap.set("n", "<leader>wa", "<cmd>wa<CR>", { noremap = true, desc = "Save all files" })
vim.keymap.set("n", "<leader>wS", "<cmd>new<CR>", { noremap = true, desc = "Split a new buffer" })
vim.keymap.set("n", "<leader>wt", function()
  local filename = vim.fn.expand("%")
  if filename == "" then
    filename = vim.fn.expand("%:p:h")
  end
  vim.cmd.tabe(filename)
end, { noremap = true })
vim.keymap.set("n", "<leader>wV", "<cmd>vnew<CR>", { noremap = true, desc = "Vertical split a new buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>x<CR>", { noremap = true, desc = "Alias for :x" })
vim.keymap.set("n", "<leader>''", "<cmd>cq<CR>", { noremap = true, desc = "Quit with an error message, see https://github.com/jj-vcs/jj/issues/4414" })
vim.keymap.set("n", "<leader>[[", "<cmd>qa<CR>", { noremap = true, desc = "Quit all buffers" })
vim.keymap.set("n", "<leader>]]", "<cmd>qa!<CR>", { noremap = true, desc = "Quit all buffers and abandon unsaved changes" })

-- Mappings for working with the quickfix and location list window
vim.keymap.set("n", "<leader>qq", "<cmd>call QFixToggle()<CR>", { noremap = true, desc = "Toggle quickfix window" })
vim.keymap.set("n", "<leader>ql", ":QFLoad<CR>", { noremap = true, desc = "Load quickfix list" })
vim.keymap.set("n", "<leader>qs", ":QFSave!<CR>", { noremap = true, desc = "Save quickfix list" })
vim.keymap.set("n", "<leader>oo", "<cmd>call LocationToggle()<CR>", { noremap = true, desc = "Toggle location window" })

-- format paragraphs quickly
-- vim.keymap.set("n", "Q", "gwip", { noremap = true }) -- mapping interfers with the multicursor feature
-- vim.keymap.set("x", "Q", "gw", { noremap = true })
