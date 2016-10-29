" Plugin Manager:
" ------------------

if exists('g:vimrc_plugins_loaded')
	finish
endif
let g:vimrc_plugins_loaded = 1

filetype plugin indent on        " activate filetype auto detection, automatically load filetypeplugins, indent according to the filetype

" ------------------------------------------------------------
" Textobj-uri:
call textobj#uri#add_pattern('', '[bB]ug:\\? #\\?\\([0-9]\\+\\)', ":silent !xdg-open 'http://forge.univention.org/bugzilla/show_bug.cgi?id=%s'")
call textobj#uri#add_pattern('', '[tT]icket:\\? #\\?\\([0-9]\\+\\)', ":silent !xdg-open 'https://gorm.knut.univention.de/otrs/index.pl?Action=AgentTicketZoom&TicketNumber=%s'")
call textobj#uri#add_pattern('', '[iI]ssue:\\? #\\?\\([0-9]\\+\\)', ":silent !xdg-open 'https://univention.plan.io/issues/%s'")
