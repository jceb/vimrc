" Keymappings:
" ------------

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
nnoremap cy :let @+=@"<CR>:let @*=@+<CR>:echo 'Copied default register to clipboard'<CR>

" copy file name of current buffer to clipboard
nnoremap ycF :let @"=expand('%:p')<CR>:echo 'Copied filname to default register: '.expand('%:p')<CR>
nnoremap ycf :let @"=expand('%:t')<CR>:echo 'Copied filname to default register: '.expand('%:t')<CR>

" insert absolute path of current filename, behavior is similar to normal mode mapping of <C-g>
cnoremap <C-5> <C-r>=expand('%:p')<CR>
cnoremap <C-%> <C-r>=expand('%:p')<CR>

" insert trailing part of the path (the current filename without any leading directories)
cnoremap <C-t> <C-r>=expand('%:t')<CR>

" in addition to the gf and gF commands:
" edit file and create it in case it doesn't exist
nnoremap gcf :e <cfile><CR>

" edit files in PATH environment variable
nnoremap gxf :exec ':e '.system('which '.expand('<cfile>'))<CR>

" swap current word next with word
nnoremap <silent> gxp :let pat_tmp=@/<Bar>s/\v(<\k*%#\k*>)(\_.{-})(<\k+>)/\3\2\1/<Bar>let @/=pat_tmp<Bar>unlet pat_tmp<Bar>echo<Bar>normal ``w<CR>

" select last paste visually
nnoremap gV `]v`[

nnoremap <leader>w :Gwrite<CR>
nnoremap <leader>W :w<CR>
nnoremap <leader>c :Gcommit<CR>
nnoremap <leader>s :Gstatus<CR>

" Make a simple "search" text object.
" http://vim.wikia.com/wiki/Copy_or_change_search_hit
xnoremap <silent> a/ //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap <silent> a/ :normal va/<CR>

" Changes To The Default Behavior:
" --------------------------------

" make S behave like C
nnoremap S s$

" replace within the visual selection
xnoremap s :<C-u>%s/\%V

" local map leader
let maplocalleader = ','

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
nnoremap <silent> *  :let @/='\<'.expand('<cword>').'\>'<CR>:call histadd('search', @/)<CR>
nnoremap <silent> g* :let @/=expand('<cword>')<CR>:call histadd('search', @/)<CR>
nnoremap <silent> #  :let stay_star_view = winsaveview()<cr>#:call winrestview(stay_star_view)<CR>
nnoremap <silent> g# :let stay_star_view = winsaveview()<cr>g#:call winrestview(stay_star_view)<CR>

" change configuration settings quickly
function! s:toggle_op2(op, op2, value)
  return a:value == eval('&'.a:op2) && eval('&'.a:op) ? 'no'.a:op : a:op
endfunction

function! s:toggle_sequence(op, value)
  return strridx(eval('&'.a:op), a:value) == -1 ? a:op.'+='.a:value : a:op.'-='.a:value
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
nnoremap cog :setlocal spelllang=de <C-R>=<SID>toggle_op2('spell', 'spelllang', 'de')<CR><CR>
nnoremap coe :setlocal spelllang=en <C-R>=<SID>toggle_op2('spell', 'spelllang', 'en')<CR><CR>

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
if !has('gui_running')
	cmap <C-H> <C-w>
	imap <C-H> <C-w>
endif

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
if !has('gui_running')
	" for i in range(65,90) + range(97,122)
	" map 0-9, H, L, h and l
	for i in range(48,57) + [72, 76, 104, 108]
		let c = nr2char(i)
		exec "set <M-".c.">=".c
		" exec 'map \e'.c.' <M-'.c.'>'
		"exec 'map! \e'.c.' <M-'.c.'>'
	endfor
endif
