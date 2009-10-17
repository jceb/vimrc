"=============================================================================
" Copyright (c) 2007-2009 Takeshi NISHIDA
"
"=============================================================================
" LOAD GUARD {{{1

if exists('g:loaded_autoload_fuf_quickfix') || v:version < 702
  finish
endif
let g:loaded_autoload_fuf_quickfix = 1

" }}}1
"=============================================================================
" GLOBAL FUNCTIONS {{{1

"
function fuf#quickfix#createHandler(base)
  return a:base.concretize(copy(s:handler))
endfunction

"
function fuf#quickfix#getSwitchOrder()
  return g:fuf_quickfix_switchOrder
endfunction

"
function fuf#quickfix#renewCache()
endfunction

"
function fuf#quickfix#requiresOnCommandPre()
  return 0
endfunction

"
function fuf#quickfix#onInit()
  call fuf#defineLaunchCommand('FufQuickfix', s:MODE_NAME, '""')
endfunction

" }}}1
"=============================================================================
" LOCAL FUNCTIONS/VARIABLES {{{1

let s:MODE_NAME = expand('<sfile>:t:r')

"
function s:getJumpsLines()
  redir => result
  :silent jumps
  redir END
  return split(result, "\n")
endfunction

"
function s:parseJumpsLine(line)
  return matchlist(a:line, '^\(.\)\s\+\(\d\+\)\s\(.*\)$')
endfunction

"
function s:makeItem(qfItem)
  if !a:qfItem.valid
    return {}
  endif
  return fuf#makeNonPathItem(
        \ printf('%s|%d:%d|%s', bufname(a:qfItem.bufnr), a:qfItem.lnum,
        \        a:qfItem.col, matchstr(a:qfItem.text, '\s*\zs.*\S'))
        \ , '')
endfunction

" }}}1
"=============================================================================
" s:handler {{{1

let s:handler = {}

"
function s:handler.getModeName()
  return s:MODE_NAME
endfunction

"
function s:handler.getPrompt()
  return g:fuf_quickfix_prompt
endfunction

"
function s:handler.targetsPath()
  return 0
endfunction

"
function s:handler.onComplete(patternSet)
  return fuf#filterMatchesAndMapToSetRanks(
        \ self.items, a:patternSet, self.getFilteredStats(a:patternSet.raw))
endfunction

"
function s:handler.onOpen(expr, mode)
  call fuf#prejump(a:mode)
  call filter(self.items, 'v:val.word ==# a:expr')
  if !empty(self.items)
    execute 'cc ' . self.items[0].index
  endif
endfunction

"
function s:handler.onModeEnterPre()
endfunction

"
function s:handler.onModeEnterPost()
  let self.items = getqflist()
  call map(self.items, 's:makeItem(v:val)')
  call fuf#mapToSetSerialIndex(self.items, 1)
  call filter(self.items, 'exists("v:val.word")')
  call map(self.items, 'fuf#setAbbrWithFormattedWord(v:val)')
endfunction

"
function s:handler.onModeLeavePost(opened)
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker:

