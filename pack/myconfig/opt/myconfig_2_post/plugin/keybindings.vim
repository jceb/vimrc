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
nnoremap ycF :<C-u>let @"=expand('%:p')<CR>:echo 'Copied filname to default register: '.expand('%:p')<CR>
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

" use space key for something useful
nnoremap <Space>!m :<C-u>Neomake!<CR>
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
nnoremap <Space>a :<C-u>wa<CR>
nnoremap <Space>bb :<C-u>PickerBuffer<CR>
nnoremap <Space>bd :<C-u>Sayonara!<CR>
nnoremap <Space>bl :<C-u>ls<CR>
nnoremap <Space>fe :<C-u>PickerEdit ~/.config/nvim/pack/myconfig/<CR>
nnoremap <Space>FF :<C-u>exec 'PickerEdit '.fnameescape(expand('%:h'))<CR>
nnoremap <Space>ff :<C-u>PickerEdit<CR>
nnoremap <Space>fg :<C-u>Grepper -dir cwd<CR>
nnoremap <Space>FG :<C-u>Grepper -dir file<CR>
nnoremap <Space>Fg :<C-u>Grepper -dir file<CR>
nnoremap <Space>fh :<C-u>PickerHelp<CR>
nnoremap <Space>fr :<C-u>Move %
nnoremap <Space>fs :<C-u>w<CR>
nnoremap <Space>gc :<C-u>Gcommit<CR>
nnoremap <Space>gd :<C-u>Gdiff<CR>
nnoremap <Space>ge :<C-u>Gedit<CR>
nnoremap <Space>gg :<C-u>Grepper -tool git<CR>
nnoremap <Space>gl :<C-u>Glog<CR>
nnoremap <Space>gP :<C-u>Git push
nnoremap <Space>gp :<C-u>Git push<CR>
nnoremap <Space>gs :<C-u>Gstatus<CR>
nnoremap <Space>gU :<C-u>Git pull
nnoremap <Space>gu :<C-u>Git pull<CR>
nnoremap <Space>gw :<C-u>Gw<CR>
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
nnoremap <Space>o :<C-u>call QFixToggle()<CR>
nnoremap <Space>pf :<C-u>exec 'PickerEdit '.GetRootDir()<CR>
nnoremap <Space>pg :<C-u>Grepper -dir repo,cwd<CR>
nnoremap <Space>q :<C-u>qa<CR>
nmap <Space>r <Plug>(neoterm-repl-send)
xmap <Space>r <Plug>(neoterm-repl-send)
nmap <Space>rr <Plug>(neoterm-repl-send-line)
nnoremap <Space>se :<C-u>SudoEdit
nnoremap <Space>sw :<C-u>SudoWrite<CR>
nnoremap <Space>ts :<C-u>sp<cr>:terminal fish<CR>
nnoremap <Space>tt :<C-u>tabe<cr>:terminal fish<CR>
nnoremap <Space>tv :<C-u>vsp<cr>:terminal fish<CR>
nnoremap <Space>w <C-w>
nnoremap <Space>wd :<C-u>Sayonara<CR>
nnoremap <Space>wt :<C-u>tabe %<CR>
nnoremap <Space>x :<C-u>x<CR>
nnoremap <silent> <Space>z :<C-u>exec ":Goyo ".(exists('#goyo')?"":v:count==""?&tw==0?"":&tw+10:v:count)<CR>

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

" shortcut for exiting terminal input mode
tnoremap <C-\><C-\> <C-\><C-n>

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
nnoremap <silent> ZQ :qa!<CR>

" fast quit with saving everything
nnoremap <silent> ZZ :wa<CR>:qa<CR>

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
endfunction

call s:option_map('t', 'expandtab')
nnoremap co# :setlocal <C-R>=<SID>toggle_sequence('fo', 'n')<CR><CR>
nnoremap cod :<C-R>=&diff ? 'diffoff' : 'diffthis'<CR><CR>
nnoremap coD :setlocal <C-R>=&scrollbind ? 'noscrollbind' : 'scrollbind'<CR><CR>
nnoremap cog :setlocal complete-=kspell spelllang=de <C-R>=<SID>toggle_op2('spell', 'spelllang', 'de_de')<CR><CR>
nnoremap coe :setlocal complete+=kspell spelllang=en_us <C-R>=<SID>toggle_op2('spell', 'spelllang', 'en_us')<CR><CR>
nnoremap cok :setlocal <C-R>=<SID>toggle_sequence('complete',  'kspell')<CR><CR>
exec ":nnoremap coz :set scrolloff=<C-R>=<SID>toggle_value('scrolloff', 999, ".&scrolloff.")<CR><CR>"
exec ":nnoremap coZ :set sidescrolloff=<C-R>=<SID>toggle_value('sidescrolloff', 999, ".&sidescrolloff.")<CR><CR>"

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
