-- Keymappings:
-- ------------

-- quick navigation between windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

vim.cmd([[
  " Directory name, stripped of .git dir to make it work for fugitive
  function! HereDir()
      let l:dir = substitute(substitute(substitute(substitute(expand('%:h:p'), "oil://", "", ""), "term://", "", ""), "fugitive://", "", ""), "jiejie://", "", "")
      if fnamemodify(l:dir, ":t") == ".git"
        let l:dir = fnamemodify(l:dir, ":h")
      elseif fnamemodify(l:dir, ":h:t") == ".jj"
          let l:dir = fnamemodify(l:dir, ":h:h")
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
vim.keymap.set("n", "cx", "<Plug>SwapWordsw", {})
vim.keymap.set("n", "cX", "<Plug>SwapWords", {})

-- select last paste visually
vim.keymap.set("n", "gV", "`]v`[", { noremap = true })

-- format paragraphs quickly
vim.keymap.set("n", "Q", "gwip", { noremap = true })
vim.keymap.set("x", "Q", "gw", { noremap = true })
-- quick json formatting of selection
vim.keymap.set("n", "<leader>ql", ":QFLoad<CR>", { noremap = true })
vim.keymap.set("n", "<leader>qs", ":QFSave!<CR>", { noremap = true })
vim.keymap.set("n", "<leader>qj", "vip:!jq .<CR>", { noremap = true })
vim.keymap.set("x", "<leader>qj", ":!jq .<CR>", { noremap = true })

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
vim.keymap.set("n", "Q", "<cmd>silent w#<CR>:echo 'Alternate file '.fnameescape(expand('#')).' written'<CR>", { noremap = true })
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
vim.keymap.set("n", "<leader>wt", "<cmd>tabe %<CR>", { noremap = true })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { noremap = true })
vim.keymap.set("n", "<leader>wV", "<cmd>vnew<CR>", { noremap = true })
vim.keymap.set("n", "<leader>x", "<cmd>x<CR>", { noremap = true })
-- nnoremap <silent> <leader>z <cmd>exec ":Goyo ".(exists('#goyo')?"":v:count==""?&tw==0?"":&tw+10:v:count)<CR>
-- vim.keymap.set("n", "<leader>z", "<cmd>MaximizerToggle<CR>", { noremap = true })
vim.keymap.set("n", "<leader>''", "<cmd>cq<CR>", { noremap = true, desc = "Quit with an error message, see https://github.com/jj-vcs/jj/issues/4414" })
vim.keymap.set("n", "<leader>[[", "<cmd>qa<CR>", { noremap = true, desc = "Quit all buffers" })
vim.keymap.set("n", "<leader>]]", "<cmd>qa!<CR>", { noremap = true, desc = "Quit all buffers and abandon unsaved changes" })

-- readline input bindings
vim.keymap.set("i", "<M-f>", "<C-o>w", { noremap = true })
vim.keymap.set("i", "<M-b>", "<C-o>b", { noremap = true })

-- Store relative line number jumps in the jumplist if they exceed a threshold.
-- thanks to https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.vim/plugin/mappings/normal.vim
vim.keymap.set("n", "k", "(v:count > 2 ? \"m'\" . v:count : '') . 'k'", { noremap = true, expr = true })
vim.keymap.set("n", "j", "(v:count > 2 ? \"m'\" . v:count : '') . 'j'", { noremap = true, expr = true })

-- Use C-g in command and insert mode as well
vim.keymap.set("n", "<C-g>", "1<C-g>", { noremap = true })
vim.keymap.set("c", "<C-g>", "<C-R>=expand('%:h').'/'<CR>", { noremap = true })
-- inoremap <C-g> <C-R>=expand('%:h').'/'<CR>

-- Toggle paste
vim.keymap.set("n", "<F11>", ":<C-u>set invpaste<CR>", { silent = true, noremap = true })
vim.keymap.set("i", "<F11>", "<C-o>:<C-u>set invpaste<CR>", { silent = true, noremap = true })

-- Changes To The Default Behavior:
-- --------------------------------

-- ie = inner entire buffer
vim.keymap.set("o", "ie", ":exec 'normal! ggVG'<cr>", { noremap = true })

-- iv = current viewable text in the buffer
vim.keymap.set("o", "iv", ":exec 'normal! HVL'<cr>", { noremap = true })

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

-- make Shift-Insert paste contents of the clipboard into terminal
vim.keymap.set("t", "<S-Insert>", '<C-\\><C-N>"*pi', { noremap = true })

-- " make n and N always search in the same direction
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { noremap = true, expr = true })

-- http://vim.wikia.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
vim.keymap.set("i", "<Esc>", "<Esc>`^", { silent = true, noremap = true })

-- Support Shift-Insert in all vim UIs
vim.keymap.set("n", "<S-Insert>", '"*P', { noremap = true })
vim.keymap.set("i", "<S-Insert>", '<C-o>"*P', { noremap = true })
vim.keymap.set("c", "<S-Insert>", "<C-r>*", { noremap = true })

-- make S behave like C
-- vim.keymap.set("n", "S", "C", { noremap = true })

-- replace within the visual selection
vim.keymap.set("x", "S", ":<C-u>%s/\\%V", { noremap = true })

-- local map leader
-- let maplocalleader = ','

-- disable <F1> mapping to open vim help - especially on Lenovo laptops <F1> is
-- in the way of <Esc> which is really annoying
vim.keymap.set("i", "<F1>", "<Nop>", { noremap = true })
vim.keymap.set("n", "<F1>", "<Nop>", { noremap = true })

-- change default behavior of search, don't jump to the next matching word, stay
-- on the current one end
-- have a look at :h restore-position
-- nnoremap <silent> *  :let @/='\<'.expand('<cword>').'\>'<CR>:call histadd('search', @/)<CR>:if &hlsearch<Bar>set hlsearch<Bar>endif<CR>
-- nnoremap <silent> g* :let @/=expand('<cword>')<CR>:call histadd('search', @/)<CR>:if &hlsearch<Bar>set hlsearch<Bar>endif<CR>
-- nnoremap <silent> #  :let stay_star_view = winsaveview()<cr>#:call winrestview(stay_star_view)<CR>
-- nnoremap <silent> g# :let stay_star_view = winsaveview()<cr>g#:call winrestview(stay_star_view)<CR>

-- start new undo sequences when using certain commands in insert mode
vim.keymap.set("i", "<C-U>", "<C-G>u<C-U>", { noremap = true })
vim.keymap.set("i", "<C-W>", "<C-G>u<C-W>", { noremap = true })
-- disable <BS> mapping to improve the autocompletion experience
-- inoremap <BS> <C-G>u<BS>
vim.keymap.set("i", "<C-H>", "<C-G>u<C-H>", { noremap = true })
vim.keymap.set("i", "<Del>", "<C-G>u<Del>", { noremap = true })

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

-- jump to the end of the previous word by
-- nmap <BS> ge

-- Search for the occurrence of the word under the cursor
-- nnoremap <silent> [I [I:let nr = input('Item: ')<Bar>if nr != ''<Bar>exe 'normal '.nr.'[\t'<Bar>endif<CR>
-- nnoremap <silent> ]I ]I:let nr = input('Item: ')<Bar>if nr != ''<Bar>exe 'normal '.nr.']\t'<Bar>endif<CR>

-- Enable the same behavior to <C-n> and <Down> / <C-p> and <Up> in command mode
vim.keymap.set("c", "<C-p>", "<Up>", { noremap = true })
vim.keymap.set("c", "<C-n>", "<Down>", { noremap = true })

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
