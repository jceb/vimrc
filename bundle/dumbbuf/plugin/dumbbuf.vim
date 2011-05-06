" vim:foldmethod=marker:fen:
scriptencoding utf-8

" For plugin manager {{{
" GetLatestVimScripts: 2783 1 :AutoInstall: dumbbuf.vim
"
" TODO Vimana
" }}}

" Load Once {{{
if exists('g:loaded_dumbbuf') && g:loaded_dumbbuf
    finish
endif
let g:loaded_dumbbuf = 1

" do not load anymore if g:dumbbuf_hotkey is not defined.
if ! exists('g:dumbbuf_hotkey')
    " g:dumbbuf_hotkey is not defined!
    echomsg "g:dumbbuf_hotkey is not defined!"
    finish
elseif maparg(g:dumbbuf_hotkey, 'n') != ''
    echomsg printf("'%s' is already defined!", g:dumbbuf_hotkey)
    finish
endif
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}
" Global Variables {{{
if ! exists('g:dumbbuf_verbose')
    let g:dumbbuf_verbose = 0
endif

"--- if g:dumbbuf_hotkey is not defined,
" do not load this script.
" see 'Load Once'. ---

if ! exists('g:dumbbuf_buffer_height')
    let g:dumbbuf_buffer_height = 10
endif
if ! exists('g:dumbbuf_vertical')
    let g:dumbbuf_vertical = 0
endif
if ! exists('g:dumbbuf_open_with')
    let g:dumbbuf_open_with = 'botright'
endif
if ! exists('g:dumbbuf_buffer_width')
    let g:dumbbuf_buffer_width = 25
endif
if ! exists('g:dumbbuf_listed_buffer_name')
    let g:dumbbuf_listed_buffer_name = '__buffers__'
endif
if ! exists('g:dumbbuf_unlisted_buffer_name')
    let g:dumbbuf_unlisted_buffer_name = '__unlisted_buffers__'
endif
if ! exists('g:dumbbuf_project_buffer_name')
    let g:dumbbuf_project_buffer_name = '__project_buffers__'
endif
if ! exists('g:dumbbuf_cursor_pos')
    let g:dumbbuf_cursor_pos = 'current'
endif
if ! exists('g:dumbbuf_shown_type')
    let g:dumbbuf_shown_type = ''
endif
if ! exists('g:dumbbuf_close_when_exec')
    let g:dumbbuf_close_when_exec = 0
endif
if ! exists('g:dumbbuf_downward')
    let g:dumbbuf_downward = 1
endif
if ! exists('g:dumbbuf_wrap_cursor')
    let g:dumbbuf_wrap_cursor = 1
endif
if ! exists('g:dumbbuf_hl_cursorline')
    let g:dumbbuf_hl_cursorline = 'guibg=Red  guifg=White'
endif
if ! exists('g:dumbbuf_remove_marked_when_close')
    let g:dumbbuf_remove_marked_when_close = 0
endif
if ! exists('g:dumbbuf_all_shown_types')
    let g:dumbbuf_all_shown_types = ['listed', 'unlisted', 'project']
endif
if ! exists('g:dumbbuf_timeoutlen')
    let g:dumbbuf_timeoutlen = 0
endif


let s:listed = 'printf("%s%s%s <%d> [%s]%s", (v:val.is_current ? "%" : " "), (v:val.is_marked ? "x" : " "), (v:val.is_modified ? "+" : " "), v:val.nr, bufname(v:val.nr), (v:val.project_name == "" ? "" : "@".v:val.project_name))'
let s:project = 'printf("%s%s%s <%d> [%s]", (v:val.is_current ? "%" : " "), (v:val.is_marked ? "x" : " "), (v:val.is_modified ? "+" : " "), v:val.nr, bufname(v:val.nr))'
let s:disp_expr = {'listed': s:listed, 'unlisted': s:listed, 'project': s:project}
unlet s:listed
unlet s:project

if ! exists('g:dumbbuf_disp_expr')
    let g:dumbbuf_disp_expr = s:disp_expr
else
    if type(g:dumbbuf_disp_expr) == type("")
        " for backward compatibility.
        let s:tmp = copy(g:dumbbuf_disp_expr)
        unlet g:dumbbuf_disp_expr
        let g:dumbbuf_disp_expr = {'listed': s:tmp, 'unlisted': s:tmp}
        call extend(g:dumbbuf_disp_expr, s:disp_expr, 'keep')
        unlet s:tmp
    else
        " add missing shown types.
        call extend(g:dumbbuf_disp_expr, s:disp_expr, 'keep')
    endif
endif
unlet s:disp_expr


if ! exists('g:dumbbuf_options')
    let g:dumbbuf_options = [
    \   {'name': 'cursorline', 'value': 1},
    \   {'name': 'lazyredraw', 'value': 1},
    \   {'name': 'wrap', 'value': 0},
    \   {'name': 'timeout', 'value': 1, 'restore': 1},
    \   {'name': 'timeoutlen', 'value': g:dumbbuf_timeoutlen, 'restore': 1},
    \]
endif

if ! exists('g:dumbbuf_mappings')
    let g:dumbbuf_mappings = {}
endif
" }}}

" Mappings {{{
nnoremap <silent> <Plug>(dumbbuf-open) :call dumbbuf#open()<CR>

if g:dumbbuf_hotkey != ''
    silent execute 'nmap <unique>' g:dumbbuf_hotkey '<Plug>(dumbbuf-open)'
endif
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
