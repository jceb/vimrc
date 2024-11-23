return {
  -- https://github.com/junegunn/goyo.vim
  "junegunn/goyo.vim",
  cmd = { "Goyo" },
  config = function()
    vim.cmd([[
                  function! TmuxMaximize()
                    if exists('$TMUX')
                        silent! !tmux set-option status off
                        silent! !tmux resize-pane -Z
                    endif
                  endfun
                ]])
    vim.cmd([[
                  function! TmuxRestore()
                    if exists('$TMUX')
                        silent! !tmux set-option status on
                        silent! !tmux resize-pane -Z
                    endif
                  endfun
                ]])
    vim.cmd('let g:goyo_callbacks = [ function("TmuxMaximize"), function("TmuxRestore") ]')
  end,
}
