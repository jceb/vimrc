map = vim.keymap.set

-- Keymappings:
-- ------------

-- quick navigation between windows
-- nnoremap <C-h> <C-w>h
-- nnoremap <C-j> <C-w>j
-- nnoremap <C-k> <C-w>k
-- nnoremap <C-l> <C-w>l

vim.cmd([[
  " Directory name, stripped of .git dir to make it work for fugitive
  function! HereDir()
      let l:dir = substitute(expand('%:h:p'), "oil://", "", "")
      if fnamemodify(l:dir, ":t") == ".git"
          let l:dir = substitute(fnamemodify(l:dir, ":h"), "fugitive://", "", "")
      endif
      return l:dir
  endfunction
]])

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

map("n", "gy", ":<C-u>set opfunc=Yank<CR>g@", {
  silent = true,
  noremap = true,
})
map("n", "/", "/\\V", { noremap = true })
map("n", "?", "?\\V", { noremap = true })
map("c", "<M-b>", "<C-Left>", { silent = true, noremap = true })
map("c", "<M-f>", "<C-Right>", { silent = true, noremap = true })
map("n", "gyy", 'yy:<C-u>let @+=@"<CR>:echo "Copied default register to clipboard"<CR>',
  { silent = true, noremap = true })
map("n", "gY", 'y$:<C-u>let @+=@"<CR>:echo "Copied default register to clipboard"<CR>', { silent = true, noremap = true })
map("x", "gy", 'y:<C-u>let @+=@"<CR>:echo "Copied default register to clipboard"<CR>', { silent = true, noremap = true })
map("n", "yC", ':<C-u>let @"=@+<CR>:echo "Copied clipboard to default register"<CR>', {
  noremap = true,
})
map("n", "gyC", ':<C-u>let @+=@"<CR>:let @*=@+<CR>:echo "Copied default register to clipboard"<CR>', {
  noremap = true,
})
map("n", "ycc", ':<C-u>let @"=@+<CR>:let @*=@+<CR>:echo "Copied clipboard to default register"<CR>', { noremap = true })
-- copy file name of current buffer to clipboard
map(
  "n",
  "ycl",
  ':<C-u>let @"=substitute(expand("%"), "oil://", "", "").":".line(".")<CR>:echo "Copied filname to default register: ".@"<CR>',
  { noremap = true }
)
map(
  "n",
  "ycR",
  ':<C-u>let @"=substitute(expand("%:t"), "oil://", "", "").":".line(".")<CR>:echo "Copied filname to default register: ".@"<CR>',
  { noremap = true }
)
map(
  "n",
  "ycL",
  ':<C-u>let @"=substitute(expand("%:p"), "oil://", "", "").":".line(".")<CR>:echo "Copied filname to default register: ".@"<CR>',
  { noremap = true }
)
map("n", "ycF",
  ':<C-u>let @"=substitute(expand("%:p"), "oil://", "", "")<CR>:echo "Copied filname to default register: ".@"<CR>',
  { noremap = true })
map("n", "ycf",
  ':<C-u>let @"=substitute(expand("%"), "oil://", "", "")<CR>:echo "Copied filname to default register: ".@"<CR>',
  { noremap = true })
map("n", "ycr",
  ':<C-u>let @"=substitute(expand("%:t"), "oil://", "", "")<CR>:echo "Copied filname to default register: ".@"<CR>',
  { noremap = true })
-- map(
--     "n",
--     "ycp",
--     ":<C-u>let @\"=Yamlpath()<CR>:echo 'Copied YAML path to default register: '.@\"<CR>",
--     { noremap = true }
-- )
map("n", "ycp", "<cmd>YAMLYankKey<CR>", { noremap = true })
-- map("n", "yp", "<cmd>Yamlpath<CR>", { noremap = true })
map("n", "yp", "<cmd>YAMLView<CR>", { noremap = true })

-- fix Y
map("n", "Y", "y$", { noremap = true })

-- in addition to the gf and gF commands:
-- edit file and create it in case it doesn't exist
map("n", "gcf", ":<C-u>e %:h/<cfile><CR>", { noremap = true })
--- WARNING: gcf binding in visual mode is in conflict with vim commentary!
map("x", "<leader>gc", 'y:exec ":e ".fnameescape(substitute(expand("%:h"), "oil://", "", "")."/".getreg(\'"\'))<CR>',
  { noremap = true })

-- swap current word with next word
map(
  "n",
  "<Plug>SwapWords",
  ':<C-u>keeppatterns s/\\v(<\\k*%#\\k*>)(\\_.{-})(<\\k+>)/\\3\\2\\1/<Bar>:echo<Bar>:silent! call repeat#set("\\<Plug>SwapWords")<Bar>:normal ``<CR>',
  { silent = true, noremap = true }
)
-- swap current word with next word
map("n", "cx", "<Plug>SwapWordsw", {})
map("n", "cX", "<Plug>SwapWords", {})

-- select last paste visually
map("n", "gV", "`]v`[", { noremap = true })

-- format paragraphs quickly
map("n", "Q", "gwip", { noremap = true })
map("x", "Q", "gw", { noremap = true })
-- quick json formatting of selection
map("n", "<leader>ql", ":QFLoad<CR>", { noremap = true })
map("n", "<leader>qs", ":QFSave!<CR>", { noremap = true })
map("n", "<leader>qj", "vip:!jq .<CR>", { noremap = true })
map("x", "<leader>qj", ":!jq .<CR>", { noremap = true })

vim.cmd([[
function! Unload()
    let l:loaded = 'g:loaded_'.expand('%:t:r')
    if exists(l:loaded)
        echom "Unloaded."
        exec 'unlet '.l:loaded
    endif
endfunction
]])

-- nnoremap qf <cmd>set modifiable<CR><cmd>.!jq .<CR>
-- xnoremap qf :!jq .<CR>
-- nnoremap qsf <cmd>s/^ *"//<cr><cmd>s/"$//<cr><cmd>s/\\//<cr><cmd>normal qf<CR>
-- xnoremap qsf !jq -c<CR><cmd>s/"/\\"/<cr>I"<Esc>A"<Esc>0

-- use space key for something useful
map("n", "Q", "<cmd>silent w#<CR>:echo 'Alternate file '.fnameescape(expand('#')).' written'<CR>", { noremap = true })
map("n", "<leader>A", ":<C-u>NvimTreeOpen<CR>:doautocmd WinEnter<CR>", { silent = true, noremap = true })
map("n", "<leader>a", ":<C-u>NvimTreeToggle<CR>:doautocmd WinEnter<CR>", { silent = true, noremap = true })
map("n", "-", "<Plug>(dirvish_up)", {})
map("n", "<leader>.", ":<C-u>!mkdir %/", {})
map("n", "<leader>1", "1<C-w>w", { noremap = true })
map("n", "<leader>2", "2<C-w>w", { noremap = true })
map("n", "<leader>3", "3<C-w>w", { noremap = true })
map("n", "<leader>4", "4<C-w>w", { noremap = true })
map("n", "<leader>5", "5<C-w>w", { noremap = true })
map("n", "<leader>6", "6<C-w>w", { noremap = true })
map("n", "<leader>7", "7<C-w>w", { noremap = true })
map("n", "<leader>8", "8<C-w>w", { noremap = true })
map("n", "<leader>9", "9<C-w>w", { noremap = true })
map("n", "<leader><leader>", "<cmd>update<CR>", { noremap = true })
map("n", "<leader>bd", "<cmd>Sayonara!<CR>", { noremap = true })
map("n", "<leader>bf", "<cmd>FormatWrite<CR>", { noremap = true })
-- map("n", "<leader>bm", "<cmd>JABSOpen<CR>", { noremap = true })
map("n", "<leader>bW", "<cmd>bw #<CR>", { noremap = true })
map("n", "<leader>D", "<cmd>Sayonara!<CR>", { noremap = true })
map("n", "<leader>bw", "<cmd>bw<CR>", { noremap = true })
map("n", "<leader>cd", "<cmd>WindoTcd<CR>", { noremap = true })
map("n", "<leader>cr", "<cmd>WindoTcdroot<CR>", { noremap = true })
map("n", "<leader>d", "<cmd>Sayonara<CR>", { noremap = true })
map("n", "<leader>er", "<cmd>e<CR>", { noremap = true })
map("n", "<leader>eR", "<cmd>e!<CR>", { noremap = true })
map("n", "<leader>E", "<cmd>e!<CR>", { noremap = true })
map("n", "<leader>ec", ":<C-u>e ~/.config/", { noremap = true })
map("n", "<leader>ee", ":<C-u>e %/", { noremap = true })
map("n", "<leader>eh", ":<C-u>e ~/", { noremap = true })
map("n", "<leader>et", ":<C-u>e /tmp/", { noremap = true })
map("n", "<leader>gg", "<cmd>Grepper -tool git<CR>", { noremap = true })
map("n", "<leader>H", "<C-w>H", { noremap = true })
map("n", "<leader>h", "<C-w>h", { noremap = true })
map("n", "<leader>I", '"+P', { noremap = true })
map("n", "<leader>i", '"*P', { noremap = true })
map("n", "<leader>J", "<C-w>J", { noremap = true })
map("n", "<leader>j", "<C-w>j", { noremap = true })
map("n", "<leader>K", "<C-w>K", { noremap = true })
map("n", "<leader>k", "<C-w>k", { noremap = true })
map("n", "<leader>L", "<C-w>L", { noremap = true })
map("n", "<leader>l", "<C-w>l", { noremap = true })
map("n", "<leader>M", ":<C-u>Neomake ", { noremap = true })
map("n", "<leader>m", "<cmd>Neomake<CR>", { noremap = true })
map("n", "<leader>O", "<cmd>call LocationToggle()<CR>", { noremap = true })
map("n", "<leader>o", "<cmd>call QFixToggle()<CR>", { noremap = true })
map("n", "<leader>pd", "<cmd>e ~/Documents/dotfiles<CR>", { noremap = true })
map("n", "<leader>PD", "<cmd>e ~/Documents/dotfiles_secret<CR>", { noremap = true })
map("n", "<leader>pc", "<cmd>e ~/.config<CR>", { noremap = true })
map("n", "<leader>pG", "<cmd>Grepper -dir repo,cwd<CR>", { noremap = true })
map("n", "<leader>pi", "<cmd>e ~/Documents/work/identinet<CR>", { noremap = true })
map("n", "<leader>PP", "<cmd>pwd<CR>", { noremap = true })
map("n", "<leader>pp", "<C-w>p<CR>", { noremap = true })
map("n", "<leader>pP", "<cmd>e ~/Documents/Projects<CR>", { noremap = true })
map("n", "<leader>pr", "<cmd>exec 'e '.fnameescape(GetRootDir(getcwd()))<CR>", { noremap = true })
map("n", "<leader>pR", "<cmd>exec 'e '.fnameescape(GetRootDir())<CR>", { noremap = true })
map("n", "<leader>ps", "<cmd>e ~/Documents/Software<CR>", { noremap = true })
map(
  "n",
  "<leader>PS",
  -- reset snippets and then reload them to avoid a duplication of snippets
  "<cmd>lua require('luasnip').snippets = { all = {}}; require('luasnip/loaders/from_vscode').load({})<CR>",
  { noremap = true }
)
map("n", "<leader>fka", ":<C-U>!kubectl apply -f %", { noremap = true })
map("n", "<leader>fkd", ":<C-u>!kubectl delete -f %", { noremap = true })
map("n", "<leader>PU", "<cmd>Lazy<CR>", { noremap = true })
map("n", "<leader>pv", "<cmd>e ~/.config/nvim<CR>", { noremap = true })
map("n", "<leader>pw", "<cmd>e ~/Documents/work/consulting<CR>", { noremap = true })
map(
  "n",
  "<leader>so",
  "<cmd>if &filetype == 'vim' || &filetype == 'lua'<Bar>call Unload()<Bar>so %<Bar>echom 'Reloaded.'<Bar>else<Bar>echom 'Reloading only works for ft=vim.'<Bar>endif<CR>",
  { noremap = true }
)
map("n", "<leader>SS", ":<C-u>MiniSessionNew ", { noremap = true })
-- map("n", "<leader>ss", ":<C-u>so ~/.sessions/", { noremap = true })
map("n", "<leader>te", "<cmd>tabe<CR>", { noremap = true })
map("n", "<leader>tn", "<cmd>tabnew<CR>", { noremap = true })
-- nnoremap <leader>u <cmd>GundoToggle<CR>
map("n", "<leader>v", "<cmd>AerialToggle<CR>", { noremap = true })
map("n", "<leader>V", "<cmd>AerialNavToggle<CR>", { noremap = true })
map("n", "<leader>w", "<C-w>", { noremap = true })
-- t:is_maximized=v:false is a workaround to avoid confusing vim-maximizer
map("n", "<leader>w=", "<cmd>let t:is_maximized=v:false<cr><C-w>=", { noremap = true })
map("n", "<leader>wd", "<C-w>c", { noremap = true })
map("n", "<leader>we", "<cmd>vnew<CR>", { noremap = true })
map("n", "<leader>ws", "<C-w>s", { noremap = true })
map("n", "<leader>wS", "<cmd>new<CR>", { noremap = true })
map("n", "<leader>wt", "<cmd>tabe %<CR>", { noremap = true })
map("n", "<leader>wv", "<C-w>v", { noremap = true })
map("n", "<leader>wV", "<cmd>vnew<CR>", { noremap = true })
map("n", "<leader>x", "<cmd>x<CR>", { noremap = true })
-- nnoremap <silent> <leader>z <cmd>exec ":Goyo ".(exists('#goyo')?"":v:count==""?&tw==0?"":&tw+10:v:count)<CR>
-- map("n", "<leader>z", "<cmd>MaximizerToggle<CR>", { noremap = true })
map("n", "<leader>z", "<cmd>lua require('maximizer').toggle()<CR>", { noremap = true, silent = true })
map("n", "<leader>Z", "<cmd>ZenMode<CR>", { silent = true, noremap = true })
map("n", "<leader>[[", "<cmd>qa<CR>", { noremap = true })
map("n", "<leader>]]", "<cmd>qa!<CR>", { noremap = true })

-- readline input bindings
map("i", "<M-f>", "<C-o>w", { noremap = true })
map("i", "<M-b>", "<C-o>b", { noremap = true })

-- Store relative line number jumps in the jumplist if they exceed a threshold.
-- thanks to https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.vim/plugin/mappings/normal.vim
map("n", "k", "(v:count > 2 ? \"m'\" . v:count : '') . 'k'", { noremap = true, expr = true })
map("n", "j", "(v:count > 2 ? \"m'\" . v:count : '') . 'j'", { noremap = true, expr = true })

-- Use C-g in command and insert mode as well
map("n", "<C-g>", "1<C-g>", { noremap = true })
map("c", "<C-g>", "<C-R>=expand('%:h').'/'<CR>", { noremap = true })
-- inoremap <C-g> <C-R>=expand('%:h').'/'<CR>

-- Toggle paste
map("n", "<F11>", ":<C-u>set invpaste<CR>", { silent = true, noremap = true })
map("i", "<F11>", "<C-o>:<C-u>set invpaste<CR>", { silent = true, noremap = true })

-- Changes To The Default Behavior:
-- --------------------------------

-- ie = inner entire buffer
map("o", "ie", ":exec 'normal! ggVG'<cr>", { noremap = true })

-- iv = current viewable text in the buffer
map("o", "iv", ":exec 'normal! HVL'<cr>", { noremap = true })

-- use the same exit key for vim that's also configured in the terminal
map("i", "<C-\\><C-\\>", "<Esc>", { noremap = true })
map("i", "", "<Esc>", { noremap = true })
map("i", "<C-/><C-/>", "<Esc>", { noremap = true })
-- noremap <C-\><C-\> <Esc>
-- noremap  <Esc>
-- noremap <C-/><C-/> <Esc>
map("c", "<C-\\><C-\\>", "<Esc>", { noremap = true })
map("c", "", "<Esc>", { noremap = true })
map("c", "<C-/><C-/>", "<Esc>", { noremap = true })

-- shortcut for exiting terminal input mode
map("t", "<C-\\><C-\\>", "<C-\\><C-n>", { noremap = true })
map("t", "", "<C-\\><C-n>", { noremap = true })
map("t", "<C-/><C-/>", "<C-\\><C-n>", { noremap = true })

-- make Shift-Insert paste contents of the clipboard into terminal
map("t", "<S-Insert>", '<C-\\><C-N>"*pi', { noremap = true })

-- " make n and N always search in the same direction
map("n", "n", "'Nn'[v:searchforward]", { noremap = true, expr = true })
map("n", "N", "'nN'[v:searchforward]", { noremap = true, expr = true })

-- http://vim.wikia.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
map("i", "<Esc>", "<Esc>`^", { silent = true, noremap = true })

-- Support Shift-Insert in all vim UIs
map("n", "<S-Insert>", '"*P', { noremap = true })
map("i", "<S-Insert>", '<C-o>"*P', { noremap = true })
map("c", "<S-Insert>", "<C-r>*", { noremap = true })

-- make S behave like C
-- map("n", "S", "C", { noremap = true })

-- replace within the visual selection
map("x", "s", ":<C-u>%s/\\%V", { noremap = true })

-- local map leader
-- let maplocalleader = ','

-- disable <F1> mapping to open vim help - especially on Lenovo laptops <F1> is
-- in the way of <Esc> which is really annoying
map("i", "<F1>", "<Nop>", { noremap = true })
map("n", "<F1>", "<Nop>", { noremap = true })

-- change default behavior of search, don't jump to the next matching word, stay
-- on the current one end
-- have a look at :h restore-position
-- nnoremap <silent> *  :let @/='\<'.expand('<cword>').'\>'<CR>:call histadd('search', @/)<CR>:if &hlsearch<Bar>set hlsearch<Bar>endif<CR>
-- nnoremap <silent> g* :let @/=expand('<cword>')<CR>:call histadd('search', @/)<CR>:if &hlsearch<Bar>set hlsearch<Bar>endif<CR>
-- nnoremap <silent> #  :let stay_star_view = winsaveview()<cr>#:call winrestview(stay_star_view)<CR>
-- nnoremap <silent> g# :let stay_star_view = winsaveview()<cr>g#:call winrestview(stay_star_view)<CR>

-- start new undo sequences when using certain commands in insert mode
map("i", "<C-U>", "<C-G>u<C-U>", { noremap = true })
map("i", "<C-W>", "<C-G>u<C-W>", { noremap = true })
-- disable <BS> mapping to improve the autocompletion experience
-- inoremap <BS> <C-G>u<BS>
map("i", "<C-H>", "<C-G>u<C-H>", { noremap = true })
map("i", "<Del>", "<C-G>u<Del>", { noremap = true })

-- delete words in insert and command mode like expected - doesn't work properly
-- at the end of lines
map("i", "<C-BS>", "<C-G>u<C-w>", {})
map("c", "<C-BS>", "<C-w>", {})
map("i", "<C-Del>", "<C-o>dw", {})
map("c", "<C-Del>", "<C-Right><C-w>", {})
-- if !has('gui_running')
--     cmap <C-H> <C-w>
--     imap <C-H> <C-w>
-- endif

-- jump to the end of the previous word by
-- nmap <BS> ge

-- Search for the occurrence of the word under the cursor
-- nnoremap <silent> [I [I:let nr = input('Item: ')<Bar>if nr != ''<Bar>exe 'normal '.nr.'[\t'<Bar>endif<CR>
-- nnoremap <silent> ]I ]I:let nr = input('Item: ')<Bar>if nr != ''<Bar>exe 'normal '.nr.']\t'<Bar>endif<CR>

-- Enable the same behavior to <C-n> and <Down> / <C-p> and <Up> in command mode
map("c", "<C-p>", "<Up>", { noremap = true })
map("c", "<C-n>", "<Down>", { noremap = true })

vim.g.my_gui_font = "JetBrainsMono Nerd Font:h9"
vim.o.guifont = vim.fn.fnameescape(vim.g.my_gui_font)
vim.cmd([[
command! GuiFontBigger  :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)+1', ''))
command! GuiFontSmaller :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)-1', ''))
]])

map("n", "<C-0>", ":<C-u>exec ':set guifont='.fnameescape(g:my_gui_font)<CR>", { silent = true })
map("n", "<C-->", ":<C-u>GuiFontSmaller<CR>", { silent = true })
map("n", "<C-8>", ":<C-u>GuiFontSmaller<CR>", { silent = true })
map("n", "<C-ScrollWheelDown>", ":<C-u>GuiFontSmaller<CR>", { silent = true })
map("n", "<C-=>", ":<C-u>GuiFontBigger<CR>", { silent = true })
map("n", "<C-+>", ":<C-u>GuiFontBigger<CR>", { silent = true })
map("n", "<C-9>", ":<C-u>GuiFontBigger<CR>", { silent = true })
map("n", "<C-ScrollWheelUp>", ":<C-u>GuiFontBigger<CR>", { silent = true })
