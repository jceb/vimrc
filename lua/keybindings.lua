map = vim.api.nvim_set_keymap

-- Keymappings:
-- ------------

-- quick navigation between windows
-- nnoremap <C-h> <C-w>h
-- nnoremap <C-j> <C-w>j
-- nnoremap <C-k> <C-w>k
-- nnoremap <C-l> <C-w>l

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
map("c", "<M-b>", "<C-Left>", { silent = true, noremap = true })
map("c", "<M-f>", "<C-Right>", { silent = true, noremap = true })
map("n", "gyy", 'yy:<C-u>let @*=@+<CR>:let @+=@"<CR>', { silent = true, noremap = true })
map("n", "gY", 'y$:<C-u>let @*=@+<CR>:let @+=@"<CR>', { silent = true, noremap = true })
map("x", "gy", 'y:<C-u>let @*=@+<CR>:let @+=@"<CR>', { silent = true, noremap = true })
map("n", "yC", ":<C-u>let @+=@\"<CR>:let @*=@+<CR>:echo 'Copied default register to clipboard'<CR>", {
    noremap = true,
})
map("n", "gyC", ":<C-u>let @+=@\"<CR>:let @*=@+<CR>:echo 'Copied default register to clipboard'<CR>", {
    noremap = true,
})
map(
    "n",
    "ycc",
    ":<C-u>let @+=@\"<CR>:let @*=@+<CR>:echo 'Copied default register to clipboard'<CR>",
    { noremap = true }
)

-- copy file name of current buffer to clipboard
map(
    "n",
    "ycL",
    ":<C-u>let @\"=expand('%:p').':'.line('.')<CR>:echo 'Copied filname to default register: '.@\"<CR>",
    { noremap = true }
)
map(
    "n",
    "ycF",
    ":<C-u>let @\"=expand('%:p')<CR>:echo 'Copied filname to default register: '.@\"<CR>",
    { noremap = true }
)
map(
    "n",
    "ycl",
    ":<C-u>let @\"=expand('%:t').':'.line('.')<CR>:echo 'Copied filname to default register: '.@\"<CR>",
    { noremap = true }
)
map(
    "n",
    "ycf",
    ":<C-u>let @\"=expand('%:t')<CR>:echo 'Copied filname to default register: '.@\"<CR>",
    { noremap = true }
)
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
-- WARNING: gcf binding is in conflict with vim commentary!
map("n", "gcf", ":<C-u>e %:h/<cfile><CR>", { noremap = true })
map("x", "gcf", 'y:exec ":e ".fnameescape(expand("%:h")."/".getreg(\'"\'))<CR>', { noremap = true })

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
map("n", "<Space>ql", ":QFLoad<CR>", { noremap = true })
map("n", "<Space>qs", ":QFSave!<CR>", { noremap = true })
map("n", "<Space>qj", "vip:!jq .<CR>", { noremap = true })
map("x", "<Space>qj", ":!jq .<CR>", { noremap = true })

vim.cmd([[
" Directory name, stripped of .git dir to make it work for fugitive
function! HereDir()
    let l:dir = expand('%:h:p')
    if fnamemodify(l:dir, ":t") == ".git"
        let l:dir = substitute(fnamemodify(l:dir, ":h"), "fugitive://", "", "")
    endif
    return l:dir
endfunction

function! TnewHere()
    call neoterm#new({ 'cwd': HereDir() })
endfunction
command! -nargs=0 TnewHere :call TnewHere()

function! TnewProject()
    call neoterm#new({ 'cwd': GetRootDir(getcwd()) })
endfunction
command! -nargs=0 TnewProject :call TnewProject()

function! TnewProjectHere()
    call neoterm#new({ 'cwd': HereDir() })
endfunction
command! -nargs=0 TnewProjectHere :call TnewProjectHere()
]])

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
map("n", "<Space>fh", "<cmd>Telescope help_tags<CR>", { noremap = true })
map("n", "<Space>fy", "<cmd>Telescope keymaps<CR>", { noremap = true })
map("n", "<Space>A", ":<C-u>NvimTreeOpen<CR>:doautocmd WinEnter<CR>", { silent = true, noremap = true })
map("n", "<Space>a", ":<C-u>NvimTreeToggle<CR>:doautocmd WinEnter<CR>", { silent = true, noremap = true })
map("n", "-", "<Plug>(dirvish_up)", {})
map("n", "<Space>.", ":<C-u>!mkdir %/", {})
map("n", "<Space>?", "<cmd>Telescope man_pages<CR>", { noremap = true })
map("n", "<Space>1", "1<C-w>w", { noremap = true })
map("n", "<Space>2", "2<C-w>w", { noremap = true })
map("n", "<Space>3", "3<C-w>w", { noremap = true })
map("n", "<Space>4", "4<C-w>w", { noremap = true })
map("n", "<Space>5", "5<C-w>w", { noremap = true })
map("n", "<Space>6", "6<C-w>w", { noremap = true })
map("n", "<Space>7", "7<C-w>w", { noremap = true })
map("n", "<Space>8", "8<C-w>w", { noremap = true })
map("n", "<Space>9", "9<C-w>w", { noremap = true })
map("n", "<Space><Space>", "<cmd>update<CR>", { noremap = true })
map("n", "<Space>bb", "<cmd>Telescope buffers<CR>", { noremap = true })
map("n", "<Space>bc", "<cmd>exec 'Telescope git_bcommits cwd='.fnameescape(expand('%:h'))<CR>", { noremap = true })
map("n", "<Space>bd", "<cmd>Sayonara!<CR>", { noremap = true })
map("n", "<Space>be", "<cmd>Telescope lsp_document_diagnostics<CR>", { noremap = true })
map("n", "<Space>bf", "<cmd>FormatWrite<CR>", { noremap = true })
map(
    "n",
    "<Space>bH",
    "<cmd>exec 'FloatermNew --cwd='.fnameescape(expand('%:h:p')).' tig '.fnameescape(expand('%:p'))<CR>",
    { noremap = true }
)
map("n", "<Space>bh", "<cmd>Telescope git_bcommits<CR>", { noremap = true })
map("n", "<Space>bl", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { noremap = true })
-- map("n", "<Space>bm", "<cmd>JABSOpen<CR>", { noremap = true })
map("n", "<Space>bm", "<cmd>Telescope bookmark_picker<CR>", { noremap = true })
map("n", "<Space>bs", "<cmd>Telescope lsp_document_symbols<CR>", { noremap = true })
map("n", "<Space>bt", "<cmd>exec 'FloatermNew --cwd='.fnameescape(expand('%:h:p'))<CR>", { noremap = true })
-- map("n", "<Space>bt", "<cmd>Telescope current_buffer_tags<CR>", { noremap = true })
-- map("n", "<Space>bv", "<cmd>Telescope treesitter<CR>", { noremap = true })
map("n", "<Space>bW", "<cmd>bw #<CR>", { noremap = true })
map("n", "<Space>D", "<cmd>Sayonara!<CR>", { noremap = true })
map("n", "<Space>bw", "<cmd>bw<CR>", { noremap = true })
map("n", "<Space>cd", "<cmd>WindoTcd<CR>", { noremap = true })
map("n", "<Space>cr", "<cmd>WindoTcdroot<CR>", { noremap = true })
map("n", "<Space>d", "<cmd>Sayonara<CR>", { noremap = true })
map("n", "<Space>,u", "<Cmd>DapuiToggle<CR>", { noremap = true })
map("n", "<Space>,L", "<Cmd>DapLoadLaunchJSON<CR><cmd>echo 'Loaded JSON launch configuration.'<CR>", { noremap = true })
map("n", "<Space>,c", "<Cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true })
map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true })
map("n", "<Space>,b", "<Cmd>lua require'dap'.step_back()<CR>", { noremap = true, silent = true })
map("n", "<Space>,q", "<Cmd>DapStop<CR>", { noremap = true, silent = true })
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
map("n", "<Space>,o", "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
map("n", "<Space>,i", "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
map("n", "<Space>,,", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
map(
    "n",
    "<Space>,b",
    "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { noremap = true, silent = true }
)
map(
    "n",
    "<Space>,l",
    "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    { noremap = true, silent = true }
)
map("n", "<Space>,r", "<Cmd>DapToggleRepl<CR>", { noremap = true, silent = true })
map("n", "<Space>,R", "<Cmd>lua require'dap'.run_last()<CR>", { noremap = true, silent = true })
map("n", "<Space>er", "<cmd>e<CR>", { noremap = true })
map("n", "<Space>eR", "<cmd>e!<CR>", { noremap = true })
map("n", "<Space>E", "<cmd>e!<CR>", { noremap = true })
map("n", "<Space>ec", ":<C-u>e ~/.config/", { noremap = true })
map("n", "<Space>ee", ":<C-u>e %/", { noremap = true })
map("n", "<Space>eh", ":<C-u>e ~/", { noremap = true })
map("n", "<Space>et", ":<C-u>e /tmp/", { noremap = true })
map(
    "n",
    "<Space>fc",
    "<cmd>Telescope find_files find_command=['rg','--files','--hidden','--ignore-vcs','--glob=!.git'] hidden=true cwd=~/.config/<CR>",
    { noremap = true }
)
map("n", "<Space>fka", ":<C-U>!kubectl apply -f %", { noremap = true })
map("n", "<Space>fkd", ":<C-u>!kubectl delete -f %", { noremap = true })
-- map("n", "<Space>FE", "<cmd>exec 'Telescope file_browser cwd='.fnameescape(expand('%:h'))<CR>", { noremap = true })
-- map("n", "<Space>fe", "<cmd>Telescope file_browser<CR>", { noremap = true })
map(
    "n",
    "<Space>FF",
    '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=\'.fnameescape(expand("%:h"))<CR>',
    { noremap = true }
)
map(
    "n",
    "<Space>ff",
    "<cmd>Telescope find_files find_command=['rg','--files','--hidden','--ignore-vcs','--glob=!.git'] hidden=true<CR>",
    { noremap = true }
)
map("n", "<Space>FG", "<cmd>exec 'Telescope live_grep cwd='.fnameescape(expand('%:h'))<CR>", { noremap = true })
map("n", "<Space>fg", "<cmd>Telescope live_grep<CR>", { noremap = true })
map("n", "<Space>fl", "<cmd>Telescope loclist<CR>", { noremap = true })
map("n", "<Space>fm", ":<C-u>Move %", { noremap = true })
-- map("n", "<Space>fo", "<cmd>Telescope find_files find_command=['rg','--files','--hidden','--ignore-vcs','--glob=!.git'] hidden=true cwd=~/.config/<CR>", { noremap = true })
map("n", "<Space>fo", "<cmd>Telescope oldfiles<CR>", { noremap = true })
map("n", "<Space>fq", "<cmd>Telescope quickfix<CR>", { noremap = true })
map("n", "<Space>fr", "<cmd>Telescope neoclip<CR>", { noremap = true })
-- map("n", "<Space>ft", "<cmd>TodoTelescope<CR>", { noremap = true })
map(
    "n",
    "<Space>fv",
    "<cmd>Telescope find_files find_command=['rg','--files','--hidden','--ignore-vcs','--glob=!.git'] hidden=true cwd=~/.config/nvim/<CR>",
    { noremap = true }
)
map("n", "<Space>gb", "<cmd>exec 'Telescope git_branches cwd='.fnameescape(expand('%:h'))<CR>", { noremap = true })
map("n", "<Space>gB", "<cmd>Git blame<CR>", { noremap = true })
map("n", "<Space>gC", "<cmd>Git commit -s<CR>", { noremap = true })
map("n", "<Space>gc", "<cmd>Git commit<CR>", { noremap = true })
map("n", "<Space>gx", "<cmd>Git commit --no-verify<CR>", { noremap = true })
map("n", "<Space>GD", "<cmd>Gdiffsplit! HEAD<CR>", { noremap = true })
map("n", "<Space>gD", "<cmd>Gdiffsplit! HEAD<CR>", { noremap = true })
map("n", "<Space>gd", "<cmd>Gdiffsplit!<CR>", { noremap = true })
map("n", "<Space>ge", "<cmd>Gedit<CR>", { noremap = true })
map("n", "<Space>gf", "<cmd>Telescope git_files<CR>", { noremap = true })
map("n", "<Space>gg", "<cmd>Grepper -tool git<CR>", { noremap = true })
map("n", "<Space>gh", "<cmd>Telescope git_commits<CR>", { noremap = true })
map("n", "<Space>gi", "<cmd>FloatermNew lazygit<CR>", { noremap = true })
map("n", "<Space>gI", "<cmd>exec 'FloatermNew --cwd='.fnameescape(GetRootDir()).' lazygit'<CR>", { noremap = true })
map("n", "<Space>gl", "<cmd>0Gclog<CR>", { noremap = true })
map("n", "<Space>gL", "<cmd>Gclog<CR>", { noremap = true })
map("n", "<Space>gm", ":<C-u>Gmove ", { noremap = true })
map("n", "<Space>gp", "<cmd>exec 'Dispatch! -dir='.fnameescape(HereDir()).' git push'<CR>", { noremap = true })
map("n", "<Space>gs", "<cmd>Git<CR>", { noremap = true })
map("n", "<Space>gS", "<cmd>Telescope git_status<CR>", { noremap = true })
map("n", "<Space>gu", "<cmd>exec 'Dispatch! -dir='.fnameescape(HereDir()).' git pre'<CR>", { noremap = true })
map("n", "<Space>gw", "<cmd>Gwrite<CR>", { noremap = true })
map("n", "<Space>H", "<C-w>H", { noremap = true })
map("n", "<Space>h", "<C-w>h", { noremap = true })
map("n", "<Space>I", '"+P', { noremap = true })
map("n", "<Space>i", '"*P', { noremap = true })
map("n", "<Space>J", "<C-w>J", { noremap = true })
map("n", "<Space>j", "<C-w>j", { noremap = true })
map("n", "<Space>K", "<C-w>K", { noremap = true })
map("n", "<Space>k", "<C-w>k", { noremap = true })
map("n", "<Space>L", "<C-w>L", { noremap = true })
map("n", "<Space>l", "<C-w>l", { noremap = true })
map("n", "<Space>M", ":<C-u>Neomake ", { noremap = true })
map("n", "<Space>m", "<cmd>Neomake<CR>", { noremap = true })
map("n", "<Space>n", "<cmd>FloatermNew nnn -Q<CR>", { noremap = true })
map("n", "<Space>N", "<cmd>exec 'FloatermNew --cwd='.fnameescape(expand('%:h:p')).' nnn -Q'<CR>", { noremap = true })
map("n", "<Space>O", "<cmd>call LocationToggle()<CR>", { noremap = true })
map("n", "<Space>o", "<cmd>call QFixToggle()<CR>", { noremap = true })
map("n", "<Space>pd", "<cmd>Dirvish ~/Documents/dotfiles<CR>", { noremap = true })
map("n", "<Space>PD", "<cmd>Dirvish ~/Documents/dotfiles_secret<CR>", { noremap = true })
map("n", "<Space>pc", "<cmd>Dirvish ~/.config<CR>", { noremap = true })
map("n", "<Space>PC", "<cmd>source ~/.config/nvim/lua/plugins.lua<Bar>PackerCompile<CR>", { noremap = true })
-- map("n", "<Space>PE", "<cmd>exec 'Telescope file_browser cwd='.fnameescape(GetRootDir())<CR>", { noremap = true })
-- map( "n", "<Space>pe", "<cmd>exec 'Telescope file_browser cwd='.fnameescape(GetRootDir(getcwd()))<CR>", { noremap = true })
map(
    "n",
    "<Space>PF",
    '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=\'.fnameescape(GetRootDir())<CR>',
    { noremap = true }
)
map(
    "n",
    "<Space>Pf",
    '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=\'.fnameescape(GetRootDir())<CR>',
    { noremap = true }
)
map(
    "n",
    "<Space>pF",
    '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=\'.fnameescape(GetRootDir())<CR>',
    { noremap = true }
)
map(
    "n",
    "<Space>pf",
    '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=\'.fnameescape(GetRootDir(getcwd()))<CR>',
    {
        noremap = true,
    }
)
map("n", "<Space>pG", "<cmd>Grepper -dir repo,cwd<CR>", { noremap = true })
map("n", "<Space>PG", "<cmd>exec 'Telescope live_grep cwd='.fnameescape(GetRootDir())<CR>", { noremap = true })
map("n", "<Space>pg", "<cmd>exec 'Telescope live_grep cwd='.fnameescape(GetRootDir(getcwd()))<CR>", { noremap = true })
map("n", "<Space>pi", "<cmd>Dirvish ~/Documents/work/identinet<CR>", { noremap = true })
map("n", "<Space>PP", "<cmd>pwd<CR>", { noremap = true })
map("n", "<Space>pp", "<C-w>p<CR>", { noremap = true })
map("n", "<Space>pP", "<cmd>Dirvish ~/Documents/Projects<CR>", { noremap = true })
map("n", "<Space>pr", "<cmd>exec 'Dirvish '.fnameescape(GetRootDir(getcwd()))<CR>", { noremap = true })
map("n", "<Space>pR", "<cmd>exec 'Dirvish '.fnameescape(GetRootDir())<CR>", { noremap = true })
map("n", "<Space>ps", "<cmd>Dirvish ~/Documents/Software<CR>", { noremap = true })
map(
    "n",
    "<Space>PS",
    -- reset snippets and then reload them to avoid a duplication of snippets
    "<cmd>lua require('luasnip').snippets = { all = {}}; require('luasnip/loaders/from_vscode').load({})<CR>",
    { noremap = true }
)
map("n", "<Space>PU", "<cmd>PackerSync<CR>", { noremap = true })
map("n", "<Space>ptF", "<cmd>exec 'FloatermNew --cwd='.fnameescape(GetRootDir())<CR>", { noremap = true })
map("n", "<Space>ptf", "<cmd>exec 'FloatermNew --cwd=<root>'<CR>", { noremap = true })
map("n", "<Space>ptS", "<cmd>split +TnewProjectHere<CR>", { noremap = true })
map("n", "<Space>ptT", "<cmd>tabe +TnewProjectHere<CR>", { noremap = true })
map("n", "<Space>ptV", "<cmd>vsplit +TnewProjectHere<CR>", { noremap = true })
map("n", "<Space>pts", "<cmd>split +TnewProject<CR>", { noremap = true })
map("n", "<Space>ptt", "<cmd>tabe +TnewProject<CR>", { noremap = true })
map("n", "<Space>ptv", "<cmd>vsplit +TnewProject<CR>", { noremap = true })
map("n", "<Space>pv", "<cmd>Dirvish ~/.config/nvim<CR>", { noremap = true })
map(
    "n",
    "<Space>pV",
    '<cmd>exec \'Telescope find_files find_command=["rg","--files","--hidden","--ignore-vcs","--glob=!.git"] hidden=true cwd=~/.config/nvim\'<CR>',
    { noremap = true }
)
map("n", "<Space>pw", "<cmd>Dirvish ~/Documents/work/consulting<CR>", { noremap = true })
map("x", "<Space>r", "<cmd><Plug>(neoterm-repl-send)!<CR>", {})
map("n", "<Space>r", "<Plug>(neoterm-repl-send-line)", {})
map("n", "<Space>R", "<Plug>(neoterm-repl-send)", {})
map("n", "<Space>se", ":<C-u>SudoEdit", { noremap = true })
map(
    "n",
    "<Space>so",
    "<cmd>if &filetype == 'vim' || &filetype == 'lua'<Bar>call Unload()<Bar>so %<Bar>echom 'Reloaded.'<Bar>else<Bar>echom 'Reloading only works for ft=vim.'<Bar>endif<CR>",
    { noremap = true }
)
map("n", "<Space>SS", ":<C-u>Obsession ~/.sessions/", { noremap = true })
-- map("n", "<Space>ss", ":<C-u>so ~/.sessions/", { noremap = true })
map("n", "<Space>ss", "<cmd>Telescope sessions_picker<CR>", { noremap = true })
map("n", "<Space>sw", "<cmd>SudoWrite<CR>", { noremap = true })
map("n", "<Space>tb", "<cmd>Telescope builtin<CR>", { noremap = true })
map("n", "<Space>tc", "<cmd>Telescope commands<CR>", { noremap = true })
map("n", "<Space>tk", "<cmd>Telescope keymaps<CR>", { noremap = true })
map("n", "<Space>te", "<cmd>tabe<CR>", { noremap = true })
map("n", "<Space>TF", "<cmd>exec 'FloatermNew --cwd='.fnameescape(expand('%:h:p'))<CR>", { noremap = true })
map("n", "<Space>tF", "<cmd>exec 'FloatermNew --cwd='.fnameescape(expand('%:h:p'))<CR>", { noremap = true })
map("n", "<Space>tf", "<cmd>FloatermNew<CR>", { noremap = true })
map("n", "<Space>tn", "<cmd>tabnew<CR>", { noremap = true })
map("n", "<Space>tq", "<cmd>Telescope quickfix<CR>", { noremap = true })
map("n", "<Space>tr", "<cmd>call neoterm#repl#term(b:neoterm_id)<CR>", { noremap = true })
map("n", "<Space>tS", "<cmd>split +TnewHere<CR>", { noremap = true })
map("n", "<Space>TS", "<cmd>split +TnewHere<CR>", { noremap = true })
map("n", "<Space>ts", "<cmd>split +Tnew<CR>", { noremap = true })
map("n", "<Space>tT", "<cmd>tabe +TnewHere<CR>", { noremap = true })
map("n", "<Space>TT", "<cmd>tabe +TnewHere<CR>", { noremap = true })
map("n", "<Space>tt", "<cmd>tabe +Tnew<CR>", { noremap = true })
map("n", "<Space>TV", "<cmd>vsplit +TnewHere<CR>", { noremap = true })
map("n", "<Space>tV", "<cmd>vsplit +TnewHere<CR>", { noremap = true })
map("n", "<Space>tv", "<cmd>vsplit +Tnew<CR>", { noremap = true })
-- nnoremap <Space>u <cmd>GundoToggle<CR>
map("n", "<Space>v", "<cmd>Vista<CR>", { noremap = true })
map("n", "<Space>V", "<cmd>SymbolsOutline<CR>", { noremap = true })
map("n", "<Space>w", "<C-w>", { noremap = true })
-- t:is_maximized=v:false is a workaround to avoid confusing vim-maximizer
map("n", "<Space>w=", "<cmd>let t:is_maximized=v:false<cr><C-w>=", { noremap = true })
map("n", "<Space>wd", "<C-w>c", { noremap = true })
map("n", "<Space>we", "<cmd>vnew<CR>", { noremap = true })
map("n", "<Space>ws", "<C-w>s", { noremap = true })
map("n", "<Space>wS", "<cmd>new<CR>", { noremap = true })
map("n", "<Space>wt", "<cmd>tabe %<CR>", { noremap = true })
map("n", "<Space>wv", "<C-w>v", { noremap = true })
map("n", "<Space>wV", "<cmd>vnew<CR>", { noremap = true })
map("n", "<Space>x", "<cmd>x<CR>", { noremap = true })
-- nnoremap <silent> <Space>z <cmd>exec ":Goyo ".(exists('#goyo')?"":v:count==""?&tw==0?"":&tw+10:v:count)<CR>
-- map("n", "<Space>z", "<cmd>MaximizerToggle<CR>", { noremap = true })
map("n", "<Space>z", "<cmd>lua require('maximizer').toggle()<CR>", { noremap = true, silent = true })
map("n", "<Space>Z", "<cmd>ZenMode<CR>", { silent = true, noremap = true })
map("n", "<Space>[[", "<cmd>qa<CR>", { noremap = true })
map("n", "<Space>]]", "<cmd>qa!<CR>", { noremap = true })

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

-- disable search when redrawing the screen
map(
    "n",
    "<C-l>",
    ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><Bar>redraw!<Bar>syntax sync fromstart<CR>",
    { silent = true, noremap = true }
)

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

-- change configuration settings quickly
vim.cmd([[
function! Toggle_op2(op, op2, value)
    return a:value == eval('&'.a:op2) && eval('&'.a:op) ? 'no'.a:op : a:op
endfunction

function! Toggle_sequence(op, value)
    return strridx(eval('&'.a:op), a:value) == -1 ? a:op.'+='.a:value : a:op.'-='.a:value
endfunction

function! Toggle_value(op, value, default)
    return eval('&'.a:op) == a:default ? a:value : a:default
endfunction

" taken from unimpaired plugin
function! Statusbump() abort
    let &l:readonly = &l:readonly
    return ''
endfunction

function! Toggle(op) abort
    call Statusbump()
    return eval('&'.a:op) ? 'no'.a:op : a:op
endfunction

function! Option_map(letter, option) abort
    exe 'nnoremap [o'.a:letter ':set '.a:option.'<C-R>=Statusbump()<CR><CR>'
    exe 'nnoremap ]o'.a:letter ':set no'.a:option.'<C-R>=Statusbump()<CR><CR>'
    exe 'nnoremap co'.a:letter ':set <C-R>=Toggle("'.a:option.'")<CR><CR>'
    exe 'nnoremap yo'.a:letter ':set <C-R>=Toggle("'.a:option.'")<CR><CR>'
endfunction

call Option_map('t', 'expandtab')
]])

map("n", "yo#", ":setlocal <C-R>=Toggle_sequence('fo', 'n')<CR><CR>", { noremap = true })
map("n", "yoq", ":setlocal <C-R>=Toggle_sequence('fo', 'tc')<CR><CR>", { noremap = true })
map("n", "yoD", ":setlocal <C-R>=&scrollbind ? 'noscrollbind' : 'scrollbind'<CR><CR>", { noremap = true })
map(
    "n",
    "yog",
    ":setlocal complete-=kspell spelllang=de_de <C-R>=Toggle_op2('spell', 'spelllang', 'de_de')<CR><CR>",
    { noremap = true }
)
map(
    "n",
    "yoe",
    ":setlocal complete+=kspell spelllang=en_us <C-R>=Toggle_op2('spell', 'spelllang', 'en_us')<CR><CR>",
    { noremap = true }
)
map("n", "yok", ":setlocal <C-R>=Toggle_sequence('complete',  'kspell')<CR><CR>", { noremap = true })
map("n", "yoW", ":vertical resize 50<Bar>setlocal winfixwidth<CR>", { noremap = true })
map("n", "yoH", ":resize 20<Bar>setlocal winfixheight<CR>", { noremap = true })
map("n", "yofh", ":setlocal <C-R>=&winfixheight ? 'nowinfixheight' : 'winfixheight'<CR><CR>", { noremap = true })
map("n", "yofw", ":setlocal <C-R>=&winfixwidth ? 'nowinfixwidth' : 'winfixwidth'<CR><CR>", { noremap = true })
map(
    "n",
    "yofx",
    ":setlocal <C-R>=&winfixheight ? 'nowinfixheight nowinfixwidth' : 'winfixheight winfixwidth'<CR><CR>",
    { noremap = true }
)
vim.cmd([[
exec ":nnoremap yoI :set inccommand=<C-R>=Toggle_value('inccommand', '', '".&inccommand."')<CR><CR>"
exec ":nnoremap yoz :set scrolloff=<C-R>=Toggle_value('scrolloff', 999, ".&scrolloff.")<CR><CR>"
exec ":nnoremap yoZ :set sidescrolloff=<C-R>=Toggle_value('sidescrolloff', 999, ".&sidescrolloff.")<CR><CR>"
]])

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
