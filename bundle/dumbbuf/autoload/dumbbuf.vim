" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Scope Variables {{{
let s:debug_msg = []

let s:caller_bufnr = -1    " caller buffer's bufnr which calls dumbbuf buffer.
let s:dumbbuf_bufnr = -1    " dumbbuf buffer's bufnr.
let s:bufs_info = {}    " buffers info. (key: bufnr)
let s:misc_info = {'marked_bufs':{}, 'project_name':{}}
let s:previous_lnum = -1    " lnum where a previous mapping executed.

let s:current_shown_type = ''    " this must be one of 'listed', 'unlisted', 'project' while runnning mappings.
let s:shown_type_idx = 0    " index for g:dumbbuf_all_shown_types.

" NOTE: See s:compile_mappings() about mappings and those infos.
let s:mappings = {'compiled':[]}    " buffer local mappings.

let s:options_restored = []

let s:orig_hl_cursorline = 0
let s:now_processing = 0
" }}}

" Functions {{{

" utility functions
" Debug {{{
if g:dumbbuf_verbose
    command -nargs=+ DumbBufDebug call s:debug_command(<f-args>)

    func! s:debug_command(cmd, ...)
        if a:cmd ==# 'list'
            for i in s:debug_msg | call s:warn(i) | endfor
        elseif a:cmd ==# 'eval'
            echo string(eval(join(a:000, ' ')))
        endif
    endfunc
endif
fun! s:debug(msg) "{{{
    if g:dumbbuf_verbose
        call s:warn(a:msg)
        call add(s:debug_msg, a:msg)
        if len(s:debug_msg) > 30
            let s:debug_msg = s:debug_msg[-30:-1]
        endif
    endif
endfunc "}}}
" }}}
func! s:warn(msg) "{{{
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunc "}}}
func! s:warnf(fmt, ...) "{{{
    call s:warn(call('printf', [a:fmt] + a:000))
endfunc "}}}


" sort functions
func! s:sortfunc_numeric(a, b) "{{{
    let [a, b] = [a:a + 0, a:b + 0]
    return a ==# b ? 0 : a > b ? 1 : -1
endfunc "}}}


" misc.
func! s:get_buffer_info(bufnr) "{{{
    return has_key(s:bufs_info, a:bufnr) ? s:bufs_info[a:bufnr] : []
endfunc "}}}
func! s:eval_disp_expr(bufs) "{{{
    if type(a:bufs) == type([])
        return map(a:bufs, g:dumbbuf_disp_expr[s:current_shown_type])
    else
        return get(map([a:bufs], g:dumbbuf_disp_expr[s:current_shown_type]), 0)
    endif
endfunc "}}}
func! s:sort_by_shown_type(bufs) "{{{
    let bufs = a:bufs
    if s:current_shown_type ==# 'listed'
        " sort by bufnr.
        let sorted = map(sort(keys(bufs), 's:sortfunc_numeric'), 'bufs[v:val]')
    elseif s:current_shown_type ==# 'unlisted'
        " sort by bufnr.
        let sorted = map(sort(keys(bufs), 's:sortfunc_numeric'), 'bufs[v:val]')
    elseif s:current_shown_type ==# 'project'
        " nop.
        let sorted = values(bufs)
    endif
    return sorted
endfunc "}}}
func! s:eval_sorted_bufs(sorted_bufs) "{{{
    let lnum = 1
    let disp_line = []

    if s:current_shown_type ==# 'project'
        let proj_vs_bufs = {}
        " Use string which includes control chars
        " as 'no project buffer' dict key.
        " This must be unique Because buf.project_name must be strtrans()ed.
        let no_projects_are_belong_to_us =
                    \ nr2char(255)."\Y\o\u\i\s\b\i\g\f\o\o\l\m\a\n\.\h\a\h\a\h\a"

        for buf in a:sorted_bufs
            if buf.project_name == ''
                let key_val = no_projects_are_belong_to_us
            else
                " buf.project_name must not include control chars.
                let key_val = buf.project_name
            endif
            if has_key(proj_vs_bufs, key_val)
                let proj_vs_bufs[key_val] += [buf]
            else
                let proj_vs_bufs[key_val] = [buf]
            endif
        endfor

        for proj_name in sort(keys(proj_vs_bufs))
            " write project name.
            if proj_name ==# no_projects_are_belong_to_us
                " TODO option
                call add(disp_line, '<Other Buffers>:')
                let lnum += 1
            else
                " TODO option
                call add(disp_line, printf("<%s>:", proj_name))
                let lnum += 1
            endif
            " write buffers who belong to its project.
            for buf in proj_vs_bufs[proj_name]
                let buf.lnum = lnum
                call add(disp_line, s:eval_disp_expr(buf))
                let lnum += 1
            endfor
        endfor
    else
        " a:sorted_bufs are sorted by bufnr.
        for buf in a:sorted_bufs
            let buf.lnum = lnum
            call add(disp_line, s:eval_disp_expr(buf))
            let lnum += 1
        endfor
    endif

    return disp_line
endfunc "}}}
func! s:write_buffers_list(bufs) "{{{
    " NOTE: this function determines s:bufs_info[i].lnum

    call s:jump_to_buffer(s:dumbbuf_bufnr)

    let disp_line = []
    try
        let disp_line = s:eval_sorted_bufs(s:sort_by_shown_type(a:bufs))
    catch
        call s:warn("error occured while evaluating g:dumbbuf_disp_expr.")
        call s:warn(v:exception)
        return
    endtry

    silent put =disp_line
    normal! gg"_dd
endfunc "}}}
func! s:parse_buffers_info() "{{{
    " redirect output of :ls! to ls_out.
    redir => ls_out
    silent ls!
    redir END
    let buf_list = split(ls_out, "\n")

    " see ':help :ls' about regexp.
    let regex =
        \'^'.'\s*'.
        \'\(\d\+\)'.
        \'\([u ]\)'.
        \'\([%# ]\)'.
        \'\([ah ]\)'.
        \'\([-= ]\)'.
        \'\([\+x ]\)'

    let result = {}

    for line in buf_list
        let m = matchlist(line, regex)
        if empty(m) | continue | endif

        " bufnr:
        "   buffer number.
        "   this must NOT be -1.
        " unlisted:
        "   'u' or empty string.
        "   'u' means buffer is NOT listed.
        "   empty string means buffer is listed.
        " percent_numsign:
        "   '%' or '#' or empty string.
        "   '%' means current buffer.
        "   '#' means sub buffer.
        " a_h:
        "   'a' or 'h' or empty string.
        "   'a' means buffer is loaded and active(displayed).
        "   'h' means buffer is loaded but not active(hidden).
        " minus_equal:
        "   '-' or '=' or empty string.
        "   '-' means buffer is not modifiable.
        "   '=' means buffer is readonly.
        " plus_x:
        "   '+' or 'x' or empty string.
        "   '+' means buffer is modified.
        "   'x' means error occured while loading buffer.
        let [bufnr, unlisted, percent_numsign, a_h, minus_equal, plus_x; rest] = m[1:]

        " skip dumbbuf's buffer.
        if bufnr == s:dumbbuf_bufnr | continue | endif

        call s:debug(string(m))
        let result[bufnr] = {
            \'nr': bufnr + 0,
            \'is_unlisted': unlisted ==# 'u',
            \'is_current': percent_numsign ==# '%',
            \'is_sub': percent_numsign ==# '#',
            \'is_active': a_h ==# 'a',
            \'is_hidden': a_h ==# 'h',
            \'is_modifiable': minus_equal !=# '-',
            \'is_readonly': minus_equal ==# '=',
            \'is_modified': plus_x ==# '+',
            \'is_err': plus_x ==# 'x',
            \'lnum': -1,
        \}
    endfor

    return result
endfunc "}}}
func! s:get_cursor_buffer() "{{{
    for buf in values(s:bufs_info)
        if buf.lnum ==# line('.')
            return buf
        endif
    endfor
    return {}
endfunc "}}}
func! s:is_shown_type(shown_type) "{{{
    return a:shown_type ==# 'listed'
      \ || a:shown_type ==# 'unlisted'
      \ || a:shown_type ==# 'project'
endfunc "}}}
func! s:get_shown_type(caller_bufnr) "{{{
    " this returns exact shown type (this does NOT return '').
    " see g:dumbbuf_shown_type in the document about shown type.

    if s:is_shown_type(g:dumbbuf_shown_type)
        return g:dumbbuf_shown_type
    elseif g:dumbbuf_shown_type == ''
        let info = s:get_buffer_info(a:caller_bufnr)
        if empty(info)
            throw "internal error: can't get caller buffer's info..."
        endif
        return info.is_unlisted ? 'unlisted' : 'listed'
    else
        call s:warn(printf("'%s' is not valid value. please choose in '', 'unlisted', 'listed'.", g:dumbbuf_shown_type))
        call s:warn("use '' as g:dumbbuf_shown_type value...")

        let g:dumbbuf_shown_type = ''
        sleep 1

        return s:get_shown_type(a:caller_bufnr)
    endif
endfunc "}}}
func! s:set_cursor_pos(curbufinfo) "{{{
    " move cursor to the pos
    " which is specified by g:dumbbuf_cursor_pos.

    if g:dumbbuf_cursor_pos ==# 'current'
        if a:curbufinfo.lnum !=# -1
            execute 'normal!' a:curbufinfo.lnum . 'gg'
        endif
    elseif g:dumbbuf_cursor_pos ==# 'keep'
        call s:debug(printf("s:previous_lnum [%d]", s:previous_lnum))
        if s:previous_lnum == -1
            " same as above.
            if a:curbufinfo.lnum !=# -1
                execute 'normal!' a:curbufinfo.lnum . 'gg'
            endif
        else
            " keep.
            execute s:previous_lnum
        endif
    elseif g:dumbbuf_cursor_pos ==# 'top'
        normal! gg
    elseif g:dumbbuf_cursor_pos ==# 'bottom'
        normal! G
    else
        call s:warn(printf("'%s' is not valid value. please choose in 'current', 'top', 'bottom'.", g:dumbbuf_cursor_pos))
        call s:warn("use 'current' as g:dumbbuf_cursor_pos value...")

        let g:dumbbuf_cursor_pos = 'current'

        sleep 1
    endif
endfunc "}}}
func! s:filter_shown_type_buffers(bufs_info) "{{{
    " if current buffer is unlisted, filter unlisted buffers.
    " if current buffers is listed, filter listed buffers.

    call s:debug(printf("filter only '%s' buffers.", s:current_shown_type))

    if s:current_shown_type ==# 'listed'
        return filter(a:bufs_info, '! v:val.is_unlisted')
    elseif s:current_shown_type ==# 'unlisted'
        return filter(a:bufs_info, 'v:val.is_unlisted')
    else
        " TODO option
        return filter(a:bufs_info, '! v:val.is_unlisted')
    endif
endfunc "}}}
func! s:extend_misc_info(buf) "{{{
    let buf = a:buf
    let buf.is_marked = has_key(s:misc_info.marked_bufs, buf.nr)
    let buf.project_name = get(s:misc_info.project_name, buf.nr, '')
    return buf
endfunc "}}}
func! s:add_misc_info(bufs_info) "{{{
    for buf in values(a:bufs_info)
        let buf = s:extend_misc_info(buf)
    endfor
endfunc "}}}
func! s:compile_mappings() "{{{
    let fmt_tmp = ':<C-u>call <SID>run_from_local_map(%s, %s, %s)<CR>'
    let default_mappings = {
        \'v': {
            \'j': {
                \'opt': '<silent>',
                \'mapto': 'j',
            \},
            \'k': {
                \'opt': '<silent>',
                \'mapto': 'k',
            \},
            \
            \'<CR>': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_open'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 0,
                            \'pre': ['close_return_if_empty',
                                    \'close_dumbbuf', 'jump_to_caller']}),
                        \string('v'))
            \},
            \'u': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_open_onebyone'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 0,
                            \'pre': ['close_return_if_empty',
                                    \'close_dumbbuf', 'jump_to_caller'],
                            \'post': ['save_lnum']}),
                        \string('v'))
            \},
            \'o': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('sbuffer %d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': 1,
                            \'process_marked': 1,
                            \'pre': ['close_return_if_empty',
                                    \'close_dumbbuf', 'jump_to_caller'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('v'))
            \},
            \'s': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('split #%d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': 1,
                            \'process_marked': 1,
                            \'pre': ['close_return_if_empty',
                                    \'close_dumbbuf', 'jump_to_caller'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('v'))
            \},
            \'v': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('vsplit #%d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': 1,
                            \'process_marked': 1,
                            \'pre': ['close_return_if_empty',
                                    \'close_dumbbuf', 'jump_to_caller'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('v'))
            \},
            \'t': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('tabedit #%d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': [1, 0],
                            \'process_marked': 1,
                            \'pre': ['close_return_if_empty',
                                    \'close_dumbbuf', 'jump_to_caller'],
                            \'post': ['save_lnum']}),
                        \string('v'))
            \},
            \'d': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('bdelete %d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': 1,
                            \'process_marked': 1,
                            \'pre': ['close_return_if_empty', 'close_dumbbuf'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('v'))
            \},
            \'w': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('bwipeout %d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': 1,
                            \'process_marked': 1,
                            \'pre': ['close_return_if_empty', 'close_dumbbuf'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('v'))
            \},
            \'h': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_toggle_listed_type'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 1,
                            \'args': [0]}),
                        \string('v'))
            \},
            \'l': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_toggle_listed_type'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 1,
                            \'args': [1]}),
                        \string('v'))
            \},
            \'c': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_close'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 0,
                            \'process_marked': 1,
                            \'pre': ['close_return_if_empty', 'close_dumbbuf'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('v'))
            \},
            \
            \'x': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_mark'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 0,
                            \'pre': ['return_if_empty'],
                            \'post': ['save_lnum', 'update_misc']}),
                        \string('v'))
            \},
            \
            \'p': {
                \'opt': '',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_set_project'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 0,
                            \'process_marked': 1,
                            \'pre': ['return_if_empty'],
                            \'post': ['save_lnum', 'update_misc']}),
                        \string('v'))
            \},
        \},
        \'n': {
            \'j': {
                \'opt': '<silent>',
                \'mapto': ':<C-u>call <SID>buflocal_move_lower()<CR>',
            \},
            \'k': {
                \'opt': '<silent>',
                \'mapto': ':<C-u>call <SID>buflocal_move_upper()<CR>',
            \},
            \
            \'gg': {
                \'opt': '<silent>',
                \'mapto': 'gg',
            \},
            \'G': {
                \'opt': '<silent>',
                \'mapto': 'G',
            \},
            \
            \g:dumbbuf_hotkey : {
                \'opt': '<silent>',
                \'mapto': ':<C-u>close<CR>',
            \},
            \'q': {
                \'opt': '<silent>',
                \'mapto': ':<C-u>close<CR>',
            \},
            \
            \'<CR>': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_open'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 0,
                            \'pre': ['close_dumbbuf', 'jump_to_caller']}),
                        \string('n'))
            \},
            \'u': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_open_onebyone'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 0,
                            \'pre': ['close_dumbbuf', 'jump_to_caller'],
                            \'post': ['save_lnum']}),
                        \string('n'))
            \},
            \'o': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('sbuffer %d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': 1,
                            \'process_marked': 1,
                            \'pre': ['close_dumbbuf', 'jump_to_caller'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('n'))
            \},
            \'s': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('split #%d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': 1,
                            \'process_marked': 1,
                            \'pre': ['close_dumbbuf', 'jump_to_caller'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('n'))
            \},
            \'v': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('vsplit #%d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': 1,
                            \'process_marked': 1,
                            \'pre': ['close_dumbbuf', 'jump_to_caller'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('n'))
            \},
            \'t': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('tabedit #%d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': [1, 0],
                            \'process_marked': 1,
                            \'pre': ['close_dumbbuf', 'jump_to_caller'],
                            \'post': ['save_lnum']}),
                        \string('n'))
            \},
            \'d': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('bdelete %d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': 1,
                            \'process_marked': 1,
                            \'pre': ['close_dumbbuf'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('n'))
            \},
            \'w': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('bwipeout %d'),
                        \string({
                            \'type': 'cmd',
                            \'requires_args': 1,
                            \'process_marked': 1,
                            \'pre': ['close_dumbbuf'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('n'))
            \},
            \'h': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_toggle_listed_type'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 1,
                            \'args': [0]}),
                        \string('n'))
            \},
            \'l': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_toggle_listed_type'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 1,
                            \'args': [1]}),
                        \string('n'))
            \},
            \'c': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_close'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 0,
                            \'process_marked': 1,
                            \'pre': ['close_dumbbuf'],
                            \'post': ['save_lnum', 'update_dumbbuf']}),
                        \string('n'))
            \},
            \'x': {
                \'opt': '<silent>',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_mark'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 0,
                            \'pre': [],
                            \'post': ['save_lnum', 'update_misc']}),
                        \string('n'))
            \},
            \'p': {
                \'opt': '',
                \'mapto':
                    \printf(fmt_tmp,
                        \string('<SID>buflocal_set_project'),
                        \string({
                            \'type': 'func',
                            \'requires_args': 0,
                            \'process_marked': 1,
                            \'pre': [],
                            \'post': ['save_lnum', 'update_misc']}),
                        \string('n'))
            \},
        \}
    \}


    let map_vs_code = {}
    let unmap_list = []
    " NOTE: Compile 'default' firstly, 'user' secondly.
    " Because 'user' may unmap the default mappings.
    for [mode, maps] in items(default_mappings) + items(g:dumbbuf_mappings)
        for [from, to] in items(maps)
            " The key 'map_from' works like identifier
            " for map in its mode.
            let map_from = mode . from

            if has_key(map_vs_code, map_from)
                if empty(to)
                    call add(unmap_list, map_from)
                endif
            else
                let def_map = default_mappings[mode]

                if has_key(to, 'alias_to')
                \ && has_key(def_map, to.alias_to)
                \ && has_key(def_map[to.alias_to], 'mapto')
                    let map_vs_code[map_from] =
                        \ printf('%snoremap <buffer>%s %s %s',
                        \       mode,
                        \       (has_key(to, 'opt') ? to.opt : ''),
                        \       from,
                        \       def_map[to.alias_to].mapto)
                elseif has_key(to, 'swap_with')
                \ && has_key(def_map, to.swap_with)
                \ && has_key(def_map[to.swap_with], 'mapto')
                    " Add 'map_from' mapping.
                    let map_vs_code[map_from] =
                        \ printf('%snoremap <buffer>%s %s %s',
                        \       mode,
                        \       (has_key(to, 'opt') ? to.opt : ''),
                        \       from,
                        \       def_map[to.swap_with].mapto)
                    " Remove 'to.swap_with' mapping.
                    call add(unmap_list, mode . to.swap_with)
                elseif has_key(to, 'mapto')
                    let map_vs_code[map_from] =
                        \ printf('%snoremap <buffer>%s %s %s',
                        \       mode,
                        \       (has_key(to, 'opt') ? to.opt : ''),
                        \       from,
                        \       to.mapto)
                endif
            endif

            " Allow 'to' to be assigned with different types.
            " (Why doesn't :for make variables each loop...?)
            unlet to
        endfor
    endfor

    for map in unmap_list
        unlet map_vs_code[map]
    endfor
    let s:mappings.compiled = values(map_vs_code)
endfunc "}}}


" manipulating dumbbuf buffer.
func! dumbbuf#open(...) "{{{
    if s:dumbbuf_bufnr != -1 && s:dumbbuf_bufnr == bufnr('%')
        return
    endif

    " remember current bufnr.
    let s:caller_bufnr = bufnr('%')
    call s:debug('caller buffer name is '.bufname(s:caller_bufnr))
    " save current buffers to s:bufs_info.
    let s:bufs_info = s:parse_buffers_info()
    " decide which type dumbbuf shows.
    if a:0 > 0
        if ! s:is_shown_type(a:1)
            call s:warnf('internal error: %s is not correct shown type.')
            return
        endif
        let s:current_shown_type = a:1
    else
        let s:current_shown_type = s:get_shown_type(s:caller_bufnr)
    endif


    " open and switch to dumbbuf's buffer.
    let s:dumbbuf_bufnr = s:create_dumbbuf_buffer()
    if s:dumbbuf_bufnr ==# -1
        call s:warn("internal error: can't open buffer.")
        return
    endif

    let curbufinfo = s:get_buffer_info(s:caller_bufnr)
    if empty(curbufinfo)
        call s:warn("internal error: can't get current buffer's info")
        return
    endif
    " filter buffers matching current shown type.
    let s:bufs_info = s:filter_shown_type_buffers(s:bufs_info)
    " add miscellaneous info about buffers.
    call s:add_misc_info(s:bufs_info)



    " ======== set up dumbbuf buffer ========

    " name dumbbuf buffer.
    call s:name_dumbbuf_buffer()

    " write buffers list.
    call s:write_buffers_list(s:bufs_info)

    " move cursor to specified position.
    call s:set_cursor_pos(curbufinfo)

    " options
    for opt in g:dumbbuf_options
        let optvarname = '&' . opt.name
        if get(opt, 'restore', 0)
            call add(
            \   s:options_restored,
            \   {
            \       'name': opt.name,
            \       'value': getbufvar(s:caller_bufnr, optvarname),
            \   }
            \)
        endif
        call setbufvar(s:dumbbuf_bufnr, optvarname, opt.value)
    endfor
    " necessary option settings.
    setlocal bufhidden=wipe
    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal noswapfile

    " mappings
    if empty(s:mappings.compiled)
        call s:compile_mappings()
    endif
    for code in s:mappings.compiled
        execute code
    endfor

    " NOTE:
    " highlight group and some options are global settings.
    " so I must restore it later (at s:restore_options()).

    " highlight
    let hl_cursorline = s:get_highlight('CursorLine')
    if type(s:orig_hl_cursorline) == type(0)
        call s:debug(printf("save original CursorLine [%s]", hl_cursorline))
        let s:orig_hl_cursorline = hl_cursorline
    endif
    if hl_cursorline !=# g:dumbbuf_hl_cursorline
        call s:set_highlight('CursorLine', g:dumbbuf_hl_cursorline)
    endif
endfunc "}}}
func! dumbbuf#close() "{{{
    let prevwinnr = winnr()

    if s:jump_to_buffer(s:dumbbuf_bufnr) != -1
        close
    endif

    " jump to previous window.
    if winnr() > prevwinnr
        execute prevwinnr.'wincmd w'
    endif
endfunc "}}}
func! dumbbuf#update(...) "{{{
    " close if exists.
    call dumbbuf#close()
    " open.
    call call('dumbbuf#open', a:000)
endfunc "}}}

func! s:update_only_misc_info() "{{{
    if s:jump_to_buffer(s:dumbbuf_bufnr) == -1
        return
    endif

    let save_modifiable = &l:modifiable
    let save_lazyredraw = &l:lazyredraw
    setlocal modifiable lazyredraw
    try
        for buf in values(s:bufs_info)
            " update 'is_marked'.
            let buf = s:extend_misc_info(buf)
            " rewrite buffers list.
            call setline(buf.lnum, s:eval_disp_expr(buf))
        endfor
    finally
        let &l:modifiable = save_modifiable
        let &l:lazyredraw = save_lazyredraw
    endtry
endfunc "}}}
func! s:jump_to_buffer(bufnr) "{{{
    if a:bufnr ==# bufnr('%') | return a:bufnr | endif
    let winnr = bufwinnr(a:bufnr)
    if winnr != -1 && winnr != winnr()
        call s:debug(printf("jump to ... [%s]", bufname(a:bufnr)))
        execute winnr.'wincmd w'
    endif
    return winnr
endfunc "}}}
func! s:create_dumbbuf_buffer() "{{{
    execute printf("%s %s %dnew",
                \g:dumbbuf_vertical ? 'vertical' : '',
                \g:dumbbuf_open_with,
                \g:dumbbuf_vertical ? g:dumbbuf_buffer_width : g:dumbbuf_buffer_height)
    return bufnr('%')
endfunc "}}}
func! s:name_dumbbuf_buffer() "{{{
    if s:current_shown_type ==# 'listed'
        silent file `=g:dumbbuf_listed_buffer_name`
    elseif s:current_shown_type ==# 'unlisted'
        silent file `=g:dumbbuf_unlisted_buffer_name`
    else
        silent file `=g:dumbbuf_project_buffer_name`
    endif
endfunc "}}}


" highlight
func! s:get_highlight(hl_name) "{{{
    redir => output
    silent execute 'hi' a:hl_name
    redir END
    return substitute(output, '\C' . '.*\<xxx\>\s\+\(.*\)$', '\1', 'g')
endfunc "}}}
func! s:set_highlight(hl_name, value) "{{{
    call s:debug(printf("set highlight '%s' to '%s'.", a:hl_name, a:value))

    " Disable un-specified (by a:value) options.
    let cur_value = s:get_highlight(a:hl_name)
    for [hl_key, hl_val] in map(split(cur_value, '\s\+'), 'split(v:val, "=")')
        execute printf('hi %s %s=NONE', a:hl_name, hl_key)
    endfor

    execute 'hi' a:hl_name a:value
endfunc "}}}


" all mappings start from here.
func! s:run_from_local_map(code, opt, map_mode) "{{{
    let s:now_processing = 1
    let opt = extend(
                \deepcopy(a:opt),
                \{"process_marked": 0, "pre": [], "post": []},
                \"keep")
    " save current range for s:get_buffers_being_processed().
    let [first, last] = [line("'<"), line("'>")]

    " at now, current window should be dumbbuf buffer
    " because this func is called only from dumbbuf buffer local mappings.

    " get selected buffer info.
    let cursor_buf = s:get_cursor_buffer()
    " this must be done in dumbbuf buffer.
    let lnum = line('.')


    try
        call s:do_tasks(opt.pre, cursor_buf, lnum)
        let bufs = s:get_buffers_being_processed(opt, cursor_buf, a:map_mode, first, last)

        " dispatch a:code.
        " NOTE: current buffer may not be caller buffer.
        if type(a:code) == type([])
            for buf in bufs
                let i = 0
                let len = len(a:code)
                while i < len
                    call s:dispatch_code(a:code[i], i, buf, lnum, opt)
                    let i += 1
                endwhile
            endfor
        else
            for buf in bufs
                let i = 0
                call s:dispatch_code(a:code, i, buf, lnum, opt)
            endfor
        endif

        call s:do_tasks(opt.post, cursor_buf, lnum)

    catch /internal error:/
        call s:warn(v:exception)

    catch /^nop$/
        " nop.

    " catch
    "     " NOTE: this traps also unknown other plugin's error...
    "     echoerr printf("internal error: '%s' in '%s'", v:exception, v:throwpoint)

    finally
        let s:now_processing = 0

    endtry
endfunc "}}}
func! s:do_tasks(tasks, cursor_buf, lnum) "{{{
    for t in a:tasks
        " TODO Prepare dispatch table
        if t ==# 'close_dumbbuf'
            call dumbbuf#close()

        elseif t ==# 'jump_to_caller'    " jump to caller buffer.
            call s:jump_to_buffer(s:caller_bufnr)

        elseif t ==# 'close_return_if_empty'
            " if buffer is not available, close dumbbuf and do nothing.
            try
                call s:do_tasks(['return_if_empty'], a:cursor_buf, a:lnum)
            catch /^nop$/
                call dumbbuf#close()
                throw 'nop'
            endtry

        elseif t ==# 'return_if_empty'
            " check buffer's availability.
            if empty(a:cursor_buf)
                call s:warn("can't get buffer on cursor...")
                throw 'nop'
            endif
            if bufname(a:cursor_buf.nr + 0) == ''
                call s:warn("buffer name is empty.")
                throw 'nop'
            endif
            if ! bufexists(a:cursor_buf.nr + 0)
                call s:warn("buffer doesn't exist.")
                throw 'nop'
            endif

        elseif t ==# 'save_lnum'
            " NOTE: do this before 'update'.
            call s:debug("save_lnum:".a:lnum)
            let s:previous_lnum = a:lnum

        elseif t ==# 'update_dumbbuf'
            " close or update dumbbuf buffer.
            if g:dumbbuf_close_when_exec
                call s:debug("just close")
                call dumbbuf#close()
            else
                call s:debug("close and re-open")
                call dumbbuf#update()
            endif

        elseif t ==# 'update_misc'
            call s:update_only_misc_info()

        else
            call s:warn("internal warning: unknown task name: ".t)
        endif
    endfor
endfunc "}}}
func! s:dispatch_code(code, idx, cursor_buf, lnum, opt) "{{{
    " NOTE: a:cursor_buf may be empty.
    call s:debug(string(a:opt))
    let requires_args = type(a:opt.requires_args) == type([]) ?
                \a:opt.requires_args[a:idx] : a:opt.requires_args

    if a:opt.type ==# 'cmd'
        if requires_args
            if empty(a:cursor_buf)
                call s:warn("internal error: a:cursor_buf is empty...")
                return
            endif
            execute printf(a:code, a:cursor_buf.nr)
        else
            execute a:code
        endif
    elseif a:opt.type ==# 'func'
        if requires_args
            call call(a:code, [a:cursor_buf, a:lnum, a:opt] + a:opt.args)
        else
            call call(a:code, [a:cursor_buf, a:lnum, a:opt])
        endif
    else
        throw "internal error: unknown type: ".a:opt.type
    endif
endfunc "}}}
func! s:get_buffers_being_processed(opt, cursor_buf, map_mode, first, last) "{{{
    " if a:code supports 'process_marked' and marked buffers exist,
    " do process marked buffers instead of current cursor buffer.

    if a:map_mode ==# 'v'
        let v_selected_bufs = []
        let save_pos = getpos('.')
        for lnum in range(a:first, a:last)
            call cursor(lnum, 0)
            let buf = s:get_cursor_buffer()
            if !empty(buf)
                call add(v_selected_bufs, buf)
            endif
        endfor
        call setpos('.', save_pos)
        return v_selected_bufs
    elseif a:opt.process_marked && !empty(s:misc_info.marked_bufs)
        let tmp = s:misc_info.marked_bufs
        " Clear marked buffers.
        let s:misc_info.marked_bufs = {}
        return map(keys(tmp), 's:bufs_info[v:val]')
    else
        return [a:cursor_buf]
    endif
endfunc "}}}


" these functions are called from s:dispatch_code()
func! s:buflocal_move_lower() "{{{
    for i in range(1, v:count1)
        if line('.') == line('$')
            if g:dumbbuf_wrap_cursor
                " go to the top of buffer.
                execute '1'
            endif
        else
            normal! j
        endif
    endfor
endfunc "}}}
func! s:buflocal_move_upper() "{{{
    for i in range(1, v:count1)
        if line('.') == 1
            if g:dumbbuf_wrap_cursor
                " go to the bottom of buffer.
                execute line('$')
            endif
        else
            normal! k
        endif
    endfor
endfunc "}}}
func! s:buflocal_open(cursor_buf, lnum, opt) "{{{
    " this must be going to close dumbbuf buffer.

    let winnr = bufwinnr(a:cursor_buf.nr)
    if winnr == -1
        execute a:cursor_buf.nr.'buffer'
    else
        execute winnr.'wincmd w'
    endif
endfunc "}}}
func! s:buflocal_open_onebyone(cursor_buf, lnum, opt) "{{{
    " this does NOT do update or close buffers list.

    " open buffer on the cursor and close dumbbuf buffer.
    call s:buflocal_open(a:opt)
    " re-open dumbbuf buffer.
    call dumbbuf#update()
    " go to previous lnum.
    execute a:lnum

    let save_wrap_cursor = g:dumbbuf_wrap_cursor
    let g:dumbbuf_wrap_cursor = 1
    try
        if g:dumbbuf_downward
            call s:buflocal_move_lower()
        else
            call s:buflocal_move_upper()
        endif
    finally
        let g:dumbbuf_wrap_cursor = save_wrap_cursor
    endtry
endfunc "}}}
func! s:buflocal_toggle_listed_type(cursor_buf, lnum, opt, advance) "{{{
    if ! s:is_shown_type(s:current_shown_type)
        " NOTE: s:current_shown_type MUST NOT be ''.
        call s:warn("internal warning: strange s:current_shown_type value...: ".s:current_shown_type)
        return
    endif
    if ! (0 <= s:shown_type_idx && s:shown_type_idx < len(g:dumbbuf_all_shown_types))
        call s:warn("out of range")
        return
    endif

    if a:advance    " mapping 'l'.
        if s:shown_type_idx == len(g:dumbbuf_all_shown_types) - 1
            let s:shown_type_idx = 0
        else
            let s:shown_type_idx += 1
        endif
    else    " mapping 'h'.
        if s:shown_type_idx == 0
            let s:shown_type_idx = len(g:dumbbuf_all_shown_types) - 1
        else
            let s:shown_type_idx -= 1
        endif
    endif

    call dumbbuf#update(g:dumbbuf_all_shown_types[s:shown_type_idx])
endfunc "}}}
func! s:buflocal_close(cursor_buf, lnum, opt) "{{{
    if s:jump_to_buffer(a:cursor_buf.nr) != -1
        close
    endif
endfunc "}}}
func! s:buflocal_mark(cursor_buf, lnum, opt) "{{{
    if has_key(s:misc_info.marked_bufs, a:cursor_buf.nr)
        " remove from marked.
        unlet s:misc_info.marked_bufs[a:cursor_buf.nr]
    else
        " add to marked.
        let s:misc_info.marked_bufs[a:cursor_buf.nr] = 1
    endif
endfunc "}}}
func! s:buflocal_set_project(cursor_buf, lnum, opt) "{{{
    redraw
    let nr   = a:cursor_buf.nr
    let name = fnamemodify(bufname(nr), ':t')
    " TODO option
    " 1. fmt of printf()
    " 2. default input value of input()
    let proj_name = input(printf("%s's Project Name:", name),
                    \     a:cursor_buf.project_name)
    if proj_name != ''
        " NOTE: use strtrans() for buffers who belong to no project.
        " see s:eval_sorted_bufs().
        let s:misc_info.project_name[nr] = strtrans(proj_name)
        call s:update_only_misc_info()
    endif
endfunc "}}}
" }}}

" Autocmd {{{
func! s:restore_options() "{{{
    call s:debug("s:restore_options()...")
    " Assumption: Already out of dumbbuf buffer.

    " restore ...

    " &timeout, &timeoutlen
    for opt in s:options_restored
        call setbufvar('%', '&' . opt.name, opt.value)
    endfor
    let s:options_restored = []
    " highlight 'CursorLine'
    if type(s:orig_hl_cursorline) != type(0)
        call s:set_highlight('CursorLine', s:orig_hl_cursorline)
    endif
    " remove all marked buffers if g:dumbbuf_remove_marked_when_close
    if g:dumbbuf_remove_marked_when_close && ! s:now_processing
        let s:misc_info.marked_bufs = {}
    endif
endfunc "}}}

augroup DumbBuf
    autocmd!

    for i in [g:dumbbuf_listed_buffer_name, g:dumbbuf_unlisted_buffer_name, g:dumbbuf_project_buffer_name]
        " restore global settings
        execute 'autocmd BufWipeout' i 'call s:restore_options()'
    endfor
augroup END
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
