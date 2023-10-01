vim.o.encoding = "utf-8"
-- let g:neovide_cursor_animation_length=0

-- " INFO: disable python3 provider as it's not used
-- let g:loaded_python3_provider = 1

vim.cmd.packadd("myconfig_1_pre")

require("settings")
require("keybindings")

-- https://github.com/folke/lazy.nvim
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

vim.opt.packpath:append(vim.fn.stdpath("config"))
-- personal vim settings
vim.cmd.packadd("myconfig_2_post")

-- workaround because the event isn't triggered by the above command for some
-- unknown reason
vim.cmd.doau("ColorScheme")

vim.g.my_gui_font = "JetBrainsMono Nerd Font:h9"
vim.o.guifont = vim.fn.fnameescape(vim.g.my_gui_font)
vim.cmd([[
command! GuiFontBigger  :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)+1', ''))
command! GuiFontSmaller :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)-1', ''))
]])

map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

map("n", "<C-0>", ":<C-u>exec ':set guifont='.fnameescape(g:my_gui_font)<CR>", { silent = true })
map("n", "<C-->", ":<C-u>GuiFontSmaller<CR>", { silent = true })
map("n", "<C-8>", ":<C-u>GuiFontSmaller<CR>", { silent = true })
map("n", "<C-ScrollWheelDown>", ":<C-u>GuiFontSmaller<CR>", { silent = true })
map("n", "<C-=>", ":<C-u>GuiFontBigger<CR>", { silent = true })
map("n", "<C-+>", ":<C-u>GuiFontBigger<CR>", { silent = true })
map("n", "<C-9>", ":<C-u>GuiFontBigger<CR>", { silent = true })
map("n", "<C-ScrollWheelUp>", ":<C-u>GuiFontBigger<CR>", { silent = true })

-- " set SSH environment variable in case it isn't set, e.g. in nvim-qt
-- if getenv('SSH_AUTH_SOCK') == v:null
--   call setenv('SSH_AUTH_SOCK', systemlist('gpgconf --list-dirs agent-ssh-socket')[0])
-- endif
