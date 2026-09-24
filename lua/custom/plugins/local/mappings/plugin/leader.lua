-- Leader key mappings

-- use space key for something useful
vim.keymap.set("n", "<leader>1", "1<C-w>w", { noremap = true })
vim.keymap.set("n", "<leader>2", "2<C-w>w", { noremap = true })
vim.keymap.set("n", "<leader>3", "3<C-w>w", { noremap = true })
vim.keymap.set("n", "<leader>4", "4<C-w>w", { noremap = true })
vim.keymap.set("n", "<leader>5", "5<C-w>w", { noremap = true })
vim.keymap.set("n", "<leader>6", "6<C-w>w", { noremap = true })
vim.keymap.set("n", "<leader>7", "7<C-w>w", { noremap = true })
vim.keymap.set("n", "<leader>8", "8<C-w>w", { noremap = true })
vim.keymap.set("n", "<leader>9", "9<C-w>w", { noremap = true })
vim.keymap.set("n", "<leader><leader>", "<cmd>update<CR>", { noremap = true })
vim.keymap.set("n", "<leader>bf", "<cmd>FormatWrite<CR>", { noremap = true })
-- vim.keymap.set("n", "<leader>bm", "<cmd>JABSOpen<CR>", { noremap = true })
vim.keymap.set("n", "<leader>bW", "<cmd>bw #<CR>", { noremap = true })
vim.keymap.set("n", "<leader>bw", "<cmd>bw<CR>", { noremap = true })
vim.keymap.set("n", "<leader>cd", "<cmd>WindoTcd<CR>", { noremap = true })
vim.keymap.set("n", "<leader>cr", "<cmd>WindoTcdroot<CR>", { noremap = true })
vim.keymap.set("n", "<leader>er", "<cmd>e<CR>", { noremap = true })
vim.keymap.set("n", "<leader>eR", "<cmd>e!<CR>", { noremap = true })
vim.keymap.set("n", "<leader>E", "<cmd>e!<CR>", { noremap = true })
vim.keymap.set("n", "<leader>ec", ":<C-u>e ~/.config/", { noremap = true })
vim.keymap.set("n", "<leader>ee", ":<C-u>e %/", { noremap = true })
vim.keymap.set("n", "<leader>eh", ":<C-u>e ~/", { noremap = true })
vim.keymap.set("n", "<leader>et", ":<C-u>e /tmp/", { noremap = true })
vim.keymap.set("n", "<leader>H", "<C-w>H", { noremap = true })
vim.keymap.set("n", "<leader>h", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<leader>gV", '"*P', { noremap = true })
vim.keymap.set("n", "<leader>gv", '"*p', { noremap = true })
vim.keymap.set("n", "<leader>J", "<C-w>J", { noremap = true })
vim.keymap.set("n", "<leader>j", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<leader>K", "<C-w>K", { noremap = true })
vim.keymap.set("n", "<leader>k", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<leader>L", "<C-w>L", { noremap = true })
vim.keymap.set("n", "<leader>l", "<C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>ol", "<cmd>call LocationToggle()<CR>", { noremap = true })
vim.keymap.set("n", "<leader>oo", "<cmd>call QFixToggle()<CR>", { noremap = true })
vim.keymap.set("n", "<leader>pd", "<cmd>e ~/Documents/dotfiles<CR>", { noremap = true })
vim.keymap.set("n", "<leader>PD", "<cmd>e ~/Documents/dotfiles_secret<CR>", { noremap = true })
vim.keymap.set("n", "<leader>pc", "<cmd>e ~/.config<CR>", { noremap = true })
vim.keymap.set("n", "<leader>pi", "<cmd>e ~/Documents/work/identinet<CR>", { noremap = true })
vim.keymap.set("n", "<leader>PP", "<cmd>pwd<CR>", { noremap = true })
vim.keymap.set("n", "<leader>pp", "<C-w>p<CR>", { noremap = true })
vim.keymap.set("n", "<leader>pP", "<cmd>e ~/Documents/Projects<CR>", { noremap = true })
vim.keymap.set("n", "<leader>pr", "<cmd>exec 'e '.fnameescape(GetRootDir(getcwd()))<CR>", { noremap = true })
vim.keymap.set("n", "<leader>pR", "<cmd>exec 'e '.fnameescape(GetRootDir())<CR>", { noremap = true })
vim.keymap.set("n", "<leader>ps", "<cmd>e ~/Documents/Software<CR>", { noremap = true })
vim.keymap.set(
  "n",
  "<leader>PS",
  -- reset snippets and then reload them to avoid a duplication of snippets
  "<cmd>lua require('luasnip').snippets = { all = {}}; require('luasnip/loaders/from_vscode').load({})<CR>",
  { noremap = true }
)
vim.keymap.set("n", "<leader>fka", ":<C-U>!kubectl apply -f %", { noremap = true })
vim.keymap.set("n", "<leader>fkd", ":<C-u>!kubectl delete -f %", { noremap = true })
vim.keymap.set("n", "<leader>PU", "<cmd>Lazy<CR>", { noremap = true })
vim.keymap.set("n", "<leader>pv", "<cmd>e ~/.config/nvim<CR>", { noremap = true })
vim.keymap.set("n", "<leader>pw", "<cmd>e ~/Documents/work/consulting<CR>", { noremap = true })

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

-- vim.keymap.set("n", "<leader>ss", ":<C-u>so ~/.sessions/", { noremap = true })
vim.keymap.set("n", "<leader>te", "<cmd>tabe<CR>", { noremap = true })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { noremap = true })
-- nnoremap <leader>u <cmd>GundoToggle<CR>
vim.keymap.set("n", "<leader>u", "<cmd>Undotree<CR>", { noremap = true })
vim.keymap.set("n", "<leader>w", "<C-w>", { noremap = true })
vim.keymap.set("n", "<leader>wa", ":wa<CR>", { noremap = true })
-- t:is_maximized=v:false is a workaround to avoid confusing vim-maximizer
vim.keymap.set("n", "<leader>w=", "<cmd>let t:is_maximized=v:false<cr><C-w>=", { noremap = true })
-- vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true })
-- vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true })
-- vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true })
-- vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true })
-- vim.keymap.set("n", "<leader>wd", "<C-w>c", { noremap = true })
-- vim.keymap.set("n", "<leader>we", "<cmd>vnew<CR>", { noremap = true })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { noremap = true })
vim.keymap.set("n", "<leader>wS", "<cmd>new<CR>", { noremap = true })
vim.keymap.set("n", "<leader>wt", function()
  local filename = vim.fn.expand("%")
  if filename == "" then
    filename = vim.fn.expand("%:p:h")
  end
  vim.cmd.tabe(filename)
end, { noremap = true })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { noremap = true })
vim.keymap.set("n", "<leader>wV", "<cmd>vnew<CR>", { noremap = true })
vim.keymap.set("n", "<leader>x", "<cmd>x<CR>", { noremap = true })
-- nnoremap <silent> <leader>z <cmd>exec ":Goyo ".(exists('#goyo')?"":v:count==""?&tw==0?"":&tw+10:v:count)<CR>
-- vim.keymap.set("n", "<leader>z", "<cmd>MaximizerToggle<CR>", { noremap = true })
vim.keymap.set("n", "<leader>''", "<cmd>cq<CR>", { noremap = true, desc = "Quit with an error message, see https://github.com/jj-vcs/jj/issues/4414" })
vim.keymap.set("n", "<leader>[[", "<cmd>qa<CR>", { noremap = true, desc = "Quit all buffers" })
vim.keymap.set("n", "<leader>]]", "<cmd>qa!<CR>", { noremap = true, desc = "Quit all buffers and abandon unsaved changes" })
