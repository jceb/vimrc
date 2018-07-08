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
nnoremap <silent> gy :set opfunc=<SID>Yank<CR>g@
nnoremap <silent> gyy "+yy:let @*=@+<CR>
nnoremap <silent> gY "+y$:let @*=@+<CR>
xnoremap <silent> gy "+y:let @*=@+<CR>
nnoremap yC :let @+=@"<CR>:let @*=@+<CR>:echo 'Copied default register to clipboard'<CR>
nnoremap ycc :let @+=@"<CR>:let @*=@+<CR>:echo 'Copied default register to clipboard'<CR>

" copy file name of current buffer to clipboard
nnoremap ycF :let @"=expand('%:p')<CR>:echo 'Copied filname to default register: '.expand('%:p')<CR>
nnoremap ycf :let @"=expand('%:t')<CR>:echo 'Copied filname to default register: '.expand('%:t')<CR>

" insert absolute path of current filename, behavior is similar to normal mode mapping of <C-g>
cnoremap <C-x>p <C-r>=expand('%:p')<CR>
cnoremap <C-x><C-p> <C-r>=expand('%:p')<CR>
cnoremap <C-x>h <C-r>=expand('%:h')<CR>
cnoremap <C-x><C-h> <C-r>=expand('%:h')<CR>

" insert trailing part of the path (the current filename without any leading directories)
cnoremap <C-x>t <C-r>=expand('%:t')<CR>
cnoremap <C-x><C-t> <C-r>=expand('%:t')<CR>

" in addition to the gf and gF commands:
" edit file and create it in case it doesn't exist
" WARNING: gcf binding is in conflict with vim commentary plugin!
" nnoremap gcf :e <cfile><CR>
" xnoremap gcf "zy:e <C-r>z<CR>

" terminal mappings taken from intermezzo
nnoremap <C-T><C-V> :vsp<cr>:terminal<cr>i
nnoremap <C-T>v :vsp<cr>:terminal<cr>i
nnoremap <C-T><C-S> :sp<cr>:terminal<cr>i
nnoremap <C-T>s :sp<cr>:terminal<cr>i
nnoremap <C-T><C-T> :tabe<cr>:terminal<cr>i
nnoremap <C-T>t :tabe<cr>:terminal<cr>i
nnoremap <C-T><C-E> :terminal<cr>i
nnoremap <C-T>e :terminal<cr>i

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
nnoremap <silent> <Space>z :<C-u>exec ":Goyo ".(exists('#goyo')?"":v:count==""?&tw==0?"":&tw+10:v:count)<CR>
nnoremap <Space><Space> :<C-u>update<CR>
nnoremap <Space>bd :<C-u>Sayonara!<CR>
nnoremap <Space>FD :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufDir <C-r>=Expand_file_directory()<CR><CR>
nnoremap <Space>fD :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufDir <C-r>=Expand_file_directory()<CR><CR>
nnoremap <Space>FF :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufFile <C-r>=Expand_file_directory()<CR><CR>
nnoremap <Space>fF :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufFile <C-r>=Expand_file_directory()<CR><CR>
nnoremap <leader><leader> :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufFile <C-r>=Expand_file_directory()<CR><CR>
nnoremap <Space>fS :<C-u>SudoWrite<CR>
nnoremap <Space>fa :<C-u>silent w#<CR>:echo "Alternate file ".expand('#')." written"<CR>
nnoremap <Space>fb :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufBuffer<CR>
nnoremap <Space>fd :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufDir<CR>
nnoremap <Space>ff :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufFile<CR>
nnoremap <leader><leader> :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufFile<CR>
nnoremap <Space>fh :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufHelp<CR>
nnoremap <Space>fm :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufBookmarkDir<CR>
nnoremap <Space>fr :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufMruFile<CR>
nnoremap <Space>fs :<C-u>update<CR>
nnoremap <Space>fv :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufFile ~/.config/nvim/pack/myconfig/**/<CR>
nnoremap <leader>fR :<C-u>packadd L9<CR>:packadd FuzzyFinder<CR>:FufRenewCache<CR>
nnoremap <Space>gc :<C-u>Gcommit<CR>
nnoremap <Space>gd :<C-u>Gdiff<CR>
nnoremap <Space>ge :<C-u>Gedit<CR>
nnoremap <Space>gl :<C-u>Glog<CR>
nnoremap <Space>gp :<C-u>Git push<CR>
nnoremap <Space>gs :<C-u>Gstatus<CR>
nnoremap <Space>gw :<C-u>Gw<CR>
nnoremap <Space>q :<C-u>qa<CR>
nnoremap <Space>wa :<C-u>wa<CR>
nnoremap <Space>w <C-w>
nnoremap <Space>wd :<C-u>Sayonara<CR>
nnoremap <Space>x :<C-u>x<CR>

" readline input bindings
inoremap <M-f> <C-o>w
inoremap <M-b> <C-o>b

" Store relative line number jumps in the jumplist if they exceed a threshold.
" thanks to https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.vim/plugin/mappings/normal.vim
nnoremap <expr> k (v:count > 2 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 2 ? "m'" . v:count : '') . 'j'

" Changes To The Default Behavior:
" --------------------------------

" make n and N always search in the same direction
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" http://vim.wikia.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
inoremap <silent> <Esc> <Esc>`^

" disable search when redrawing the screen
nnoremap <silent> <C-l> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><Bar>redraw!<CR>

" make S behave like C
" use sneak instead
" nnoremap S s$

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
nnoremap cog :setlocal complete-=kspell spelllang=de <C-R>=<SID>toggle_op2('spell', 'spelllang', 'de')<CR><CR>
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
