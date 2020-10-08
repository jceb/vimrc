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
call textobj#uri#add_pattern('', '[bB]ug:\\? #\\?\\([0-9]\\+\\)', ":silent !xdg-open 'http://forge.univention.org/bugzilla/show_bug.cgi?id=%s'")
call textobj#uri#add_pattern('', '[tT]icket:\\? #\\?\\([0-9]\\+\\)', ":silent !xdg-open 'https://gorm.knut.univention.de/otrs/index.pl?Action=AgentTicketZoom&TicketNumber=%s'")
call textobj#uri#add_pattern('', '[iI]ssue:\\? #\\?\\([0-9]\\+\\)', ":silent !xdg-open 'https://univention.plan.io/issues/%s'")

if exists('g:fvim_loaded')
    " ColorschemeOne
    " ColorschemeOneLight
    ColorschemePaperColor
else
    " ColorschemeOne
    " ColorschemeOneLight
    ColorschemePaperColor
endif
