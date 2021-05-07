" Keymappings:
" ------------

" quick navigation between windows
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" yank to clipboard
function! <SID>Yank(type, ...)
    let sel_save = &selection
    let &selection = 'inclusive'
    let reg_save = @@

    if a:0  " Invoked from Visual mode, use '< and '> marks.
        silent exe 'normal! `<'.a:type."`>\"+y"
    elseif a:type == 'line'
        silent exe "normal! '[V']\"+y"
    elseif a:type == 'block'
        silent exe "normal! `[\<C-V>`]\"+y"
    else
        silent exe "normal! `[v`]\"+y"
    endif
    let @* = @+

    let &selection = sel_save
    " enable this to restore the contents of register " otherwise keep them in
    " sync with the clipboard
    " let @@ = reg_save
endfunction
nnoremap <silent> gy :<C-u>set opfunc=<SID>Yank<CR>g@
nnoremap <silent> gyy "+yy:<C-u>let @*=@+<CR>:let @"=@+<CR>
nnoremap <silent> gY "+y$:<C-u>let @*=@+<CR>:let @"=@+<CR>
xnoremap <silent> gy "+y:<C-u>let @*=@+<CR>:let @"=@+<CR>
nnoremap yC :<C-u>let @+=@"<CR>:let @*=@+<CR>:echo 'Copied default register to clipboard'<CR>
nnoremap ycc :<C-u>let @+=@"<CR>:let @*=@+<CR>:echo 'Copied default register to clipboard'<CR>

" copy file name of current buffer to clipboard
nnoremap ycL :<C-u>let @"=expand('%:p').':'.line('.')<CR>:echo 'Copied filname to default register: '.expand('%:p').':'.line('.')<CR>
nnoremap ycF :<C-u>let @"=expand('%:p')<CR>:echo 'Copied filname to default register: '.expand('%:p')<CR>
nnoremap ycl :<C-u>let @"=expand('%:t').':'.line('.')<CR>:echo 'Copied filname to default register: '.expand('%:t').':'.line('.')<CR>
nnoremap ycf :<C-u>let @"=expand('%:t')<CR>:echo 'Copied filname to default register: '.expand('%:t')<CR>
nnoremap <Space>y :<C-u>let @"=expand('%:p')<CR>:echo 'Copied filname to default register: '.expand('%:p')<CR>

" fix Y
nnoremap Y y$

" in addition to the gf and gF commands:
" edit file and create it in case it doesn't exist
" WARNING: gcf binding is in conflict with vim commentary!
nnoremap gcf :<C-u>e <cfile><CR>
" xnoremap gcf "zy:e <C-r>z<CR>

" swap current word with next word
nnoremap <silent> <Plug>SwapWords :<C-u>keeppatterns s/\v(<\k*%#\k*>)(\_.{-})(<\k+>)/\3\2\1/<Bar>:echo<Bar>:silent! call repeat#set("\<Plug>SwapWords")<Bar>:normal ``<CR>
nmap cx <Plug>SwapWordsw
nmap cX <Plug>SwapWords

" select last paste visually
nnoremap gV `]v`[

" format paragraphs quickly
nnoremap Q gwip
xnoremap Q gw

function! TnewHere()
    call neoterm#new({ 'cwd': expand('%:h:p') })
endfunction

function! Unload()
    let l:loaded = 'g:loaded_'.expand('%:t:r')
    if exists(l:loaded)
        echom "Unloaded."
        exec 'unlet '.l:loaded
    endif
endfunction

" nnoremap qf <cmd>set modifiable<CR><cmd>.!jq .<CR>
" xnoremap qf :!jq .<CR>
" nnoremap qsf <cmd>s/^ *"//<cr><cmd>s/"$//<cr><cmd>s/\\//<cr><cmd>normal qf<CR>
" xnoremap qsf !jq -c<CR><cmd>s/"/\\"/<cr>I"<Esc>A"<Esc>0

" use space key for something useful
nnoremap <Space># <cmd>silent w#<CR>:echo "Alternate file ".fnameescape(expand('#'))." written"<CR>
nnoremap <Space>1 1<C-w>w
nnoremap <Space>2 2<C-w>w
nnoremap <Space>3 3<C-w>w
nnoremap <Space>4 4<C-w>w
nnoremap <Space>5 5<C-w>w
nnoremap <Space>6 6<C-w>w
nnoremap <Space>7 7<C-w>w
nnoremap <Space>8 8<C-w>w
nnoremap <Space>9 9<C-w>w
nnoremap <Space><Space> <cmd>update<CR>
nnoremap <Space>a <cmd>NvimTreeToggle<CR>
nnoremap <Space>bb <cmd>Telescope buffers<CR>
nnoremap <Space>bc <cmd>exec 'Telescope git_bcommits cwd='.fnameescape(expand('%:h'))<CR>
nnoremap <Space>bd <cmd>Sayonara!<CR>
nnoremap <Space>be <cmd>CocList diagnostics<CR>
nnoremap <Space>bf <cmd>Telescope treesitter<CR>
nnoremap <Space>bH <cmd>exec "FloatermNew tig ".fnameescape(expand('%:p'))<CR>
nnoremap <Space>bh <cmd>Telescope git_bcommits<CR>
nnoremap <Space>bi <cmd>call CocAction('format')<CR>
nnoremap <Space>bI <cmd>Neoformat<CR>
nnoremap <Space>bl <cmd>Telescope current_buffer_fuzzy_find<CR>
nnoremap <Space>bm <cmd>EasyBufferBotRight<CR>
nnoremap <Space>bo <cmd>CocList outline<CR>
nnoremap <Space>bq <cmd>CocDiagnostics<CR>
nnoremap <Space>bt <cmd>Telescope current_buffer_tags<CR>
nnoremap <Space>bv <cmd>Vista!!<CR>
nnoremap <Space>bW <cmd>bw #<CR>
nnoremap <Space>bw <cmd>bw<CR>
nnoremap <Space>cc <cmd>call CocAction('pickColor')<CR>
nnoremap <Space>cd <cmd>WindoTcd<CR>
nnoremap <Space>ce <cmd>call CocAction('diagnosticInfo')<CR>
nnoremap <Space>ch <cmd>call CocAction('showSignatureHelp')<CR>
nnoremap <Space>cl <cmd>call CocAction('openLink')<CR>
nnoremap <Space>CM "*P
nnoremap <Space>cM "*P
nnoremap <Space>cm "*p
nnoremap <Space>cp <cmd>call CocAction('colorPresentation')<CR>
nnoremap <Space>cR <cmd>call CocAction('rename')<CR>
nnoremap <Space>cr <cmd>WindoTcdroot<CR>
nnoremap <Space>CV "+P
nnoremap <Space>cV "+P
nnoremap <Space>cv "+p
nnoremap <Space>cw <cmd>call CocAction('jumpDefinition')<CR>
nnoremap <Space>cx <cmd>call CocAction('doHover')<CR>
nnoremap <Space>D <cmd>Sayonara!<CR>
nnoremap <Space>d <cmd>Sayonara<CR>
nnoremap <Space>e :<C-u>e %/
nnoremap <Space>E <cmd>e<CR>
nnoremap <Space>fc :<C-u>e ~/.config/
nnoremap <Space>fd <cmd>Mkdir %/
nnoremap <Space>fe :<C-u>e %/
nnoremap <Space>FF <cmd>exec 'Telescope find_files cwd='.fnameescape(expand('%:h'))<CR>
nnoremap <Space>ff <cmd>Telescope find_files<CR>
nnoremap <Space>FG <cmd>Telescope live_grep cwd='.fnameescape(expand('%:h'))<CR>
nnoremap <Space>fg <cmd>Telescope live_grep<CR>
nnoremap <Space>fh <cmd>Telescope help_tags<CR>
nnoremap <Space>fk <cmd>Telescope keymaps<CR>
nnoremap <Space>fl <cmd>Telescope loclist<CR>
nnoremap <Space>fm :<C-u>Move %
nnoremap <Space>fM <cmd>Telescope man_pages<CR>
nnoremap <Space>fn <cmd>FloatermNew nnn -n -Q<CR>
nnoremap <Space>fp :<C-u>Telescope find_files cwd=
nnoremap <Space>fq <cmd>Telescope quickfix<CR>
nnoremap <Space>fr <cmd>Telescope oldfiles<CR>
nnoremap <Space>fs <cmd>w<CR>
nnoremap <Space>fu :<C-u>e ~/
nnoremap <Space>fv <cmd>Telescope find_files cwd=~/.config/nvim/pack/myconfig/<CR>
nnoremap <Space>FV <cmd>Telescope find_files cwd=~/.config/nvim/<CR>
nnoremap <Space>fw <cmd>Windows<CR>
nnoremap <Space>gb <cmd>exec 'Telescope git_branches cwd='.fnameescape(expand('%:h'))<CR>
nnoremap <Space>gB <cmd>Git blame<CR>
nnoremap <Space>gC <cmd>Git commit -s<CR>
nnoremap <Space>gc <cmd>Git commit<CR>
nnoremap <Space>GD <cmd>Gdiffsplit! HEAD<CR>
nnoremap <Space>gD <cmd>Gdiffsplit! HEAD<CR>
nnoremap <Space>gd <cmd>Gdiffsplit!<CR>
nnoremap <Space>ge <cmd>Gedit<CR>
nnoremap <Space>gf <cmd>Telescope git_files<CR>
nnoremap <Space>gG <cmd>Grepper -tool git<CR>
nnoremap <Space>gg <cmd>Telescope live_grep cwd='.fnameescape(GetRootDir(getcwd()))<CR>
nnoremap <Space>gH <cmd>FloatermNew tig<CR>
nnoremap <Space>gh <cmd>Telescope git_commits<CR>
nnoremap <Space>gl <cmd>0Gclog<CR>
nnoremap <Space>gL <cmd>Gclog<CR>
nnoremap <Space>gm :<C-u>GMove 
nnoremap <Space>gP :<C-u>Dispatch! git push 
nnoremap <Space>gp <cmd>Dispatch! git push<CR>
nnoremap <Space>gs <cmd>Git<CR>
nnoremap <Space>gS <cmd>Telescope git_status<CR>
nnoremap <Space>gU :<C-u>Dispatch! git pull 
nnoremap <Space>gu <cmd>Dispatch! git pre<CR>
nnoremap <Space>gw <cmd>Gwrite<CR>
nnoremap <Space>H <C-w>H
nnoremap <Space>h <C-w>h
nnoremap <Space>J <C-w>J
nnoremap <Space>j <C-w>j
nnoremap <Space>K <C-w>K
nnoremap <Space>k <C-w>k
nnoremap <Space>L <C-w>L
nnoremap <Space>l <C-w>l
nnoremap <Space>M :<C-u>Neomake 
nnoremap <Space>m <cmd>Neomake<CR>
nnoremap <Space>n <cmd>FloatermNew nnn -Q<CR>
nnoremap <Space>o <C-w>p<CR>
nnoremap <Space>pc <cmd>Dirvish ~/.config<CR>
nnoremap <Space>PF <cmd>exec 'Telescope find_files cwd='.fnameescape(GetRootDir())<CR>
nnoremap <Space>pf <cmd>exec 'Telescope find_files cwd='.fnameescape(GetRootDir(getcwd()))<CR>
nnoremap <Space>pG <cmd>Grepper -dir repo,cwd<CR>
nnoremap <Space>pg <cmd>Telescope live_grep cwd='.fnameescape(GetRootDir(getcwd()))<CR>
nnoremap <Space>PG <cmd>Telescope live_grep cwd='.fnameescape(GetRootDir())<CR>
nnoremap <Space>pp <cmd>pwd<CR>
nnoremap <Space>pr <cmd>Dirvish ~/Documents/Projects<CR>
nnoremap <Space>ps <cmd>Dirvish ~/Documents/Software<CR>
nnoremap <Space>pv <cmd>Dirvish ~/.config/nvim<CR>
nnoremap <Space>pV <cmd>exec 'Telescope find_files cwd=~/.config/nvim'<CR>
nnoremap <Space>pw <cmd>Dirvish ~/Documents/work<CR>
nnoremap <Space>ql <cmd>call LocationToggle()<CR>
nnoremap <Space>qo <cmd>call QFixToggle()<CR>
nnoremap <Space>qq <cmd>qa<CR>
nnoremap <Space>R <cmd>e!<CR>
xmap <Space>r <Plug>(neoterm-repl-send)
nmap <Space>r <Plug>(neoterm-repl-send-line)
" nmap <Space>s <Plug>(neoterm-repl-send)
nnoremap <Space>se :<C-u>SudoEdit
nnoremap <Space>so <cmd>if &filetype == "vim"<Bar>call Unload()<Bar>so %<Bar>echom "Reloaded."<Bar>else<Bar>echom "Reloading only works for ft=vim."<Bar>endif<CR>
nnoremap <Space>SS :<C-u>Obsession ~/.sessions/
nnoremap <Space>ss :<C-u>so ~/.sessions/
nnoremap <Space>sw <cmd>SudoWrite<CR>
nnoremap <Space>tb <cmd>Telescope builtin<CR>
nnoremap <Space>tl <cmd>Telescope loclist<CR>
nnoremap <Space>tq <cmd>Telescope quickfix<CR>
nnoremap <Space>te <cmd>tabe<CR>
nnoremap <Space>tn <cmd>tabnew<CR>
nnoremap <Space>tr <cmd>call neoterm#repl#term(b:neoterm_id)<CR>
nnoremap <Space>TS <cmd>split +call\ TnewHere()<CR>
nnoremap <Space>tS <cmd>split +call\ TnewHere()<CR>
nnoremap <Space>ts <cmd>split +Tnew<CR>
nnoremap <Space>TT <cmd>tabe +call\ TnewHere()<CR>
nnoremap <Space>tT <cmd>tabe +call\ TnewHere()<CR>
nnoremap <Space>tt <cmd>tabe +Tnew<CR>
nnoremap <Space>TV <cmd>vsplit +call\ TnewHere()<CR>
nnoremap <Space>tV <cmd>vsplit +call\ TnewHere()<CR>
nnoremap <Space>tv <cmd>vsplit +Tnew<CR>
nnoremap <Space>u <cmd>GundoToggle<CR>
nnoremap <Space>w <C-w>
nnoremap <Space>wd <C-w>c
nnoremap <Space>we <cmd>vnew<CR>
nnoremap <Space>wS <cmd>new<CR>
nnoremap <Space>wt <cmd>tabe %<CR>
nnoremap <Space>wV <cmd>vnew<CR>
nnoremap <Space>wz <cmd>MaximizerToggle<CR>
nnoremap <Space>x <cmd>x<CR>
nnoremap <Space>z <cmd>MaximizerToggle<CR>
nnoremap <silent> <Space>wZ <cmd>exec ":Goyo ".(exists('#goyo')?"":v:count==""?&tw==0?"":&tw+10:v:count)<CR>
nnoremap <silent> <Space>Z <cmd>exec ":Goyo ".(exists('#goyo')?"":v:count==""?&tw==0?"":&tw+10:v:count)<CR>

" readline input bindings
inoremap <M-f> <C-o>w
inoremap <M-b> <C-o>b

" Store relative line number jumps in the jumplist if they exceed a threshold.
" thanks to https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.vim/plugin/mappings/normal.vim
nnoremap <expr> k (v:count > 2 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 2 ? "m'" . v:count : '') . 'j'

" Use C-g in command and insert mode as well
cnoremap <C-g> <C-R>=expand('%:h').'/'<CR>
" inoremap <C-g> <C-R>=expand('%:h').'/'<CR>

" Toggle paste
noremap <silent> <F11> :<C-u>set invpaste<CR>
inoremap <silent> <F11> <C-o>:<C-u>set invpaste<CR>

" Changes To The Default Behavior:
" --------------------------------

" use the same exit key for vim that's also configured in the terminal
inoremap <C-\><C-\> <Esc>
inoremap  <Esc>
inoremap <C-/><C-/> <Esc>
noremap <C-\><C-\> <Esc>
noremap  <Esc>
noremap <C-/><C-/> <Esc>
cnoremap <C-\><C-\> <Esc>
cnoremap  <Esc>
cnoremap <C-/><C-/> <Esc>

" shortcut for exiting terminal input mode
tnoremap <C-\><C-\> <C-\><C-n>
tnoremap  <C-\><C-n>
tnoremap <C-/><C-/> <C-\><C-n>

" make Shift-Insert paste contents of the clipboard into terminal
tnoremap <S-Insert> <C-\><C-N>"*pi

" make n and N always search in the same direction
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" http://vim.wikia.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
inoremap <silent> <Esc> <Esc>`^

" disable search when redrawing the screen
nnoremap <silent> <C-l> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><Bar>redraw!<Bar>syntax sync fromstart<CR>

" Support Shift-Insert in all vim UIs
nnoremap <S-Insert> "*P
inoremap <S-Insert> <C-o>"*P
cnoremap <S-Insert> <C-r>*

" make S behave like C
nnoremap S s$

" replace within the visual selection
xnoremap s :<C-u>%s/\%V

" local map leader
" let maplocalleader = ','

" disable <F1> mapping to open vim help - especially on Lenovo laptops <F1> is
" in the way of <Esc> which is really annoying
imap <F1> <Nop>
map <F1> <Nop>

" fast quit without saving anything
nnoremap <silent> <leader>zq :qa!<CR>

" fast quit with saving everything
nnoremap <silent> <leader>zz :wa<CR>:qa<CR>

" change default behavior of search, don't jump to the next matching word, stay
" on the current one end
" have a look at :h restore-position
" nnoremap <silent> *  :let @/='\<'.expand('<cword>').'\>'<CR>:call histadd('search', @/)<CR>:if &hlsearch<Bar>set hlsearch<Bar>endif<CR>
" nnoremap <silent> g* :let @/=expand('<cword>')<CR>:call histadd('search', @/)<CR>:if &hlsearch<Bar>set hlsearch<Bar>endif<CR>
" nnoremap <silent> #  :let stay_star_view = winsaveview()<cr>#:call winrestview(stay_star_view)<CR>
" nnoremap <silent> g# :let stay_star_view = winsaveview()<cr>g#:call winrestview(stay_star_view)<CR>

" change configuration settings quickly
function! s:toggle_op2(op, op2, value)
    return a:value == eval('&'.a:op2) && eval('&'.a:op) ? 'no'.a:op : a:op
endfunction

function! s:toggle_sequence(op, value)
    return strridx(eval('&'.a:op), a:value) == -1 ? a:op.'+='.a:value : a:op.'-='.a:value
endfunction

function! s:toggle_value(op, value, default)
    return eval('&'.a:op) == a:default ? a:value : a:default
endfunction

" taken from unimpaired plugin
function! s:statusbump() abort
    let &l:readonly = &l:readonly
    return ''
endfunction

function! s:toggle(op) abort
    call s:statusbump()
    return eval('&'.a:op) ? 'no'.a:op : a:op
endfunction

function! s:option_map(letter, option) abort
    exe 'nnoremap [o'.a:letter ':set '.a:option.'<C-R>=<SID>statusbump()<CR><CR>'
    exe 'nnoremap ]o'.a:letter ':set no'.a:option.'<C-R>=<SID>statusbump()<CR><CR>'
    exe 'nnoremap co'.a:letter ':set <C-R>=<SID>toggle("'.a:option.'")<CR><CR>'
    exe 'nnoremap yo'.a:letter ':set <C-R>=<SID>toggle("'.a:option.'")<CR><CR>'
endfunction

call s:option_map('t', 'expandtab')
nnoremap yo# :setlocal <C-R>=<SID>toggle_sequence('fo', 'n')<CR><CR>
nnoremap yoq :setlocal <C-R>=<SID>toggle_sequence('fo', 'tc')<CR><CR>
nnoremap yoD :setlocal <C-R>=&scrollbind ? 'noscrollbind' : 'scrollbind'<CR><CR>
nnoremap yog :setlocal complete-=kspell spelllang=de_de <C-R>=<SID>toggle_op2('spell', 'spelllang', 'de_de')<CR><CR>
nnoremap yoe :setlocal complete+=kspell spelllang=en_us <C-R>=<SID>toggle_op2('spell', 'spelllang', 'en_us')<CR><CR>
nnoremap yok :setlocal <C-R>=<SID>toggle_sequence('complete',  'kspell')<CR><CR>
exec ":nnoremap yoI :set inccommand=<C-R>=<SID>toggle_value('inccommand', '', '".&inccommand."')<CR><CR>"
nnoremap yoW :vertical resize 50<Bar>setlocal winfixwidth<CR>
nnoremap yoH :resize 20<Bar>setlocal winfixheight<CR>
nnoremap yofh :setlocal <C-R>=&winfixheight ? 'nowinfixheight' : 'winfixheight'<CR><CR>
nnoremap yofw :setlocal <C-R>=&winfixwidth ? 'nowinfixwidth' : 'winfixwidth'<CR><CR>
nnoremap yofx :setlocal <C-R>=&winfixheight ? 'nowinfixheight nowinfixwidth' : 'winfixheight winfixwidth'<CR><CR>
exec ":nnoremap yoz :set scrolloff=<C-R>=<SID>toggle_value('scrolloff', 999, ".&scrolloff.")<CR><CR>"
exec ":nnoremap yoZ :set sidescrolloff=<C-R>=<SID>toggle_value('sidescrolloff', 999, ".&sidescrolloff.")<CR><CR>"

" start new undo sequences when using certain commands in insert mode
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
" disable <BS> mapping to improve the autocompletion experience
" inoremap <BS> <C-G>u<BS>
if has('gui_running')
    inoremap <C-H> <C-G>u<C-H>
endif
inoremap <Del> <C-G>u<Del>

" delete words in insert and command mode like expected - doesn't work properly
" at the end of lines
imap <C-BS> <C-G>u<C-w>
cmap <C-BS> <C-w>
imap <C-Del> <C-o>dw
cmap <C-Del> <C-Right><C-w>
" if !has('gui_running')
"     cmap <C-H> <C-w>
"     imap <C-H> <C-w>
" endif

" jump to the end of the previous word by
" nmap <BS> ge

" Search for the occurrence of the word under the cursor
" nnoremap <silent> [I [I:let nr = input('Item: ')<Bar>if nr != ''<Bar>exe 'normal '.nr.'[\t'<Bar>endif<CR>
" nnoremap <silent> ]I ]I:let nr = input('Item: ')<Bar>if nr != ''<Bar>exe 'normal '.nr.']\t'<Bar>endif<CR>

" Enable the same behavior to <C-n> and <Down> / <C-p> and <Up> in command mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" fix meta-keys which generate <Esc>a .. <Esc>z
" http://vim.wikia.com/wiki/VimTip738
if !has('gui_running') && !has('nvim')
    " for i in range(65,90) + range(97,122)
    " map 0-9, H, L, h and l
    for i in range(48,57) + [72, 76, 104, 108]
        let c = nr2char(i)
        exec "set <M-".c.">=".c
        " exec 'map \e'.c.' <M-'.c.'>'
        "exec 'map! \e'.c.' <M-'.c.'>'
    endfor
endif
