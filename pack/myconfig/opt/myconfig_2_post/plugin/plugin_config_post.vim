" Textobj-uri {{{1
call textobj#uri#add_pattern('', '[bB]ug:\\? #\\?\\([0-9]\\+\\)', ":silent !xdg-open 'http://forge.univention.org/bugzilla/show_bug.cgi?id=%s'")
call textobj#uri#add_pattern('', '[tT]icket:\\? #\\?\\([0-9]\\+\\)', ":silent !xdg-open 'https://gorm.knut.univention.de/otrs/index.pl?Action=AgentTicketZoom&TicketNumber=%s'")
call textobj#uri#add_pattern('', '[iI]ssue:\\? #\\?\\([0-9]\\+\\)', ":silent !xdg-open 'https://univention.plan.io/issues/%s'")

" Grepper {{{1
nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)
let g:grepper.tools = ['rg', 'git', 'grep']

