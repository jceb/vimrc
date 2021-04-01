" Grepper {{{1
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
let g:grepper.tools = ['rg', 'grep', 'git']
let g:grepper.prompt = 1
let g:grepper.highlight = 0
let g:grepper.open = 1
let g:grepper.switch = 1
let g:grepper.dir = 'repo,cwd,file'
let g:grepper.jump = 0

" " nvim-lsp {{{1
" lua << END
" local nvim_lsp = require'nvim_lsp'
" nvim_lsp.bashls.setup{}
" nvim_lsp.cssls.setup{}
" nvim_lsp.html.setup{}
" nvim_lsp.jsonls.setup{}
" nvim_lsp.pyls.setup{}
" nvim_lsp.tsserver.setup{}
" nvim_lsp.vimls.setup{}
" nvim_lsp.vuels.setup{}
" nvim_lsp.yamlls.setup{}
" END

" Textobj-uri {{{1
call textobj#uri#add_pattern('', '[bB]ug:\? #\?\([0-9]\+\)', ":silent !open-cli 'http://forge.univention.org/bugzilla/show_bug.cgi?id=%s' &")
call textobj#uri#add_pattern('', '[tT]icket:\? #\?\([0-9]\+\)', ":silent !open-cli 'https://gorm.knut.univention.de/otrs/index.pl?Action=AgentTicketZoom&TicketNumber=%s' &")
call textobj#uri#add_pattern('', '[iI]ssue:\? #\?\([0-9]\+\)', ":silent !open-cli 'https://univention.plan.io/issues/%s' &")
call textobj#uri#add_pattern('', '[tT][gG]-\([0-9]\+\)', ":!open-cli 'https://tree.taiga.io/project/jceb-identinet-development/us/%s' &")

let s:colorscheme_set_once = 0
function! TimeSetColorscheme(...)
    " idea: use `redshift -p 2>/dev/null | awk '/Period:/ {print $2}'` to
    " determine the colorscheme
    let l:time = trim(strftime('%k%M', localtime())) + 0
    if l:time >= 700 && l:time < 1800
        if s:colorscheme_set_once == 0 || g:lightline.colorscheme != 'PaperColor'
            ColorschemePaperColor
            let s:colorscheme_set_once = 1
        endif
    else
        if s:colorscheme_set_once == 0 || g:lightline.colorscheme != 'nord'
            ColorschemeNord
            let s:colorscheme_set_once = 1
        endif
    endif
endfunction

call TimeSetColorscheme()
if exists('g:colorscheme_timer')
    call timer_stop(g:colorscheme_timer)
endif
let g:colorscheme_timer = timer_start(30000, 'TimeSetColorscheme', {'repeat': -1})

if exists('g:started_by_firenvim')
  set laststatus=0
  set showtabline=0
  set nonumber norelativenumber
  " au BufEnter *.txt set filetype=markdown

  let g:firenvim_config = {
              \ 'globalSettings': {
                  \ 'alt': 'all',
              \  },
              \ 'localSettings': {
                  \ '.*': {
                          \ 'cmdline': 'firenvim',
                          \ 'priority': 0,
                          \ 'selector': 'textarea',
                          \ 'takeover': 'never',
                      \ },
                  \ }
              \ }
  let fc = g:firenvim_config['localSettings']
  let fc['https?://[^/]*twitter\.com/'] = { 'takeover': 'never', 'priority': 1 }
  let fc['https?://[^/]*trello\.com/'] = { 'takeover': 'never', 'priority': 1 }
else
    set laststatus=2
endif
