vim.o.encoding = "utf-8"
-- let g:neovide_cursor_animation_length=0

-- " INFO: disable python3 provider as it's not used
-- let g:loaded_python3_provider = 1

vim.cmd.packadd("myconfig_1_pre")

require("settings")
require("keybindings")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
-- https://github.com/folke/lazy.nvim
require("lazy").setup("plugins", {
    root = vim.fn.stdpath("config") .. "/lazy",
    ui = { custom_keys = {
        ["<localleader>l"] = false,
        ["<localleader>t"] = false,
    } },
    performance = {
        rtp = {
            disabled_plugins = {
                "matchit",
                "netrwPlugin",
                "tutor",
                "tohtml",
                "tarPlugin",
                "zipPlugin",
                "gzip",
            },
        },
    },
})

-- load matchup plugin before matchit
-- packadd matchup

-- function! s:init()
vim.opt.packpath:append(vim.fn.stdpath("config"))
-- " personal vim settings
vim.cmd.packadd("myconfig_2_post")

-- " workaround because the event isn't triggered by the above command for some
-- " unknown reason
vim.cmd.doau("ColorScheme")

-- let g:my_gui_font = "JetBrainsMono Nerd Font:h9"
-- exec ":set guifont=".fnameescape(g:my_gui_font)
-- command! GuiFontBigger  :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)+1', ''))
-- command! GuiFontSmaller :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)-1', ''))
-- nnoremap <silent> <C-0> :<C-u>exec ":set guifont=".fnameescape(g:my_gui_font)<CR>
-- nnoremap <silent> <C--> :<C-u>GuiFontSmaller<CR>
-- nnoremap <silent> <C-8> :<C-u>GuiFontSmaller<CR>
-- nnoremap <silent> <C-ScrollWheelDown> :<C-u>GuiFontSmaller<CR>
-- nnoremap <silent> <C-=> :<C-u>GuiFontBigger<CR>
-- nnoremap <silent> <C-+> :<C-u>GuiFontBigger<CR>
-- nnoremap <silent> <C-9> :<C-u>GuiFontBigger<CR>
-- nnoremap <silent> <C-ScrollWheelUp> :<C-u>GuiFontBigger<CR>

-- " set SSH environment variable in case it isn't set, e.g. in nvim-qt
-- if getenv('SSH_AUTH_SOCK') == v:null
--   call setenv('SSH_AUTH_SOCK', systemlist('gpgconf --list-dirs agent-ssh-socket')[0])
-- endif
-- endfunction

-- if v:vim_did_enter
--   call s:init()
-- else
--   au VimEnter * call s:init()
-- endif
