" plugin configuration
runtime! config/plugin_config.vim

" load plugins
packloadall!
runtime config/plugin_manager.vim

" load Tim Pope's sensible vim settings
packadd sensible

" personal vim settings
runtime config/settings.vim

" key bindings
runtime config/keybindings.vim

" commands
runtime config/commands.vim

" auto commands
runtime config/auto_commands.vim

" personal settings
runtime! config/personal.vim
