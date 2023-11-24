map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
    ----------------------
    -- window management
    ----------------------
    -- {
    --     -- https://github.com/rbong/vim-buffest
    --     "rbong/vim-buffest",
    -- },
    {
        -- https://github.com/0x00-ketsu/maximizer.nvim
        "0x00-ketsu/maximizer.nvim",
        config = function()
            require("maximizer").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
            -- vim.api.nvim_set_keymap(
            --     "n",
            --     "<Space>z",
            --     '<cmd>lua require("maximizer").toggle()<CR>',
            --     { silent = true, noremap = true }
            -- )
        end,
    },
    -- {
    --     -- https://github.com/szw/vim-maximizer
    --     "szw/vim-maximizer",
    --     lazy = true,
    --     cmd = { "MaximizerToggle" },
    --     config = function()
    --         vim.g.maximizer_restore_on_winleave = 1
    --     end,
    -- },
    {
        -- https://github.com/folke/zen-mode.nvim
        "folke/zen-mode.nvim",
        lazy = true,
        cmd = { "ZenMode" },
        config = function()
            require("zen-mode").setup({
                window = {
                    width = 130,
                },
                options = {
                    foldcolumn = "0",
                    signcolumn = "no",
                },
            })
        end,
    },
    -- {
    --     -- https://github.com/junegunn/goyo.vim
    --     "junegunn/goyo.vim",
    --     lazy = true,
    --     cmd = { "Goyo" },
    --     config = function()
    --         vim.cmd([[
    --                 function! TmuxMaximize()
    --                   if exists('$TMUX')
    --                       silent! !tmux set-option status off
    --                       silent! !tmux resize-pane -Z
    --                   endif
    --                 endfun
    --               ]])
    --         vim.cmd([[
    --                 function! TmuxRestore()
    --                   if exists('$TMUX')
    --                       silent! !tmux set-option status on
    --                       silent! !tmux resize-pane -Z
    --                   endif
    --                 endfun
    --               ]])
    --         vim.cmd(
    --             "let g:goyo_callbacks = [ function(\"TmuxMaximize\"), function(\"TmuxRestore\") ]"
    --         )
    --     end,
    -- },
}
