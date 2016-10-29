" don't load plugins automatically since the initialization is done here
set nolpl

" plugin configuration
packadd myconfig_pre

" load plugins
packloadall

" load Tim Pope's sensible vim settings
packadd sensible

" personal vim settings
packadd myconfig_post
