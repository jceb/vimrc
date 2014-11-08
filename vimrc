" Author: Jan Christoph Ebersbach jceb AT e-jc DOT de
if has('nvim')
	runtime! python_setup.vim
endif

" global variables to make life easier when dealing with different
" system environments
let g:sep = pathogen#separator()
let g:vimdir = '~'.g:sep.(has('unix') ? '.vim' : 'vimfiles')
let g:vimconfigdir = g:vimdir.g:sep.'config'

" ToC - use UTL to jump to the entries
" <url:~/.vim/config/plugin_config.vim#tn=Plugin Settings:>
exec 'source '.g:vimconfigdir.g:sep.'plugin_config.vim'

" <url:~/.vim/config/plugin_manager.vim#tn=Plugin Manager:>
exec 'source '.g:vimconfigdir.g:sep.'plugin_manager.vim'

" load Tim Pope's sensible vim settings
" <url:~/.vim/misc/sensible/sensible.vim>
exec 'source '.g:vimdir.g:sep.'misc'.g:sep.'opinion'.g:sep.'plugin'.g:sep.'opinion.vim'
exec 'source '.g:vimdir.g:sep.'misc'.g:sep.'sensible'.g:sep.'plugin'.g:sep.'sensible.vim'

" <url:~/.vim/config/settings.vim#tn=Global Settings:>
" <url:~/.vim/config/settings.vim#tn=Miscellaneous Settings:>
" <url:~/.vim/config/settings.vim#tn=Visual Settings:>
" <url:~/.vim/config/settings.vim#tn=Text Settings:>
exec 'source '.g:vimconfigdir.g:sep.'settings.vim'

" <url:~/.vim/config/keybindings.vim#tn=Keymappings:>
" <url:~/.vim/config/keybindings.vim#tn=Changes To The Default Behavior:>
exec 'source '.g:vimconfigdir.g:sep.'keybindings.vim'

" <url:~/.vim/config/commands.vim#tn=Commands:>
exec 'source '.g:vimconfigdir.g:sep.'commands.vim'

" <url:~/.vim/config/auto_commands.vim#tn=Autocommands:>
exec 'source '.g:vimconfigdir.g:sep.'auto_commands.vim'

" <url:~/.vim/config/personal.vim#tn=Personal Settings:>
exec 'source '.g:vimconfigdir.g:sep.'personal.vim'
