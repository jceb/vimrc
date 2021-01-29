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
    let @@ = reg_save
endfunction
nnoremap <silent> gy :<C-u>set opfunc=<SID>Yank<CR>g@
nnoremap <silent> gyy "+yy:<C-u>let @*=@+<CR>
nnoremap <silent> gY "+y$:<C-u>let @*=@+<CR>
xnoremap <silent> gy "+y:<C-u>let @*=@+<CR>
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

nnoremap qf <cmd>set modifiable<CR><cmd>.!jq .<CR>
xnoremap qf :!jq .<CR>
nnoremap qsf <cmd>s/^ *"//<cr><cmd>s/"$//<cr><cmd>s/\\//<cr><cmd>normal qf<CR>
xnoremap qsf !jq -c<CR><cmd>s/"/\\"/<cr>I"<Esc>A"<Esc>0

" use space key for something useful
" nnoremap <Space>bb :<C-u>Denite -prompt=b -smartcase -split=floating -floating-preview -vertical-preview -start-filter buffer<CR>
" nnoremap <Space>bl :<C-u>Denite -prompt=l -smartcase -split=floating -floating-preview -vertical-preview -start-filter line<CR>
" nnoremap <Space>bo :<C-u>Denite -prompt=O -smartcase -split=floating -floating-preview -vertical-preview -start-filter outline<CR>
" nnoremap <Space>bt :<C-u>Denite -prompt=O -smartcase -split=floating -floating-preview -vertical-preview -start-filter tag<CR>
" nnoremap <Space>cf :<C-u>Denite -prompt=d -smartcase -split=floating -floating-preview -vertical-preview -start-filter directory_rec/cd<CR>
" nnoremap <Space>FF :<C-u>Denite -prompt=F -smartcase -split=floating -floating-preview -vertical-preview -start-filter -expand file/rec:`fnameescape(expand('%:h'))`<CR>
" nnoremap <Space>ff :<C-u>Denite -prompt=f -smartcase -split=floating -floating-preview -vertical-preview -start-filter file/rec<CR>
" nnoremap <Space>fg :<C-u>Denite -prompt=g -smartcase -split=floating -floating-preview -vertical-preview -start-filter grep:::!<CR>
" nnoremap <Space>FG :<C-u>Denite -prompt=G -smartcase -split=floating -floating-preview -vertical-preview -start-filter grep:`fnameescape(expand('%:h'))`::!<CR>
" nnoremap <Space>fG :<C-u>Denite -prompt=G -smartcase -split=floating -floating-preview -vertical-preview -start-filter grep:`fnameescape(expand('%:h'))`::!<CR>
" nnoremap <Space>fh :<C-u>Denite -prompt=h -smartcase -split=floating -floating-preview -vertical-preview -start-filter help<CR>
" nnoremap <Space>fm :<C-u>Denite -prompt=o -smartcase -split=floating -floating-preview -vertical-preview -start-filter file/old<CR>
" nnoremap <Space>fp :<C-u>Denite -prompt=f -split=floating -start-filter file/rec<CR>
" nnoremap <Space>fv :<C-u>Denite -prompt=c -smartcase -split=floating -floating-preview -vertical-preview -start-filter -expand  menu:vim file/rec:$HOME/.config/nvim/pack/myconfig/<CR>
" nnoremap <Space>pf :<C-u>Denite -prompt=f -smartcase -split=floating -floating-preview -vertical-preview -start-filter file/rec:`GetRootDir()`<CR>
" nnoremap <Space>pg :<C-u>Denite -prompt=g -smartcase -split=floating -floating-preview -vertical-preview -start-filter grep:`GetRootDir()`::!<CR>
" nnoremap <Space>ss :<C-u>new +setlocal\ buftype=nofile\|setf\ markdown<CR>
" nnoremap <Space>sv :<C-u>vnew +setlocal\ buftype=nofile\|setf\ markdown<CR>
" this is in addition to <C-w>n which creates a horizontal split with a new file
nnoremap <Space># :<C-u>silent w#<CR>:echo "Alternate file ".fnameescape(expand('#'))." written"<CR>
nnoremap <Space>1 1<C-w>w
nnoremap <Space>2 2<C-w>w
nnoremap <Space>3 3<C-w>w
nnoremap <Space>4 4<C-w>w
nnoremap <Space>5 5<C-w>w
nnoremap <Space>6 6<C-w>w
nnoremap <Space>7 7<C-w>w
nnoremap <Space>8 8<C-w>w
nnoremap <Space>9 9<C-w>w
nnoremap <Space><Space> :<C-u>update<CR>
nnoremap <Space>a <C-w>p<CR>
nnoremap <Space>bb :<C-u>Buffers<CR>
nnoremap <Space>bd :<C-u>Sayonara!<CR>
nnoremap <Space>be :<C-u>CocList diagnostics<CR>
nnoremap <Space>bF :<C-u>Neoformat<CR>
nnoremap <Space>bf :<C-u>call CocAction('format')<CR>
nnoremap <Space>bh :<C-u>BCommits<CR>
nnoremap <Space>bH :<C-u>exec "FloatermNew tig ".fnameescape(expand('%:p'))<CR>
nnoremap <Space>bl :<C-u>BLines<CR>
nnoremap <Space>bm :<C-u>EasyBufferBotRight<CR>
nnoremap <Space>bo :<C-u>CocList outline<CR>
nnoremap <Space>bq :<C-u>CocDiagnostics<CR>
nnoremap <Space>bs :<C-u>Snippets<CR>
nnoremap <Space>bt :<C-u>BTags<CR>
nnoremap <Space>bW :<C-u>bw #<CR>
nnoremap <Space>bw :<C-u>bw<CR>
nnoremap <Space>cc :<C-u>call CocAction('pickColor')<CR>
nnoremap <Space>cd :<C-u>WindoTcd<CR>
nnoremap <Space>ce :<C-u>call CocAction('diagnosticInfo')<CR>
nnoremap <Space>cf :<C-u>call CocAction('format')<CR>
nnoremap <Space>ch :<C-u>call CocAction('showSignatureHelp')<CR>
nnoremap <Space>cl :<C-u>call CocAction('openLink')<CR>
nnoremap <Space>cp :<C-u>call CocAction('colorPresentation')<CR>
nnoremap <Space>cR :<C-u>call CocAction('rename')<CR>
nnoremap <Space>cr :<C-u>WindoTcdroot<CR>
nnoremap <Space>cw :<C-u>call CocAction('jumpDefinition')<CR>
nnoremap <Space>cx :<C-u>call CocAction('doHover')<CR>
nnoremap <Space>cm "*p
nnoremap <Space>cM "*P
nnoremap <Space>CM "*P
nnoremap <Space>cv "+p
nnoremap <Space>cV "+P
nnoremap <Space>CV "+P
nnoremap <Space>D :<C-u>Sayonara!<CR>
nnoremap <Space>d :<C-u>Sayonara<CR>
nnoremap <Space>e. :<C-u>e %/
nnoremap <Space>eh :<C-u>e ~/
nnoremap <Space>ec :<C-u>e ~/.config/
nnoremap <Space>er :<C-u>e<CR>
nnoremap <Space>ex :<C-u>e!<CR>
nnoremap <Space>FF :<C-u>exec 'Files '.fnameescape(expand('%:h'))<CR>
nnoremap <Space>FG :<C-u>Grepper -dir file<CR>
nnoremap <Space>fG :<C-u>Grepper -dir file<CR>
nnoremap <Space>fc :<C-u>Files ~/.config/<CR>
nnoremap <Space>fd :<C-u>Mkdir %/
nnoremap <Space>fe :<C-u>e %/
nnoremap <Space>ff :<C-u>Files<CR>
nnoremap <Space>fg :<C-u>Grepper -dir cwd<CR>
nnoremap <Space>fh :<C-u>Helptags<CR>
nnoremap <Space>fm :<C-u>Move %
nnoremap <Space>fn :<C-u>FloatermNew nnn -n -Q<CR>
nnoremap <Space>fp :<C-u>Files 
nnoremap <Space>fr :<C-u>History<CR>
nnoremap <Space>fs :<C-u>w<CR>
nnoremap <Space>fv :<C-u>Files ~/.config/nvim/pack/myconfig/<CR>
nnoremap <Space>fw :<C-u>Windows<CR>
nnoremap <Space>gb :<C-u>Git blame<CR>
nnoremap <Space>gC :<C-u>Git commit -s<CR>
nnoremap <Space>gc :<C-u>Git commit<CR>
nnoremap <Space>GD :<C-u>Gdiffsplit! HEAD<CR>
nnoremap <Space>gD :<C-u>Gdiffsplit! HEAD<CR>
nnoremap <Space>gd :<C-u>Gdiffsplit!<CR>
nnoremap <Space>ge :<C-u>Gedit<CR>
nnoremap <Space>gf :<C-u>GFiles<CR>
nnoremap <Space>gg :<C-u>Grepper -tool git<CR>
nnoremap <Space>gh :<C-u>Commits<CR>
nnoremap <Space>gH :<C-u>FloatermNew tig<CR>
nnoremap <Space>gl :<C-u>0Gclog<CR>
nnoremap <Space>gL :<C-u>Gclog<CR>
nnoremap <Space>gm :<C-u>GMove 
nnoremap <Space>gP :<C-u>Git! push 
nnoremap <Space>gp :<C-u>Git! push<CR>
nnoremap <Space>gs :<C-u>Git<CR>
nnoremap <Space>gU :<C-u>Git! pull 
nnoremap <Space>gu :<C-u>Git! pre<CR>
nnoremap <Space>gw :<C-u>Gwrite<CR>
nnoremap <Space>H <C-w>H
nnoremap <Space>h <C-w>h
nnoremap <Space>J <C-w>J
nnoremap <Space>j <C-w>j
nnoremap <Space>K <C-w>K
nnoremap <Space>k <C-w>k
nnoremap <Space>L <C-w>L
nnoremap <Space>l <C-w>l
nnoremap <Space>M :<C-u>Neomake 
nnoremap <Space>m :<C-u>Neomake<CR>
nnoremap <Space>n :<C-u>FloatermNew nnn -Q<CR>
nnoremap <Space>pc :<C-u>Dirvish ~/.config<CR>
nnoremap <Space>pf :<C-u>exec 'Files '.GetRootDir()<CR>
nnoremap <Space>pg :<C-u>Grepper -dir repo,cwd<CR>
nnoremap <Space>pp :<C-u>pwd<CR>
nnoremap <Space>pr :<C-u>Dirvish ~/Documents/Projects<CR>
nnoremap <Space>ps :<C-u>Dirvish ~/Documents/Software<CR>
nnoremap <Space>pv :<C-u>Dirvish ~/.config/nvim<CR>
nnoremap <Space>pw :<C-u>Dirvish ~/Documents/work<CR>
nnoremap <Space>qq :<C-u>qa<CR>
nnoremap <Space>ql :<C-u>call LocationToggle()<CR>
nnoremap <Space>qf :<C-u>call QFixToggle()<CR>
nmap <Space>r <Plug>(neoterm-repl-send-line)
xmap <Space>r <Plug>(neoterm-repl-send)
" nmap <Space>s <Plug>(neoterm-repl-send)
nnoremap <Space>se :<C-u>SudoEdit
nnoremap <Space>so :<C-u>if &filetype == "vim"<Bar>call Unload()<Bar>so %<Bar>echom "Reloaded."<Bar>else<Bar>echom "Reloading only works for ft=vim."<Bar>endif<CR>
nnoremap <Space>SS :<C-u>Obsession ~/.sessions/
nnoremap <Space>ss :<C-u>so ~/.sessions/
nnoremap <Space>sw :<C-u>SudoWrite<CR>
nnoremap <Space>te :<C-u>tabe<CR>
nnoremap <Space>tn :<C-u>tabnew<CR>
nnoremap <Space>tr :<C-u>call neoterm#repl#term(b:neoterm_id)<CR>
nnoremap <Space>TS :<C-u>split +call\ TnewHere()<CR>
nnoremap <Space>tS :<C-u>split +call\ TnewHere()<CR>
nnoremap <Space>ts :<C-u>split +Tnew<CR>
nnoremap <Space>TT :<C-u>tabe +call\ TnewHere()<CR>
nnoremap <Space>tT :<C-u>tabe +call\ TnewHere()<CR>
nnoremap <Space>tt :<C-u>tabe +Tnew<CR>
nnoremap <Space>TV :<C-u>vsplit +call\ TnewHere()<CR>
nnoremap <Space>tV :<C-u>vsplit +call\ TnewHere()<CR>
nnoremap <Space>tv :<C-u>vsplit +Tnew<CR>
nnoremap <Space>u :<C-u>GundoToggle<CR>
nnoremap <Space>w <C-w>
nnoremap <Space>wd <C-w>c
nnoremap <Space>we :<C-u>vnew<CR>
nnoremap <Space>wt :<C-u>tabe %<CR>
nnoremap <Space>wz :<C-u>MaximizerToggle<CR>
nnoremap <silent> <Space>wZ :<C-u>exec ":Goyo ".(exists('#goyo')?"":v:count==""?&tw==0?"":&tw+10:v:count)<CR>
nnoremap <Space>x :<C-u>x<CR>
nnoremap <Space>z :<C-u>MaximizerToggle<CR>
nnoremap <silent> <Space>Z :<C-u>exec ":Goyo ".(exists('#goyo')?"":v:count==""?&tw==0?"":&tw+10:v:count)<CR>
nnoremap <Space>; :
nnoremap <Space>< :<C-u>Grepper -dir file<CR>
nnoremap <Space>, :<C-u>exec 'Files '.fnameescape(expand('%:h'))<CR>
nnoremap <Space>> :<C-u>Grepper -dir cwd<CR>
nnoremap <Space>. :<C-u>Files<CR>
nnoremap <Space>? :<C-u>Grepper -dir repo,cwd<CR>
nnoremap <Space>/ :<C-u>exec 'Files '.GetRootDir()<CR>

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
