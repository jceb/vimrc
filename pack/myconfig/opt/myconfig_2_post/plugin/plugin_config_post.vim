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

" " Denite {{{1
" let s:menus = {}
" let s:menus.vim = {
"     \ 'description': "vim's init files"
"     \ }
" let s:menus.vim.file_candidates = [
"     \ ['init.vim', '~/.config/nvim/init.vim'],
"     \ ['ginit.vim', '~/.config/nvim/ginit.vim'],
"     \ ]
"
"
" call denite#custom#var('menu', 'menus', s:menus)
" call denite#custom#alias('source', 'directory_rec/cd', 'directory_rec')
" call denite#custom#source('directory_rec/cd', 'default_action', 'cd')
" " call denite#custom#source('line', 'matchers', ['matcher/fuzzy'])

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

let time = strftime('%H', localtime()) + 0
if time >= 7 && time < 18
    ColorschemePaperColor
else
    ColorschemeNord
endif

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

