map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
    ----------------------
    -- terminal
    ----------------------
    {
        -- https://github.com/kassio/neoterm
        "kassio/neoterm",
        lazy = false,
        -- cmd = { "Tnew" },
        init = function(plugin)
            vim.g.neoterm_direct_open_repl = 0
            vim.g.neoterm_open_in_all_tabs = 1
            vim.g.neoterm_autoscroll = 1
            vim.g.neoterm_term_per_tab = 1
            -- vim.g.neoterm_shell = "fish"
            vim.g.neoterm_shell = "nu"
            vim.g.neoterm_autoinsert = 1
            vim.g.neoterm_automap_keys = "<F23>"
            -- taken from https://github.com/folke/lazy.nvim/issues/574
            -- vim.fn["neoterm#new"] = function(...)
            --     vim.fn["neoterm#new"] = nil
            --     require("lazy").load({ plugins = { plugin } })
            --     print("gogog")
            --     return vim.fn["neoterm#new"](...)
            -- end
        end,
    },
    {
        -- https://github.com/voldikss/vim-floaterm
        "voldikss/vim-floaterm",
        lazy = true,
        cmd = {
            "FloatermToggle",
            "FloatermNew",
            "FloatermPrev",
            "FloatermNext",
        },
        keys = { { "<M-/>" } },
        init = function()
            vim.g.floaterm_autoclose = 1
            -- vim.g.floaterm_shell = "fish"
            vim.g.floaterm_shell = "nu"
        end,
        config = function()
            vim.cmd([[
        tnoremap <silent> <M-h> <C-\><C-n>:FloatermPrev<CR>
        tnoremap <silent> <M-l> <C-\><C-n>:FloatermNext<CR>
        nnoremap <silent> <M-/> :FloatermToggle<CR>
        tnoremap <silent> <M-/> <C-\><C-n>:FloatermToggle<CR>
        nnoremap <silent> <M-S-t> :exec "FloatermNew --cwd=".fnameescape(expand("%:h"))<CR>
        nnoremap <silent> <M-t> :FloatermNew<CR>
        tnoremap <silent> <M-t> <C-\><C-n>:FloatermNew<CR>
        nnoremap <silent> <M-S-e> :exec "FloatermNew --cwd=".fnameescape(expand("%:h"))." nnn -Q"<CR>
        nnoremap <silent> <M-e> :FloatermNew nnn -Q<CR>
        ]])
        end,
    },
    -- use {
    --     -- https://github.com/akinsho/nvim-toggleterm.lua
    --     "akinsho/nvim-toggleterm.lua",
    --     lazy = true,
    --     cmd = {"ToggleTerm", "TermExec", "ToggleTermOpenAll", "ToggleTermCloseAll"},
    --     config = function()
    --         require("toggleterm").setup(
    --             {
    --                 -- size can be a number or function which is passed the current terminal
    --                 size = function(term)
    --                     if term.direction == "horizontal" then
    --                         return 15
    --                     elseif term.direction == "vertical" then
    --                         return vim.o.columns * 0.4
    --                     end
    --                 end,
    --                 open_mapping = [[<C-/>]],
    --                 hide_numbers = true, -- hide the number column in toggleterm buffers
    --                 shade_filetypes = {},
    --                 shade_terminals = false,
    --                 -- shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    --                 start_in_insert = true,
    --                 insert_mappings = true, -- whether or not the open mapping applies in insert mode
    --                 persist_size = true,
    --                 direction = "vertical", -- | "horizontal" | "window" | "float",
    --                 close_on_exit = true, -- close the terminal window when the process exits
    --                 -- shell = vim.o.shell, -- change the default shell
    --                 shell = "fish", -- change the default shell
    --                 -- This field is only relevant if direction is set to 'float'
    --                 float_opts = {
    --                     -- The border key is *almost* the same as 'nvim_win_open'
    --                     -- see :h nvim_win_open for details on borders however
    --                     -- the 'curved' border is a custom border type
    --                     -- not natively supported but implemented in this plugin.
    --                     border = "single", -- | "double" | "shadow" | "curved", -- | ... other options supported by win open
    --                     -- width = <value>,
    --                     -- height = <value>,
    --                     winblend = 3,
    --                     highlights = {
    --                         border = "Normal",
    --                         background = "Normal"
    --                     }
    --                 }
    --             }
    --         )
    --     end
    -- }
}
