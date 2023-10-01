map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
    ----------------------
    -- file management
    ----------------------
    -- {
    --     -- https://github.com/tpope/vim-vinegar
    --     "tpope/vim-vinegar",
    -- },
    {
        -- https://github.com/kyazdani42/nvim-tree.lua
        "kyazdani42/nvim-tree.lua",
        lazy = true,
        cmd = { "NvimTreeOpen", "NvimTreeToggle" },
        dependencies = {
            -- https://github.com/kyazdani42/nvim-web-devicons
            "kyazdani42/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                disable_netrw = false,
                hijack_netrw = false,
                update_focused_file = {
                    enable = true,
                    ignore_list = { ".git", "node_modules", ".cache" },
                },
                actions = {
                    open_file = {
                        quit_on_open = false,
                        -- quit_on_open = true,
                        window_picker = {
                            enable = false, -- open files in the previous window
                        },
                    },
                },
                renderer = {
                    indent_markers = {
                        enable = true,
                    },
                },
            })
            local tree_cb = require("nvim-tree.config").nvim_tree_callback
            vim.g.nvim_tree_bindings = {
                {
                    key = { "<CR>", "o", "<2-LeftMouse>" },
                    cb = tree_cb("edit"),
                },
                { key = { "<2-RightMouse>", "<C-]>" }, cb = tree_cb("cd") },
                { key = "<C-v>", cb = tree_cb("vsplit") },
                { key = "<C-x>", cb = tree_cb("split") },
                { key = "<C-t>", cb = tree_cb("tabnew") },
                { key = "<", cb = tree_cb("prev_sibling") },
                { key = ">", cb = tree_cb("next_sibling") },
                { key = "P", cb = tree_cb("parent_node") },
                { key = "<BS>", cb = tree_cb("close_node") },
                { key = "<S-CR>", cb = tree_cb("close_node") },
                { key = "<Tab>", cb = tree_cb("preview") },
                { key = "K", cb = tree_cb("first_sibling") },
                { key = "J", cb = tree_cb("last_sibling") },
                { key = "I", cb = tree_cb("toggle_ignored") },
                { key = "H", cb = tree_cb("toggle_dotfiles") },
                { key = "R", cb = tree_cb("refresh") },
                { key = "a", cb = tree_cb("create") },
                { key = "d", cb = tree_cb("remove") },
                { key = "r", cb = tree_cb("rename") },
                { key = "<C-r>", cb = tree_cb("full_rename") },
                { key = "x", cb = tree_cb("cut") },
                { key = "c", cb = tree_cb("copy") },
                { key = "p", cb = tree_cb("paste") },
                { key = "y", cb = tree_cb("copy_name") },
                { key = "Y", cb = tree_cb("copy_path") },
                { key = "gy", cb = tree_cb("copy_absolute_path") },
                { key = "[c", cb = tree_cb("prev_git_item") },
                { key = "]c", cb = tree_cb("next_git_item") },
                { key = "-", cb = tree_cb("dir_up") },
                { key = "q", cb = tree_cb("close") },
                { key = "g?", cb = tree_cb("toggle_help") },
            }
        end,
    },
    {
        -- https://github.com/nvim-telescope/telescope.nvim
        "nvim-telescope/telescope.nvim",
        dependencies = {
            -- https://github.com/nvim-lua/popup.nvim
            "nvim-lua/popup.nvim",
            -- https://github.com/nvim-lua/plenary.nvim
            "nvim-lua/plenary.nvim",
            {
                -- https://github.com/nvim-telescope/telescope-fzy-native.nvim
                "nvim-telescope/telescope-fzy-native.nvim",
                build = { "make" },
            },
            -- https://github.com/kyazdani42/nvim-web-devicons
            "kyazdani42/nvim-web-devicons",
            -- https://github.com/JoseConseco/telescope_sessions_picker.nvim
            "JoseConseco/telescope_sessions_picker.nvim",
            -- https://github.com/jceb/telescope_bookmark_picker.nvim
            "jceb/telescope_bookmark_picker.nvim",
            -- https://github.com/AckslD/nvim-neoclip.lua
            {
                "AckslD/nvim-neoclip.lua",
                config = function()
                    require("neoclip").setup({
                        history = 100,
                        keys = {
                            telescope = {
                                i = {
                                    paste = "<c-j>",
                                },
                            },
                        },
                    })
                end,
            },
        },
        -- lazy = true, -- FIXME opt doesn't work for some unknown reason
        cmd = { "Telescope" },
        config = function()
            local actions = require("telescope.actions")
            -- local sorters = require("telescope.sorters")
            -- local trouble = require("trouble.providers.telescope")
            -- Global remapping
            ------------------------------
            require("telescope").load_extension("fzy_native")
            -- require("telescope").load_extension("neoclip")
            require("telescope").setup({
                defaults = {
                    -- file_ignore_patterns = {
                    --     ".git/",
                    --     "%.bak",
                    -- },
                    mappings = {
                        i = {
                            ["<c-x>"] = false,
                            ["<C-s>"] = actions.file_split,
                            ["<esc>"] = actions.close,
                            -- ["<c-t>"] = trouble.open_with_trouble,
                        },
                        n = {
                            ["<esc>"] = actions.close,
                            -- ["<c-t>"] = trouble.open_with_trouble,
                        },
                    },
                },
                extensions = {
                    sessions_picker = {
                        sessions_dir = vim.env.HOME .. "/.sessions/",
                    },
                    bookmark_picker = {},
                },
            })
            require("telescope").load_extension("sessions_picker")
            require("telescope").load_extension("bookmark_picker")
            require("telescope").load_extension("neoclip")
            vim.cmd("highlight link TelescopeMatching IncSearch")
        end,
    },
    -- {
    --     -- https://github.com/elihunter173/dirbuf.nvim
    --     "elihunter173/dirbuf.nvim",
    --     lazy = true,
    --     cmd = { "Dirbuf", "Explore", "Sexplore", "Vexplore" },
    --     keys = { { "n", "<Plug>(dirbuf_up)" } },
    --     init = function()
    --         vim.g.netrw_browsex_viewer = "xdg-open-background"
    --         local opts = { noremap = true, silent = true }
    --         map(
    --             "n",
    --             "<Plug>NetrwBrowseX",
    --             ":call netrw#BrowseX(expand((exists(\"g:netrw_gx\")? g:netrw_gx : \"<cfile>\")),netrw#CheckIfRemote())<CR>",
    --             opts
    --         )
    --         map("n", "gx", "<Plug>NetrwBrowseX", {})
    --         map(
    --             "v",
    --             "<Plug>NetrwBrowseXVis",
    --             ":<c-u>call netrw#BrowseXVis()<CR>",
    --             opts
    --         )
    --         map("v", "gx", "<Plug>NetrwBrowseXVis", {})
    --
    --         vim.cmd("command! -nargs=? -complete=dir Explore Dirbuf <args>")
    --         vim.cmd(
    --             "command! -nargs=? -complete=dir Sexplore belowright split | silent Dirbuf <args>"
    --         )
    --         vim.cmd(
    --             "command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirbuf <args>"
    --         )
    --     end,
    --     config = function()
    --         require("dirbuf").setup({
    --             sort_order = "directories_first",
    --         })
    --     end,
    -- },
    {
        -- https://github.com/justinmk/vim-dirvish
        "justinmk/vim-dirvish",
        -- dependencies = {
        --     -- https://github.com/bounceme/remote-viewer
        --     "bounceme/remote-viewer",
        -- },
        -- lazy = true,
        -- cmd = { "Dirvish" },
        -- keys = { { "<Plug>(dirvish_up)" } },
        init = function()
            vim.g.dirvish_mode = [[ :sort ,^.*[\/], ]]

            vim.g.netrw_browsex_viewer = "xdg-open-background"
            local opts = { noremap = true, silent = true }
            map(
                "n",
                "<Plug>NetrwBrowseX",
                ':call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : "<cfile>")),netrw#CheckIfRemote())<CR>',
                opts
            )
            map("n", "gx", "<Plug>NetrwBrowseX", {})
            map("v", "<Plug>NetrwBrowseXVis", ":<c-u>call netrw#BrowseXVis()<CR>", opts)
            map("v", "gx", "<Plug>NetrwBrowseXVis", {})

            vim.cmd("command! -nargs=? -complete=dir Explore Dirvish <args>")
            vim.cmd("command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>")
            vim.cmd("command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>")
        end,
        config = function()
            vim.cmd([[
                      augroup my_dirvish_events
                      autocmd!
                      " Map t to "open in new tab".
                      autocmd FileType dirvish  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>|xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
                      " Enable :Gstatus and friends.
                      " autocmd FileType dirvish call fugitive#detect(@%)

                      " Map `gh` to hide dot-prefixed files.
                      " To "toggle" this, just press `R` to reload.
                      autocmd FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>
                      " autocmd FileType dirvish nnoremap <buffer> <space>e :e %/
                      autocmd FileType dirvish nnoremap <buffer> <space>ck :e %/kustomization.yaml
                      autocmd FileType dirvish nnoremap <buffer> <space>cR :e %/README.md
                      autocmd FileType dirvish nnoremap <buffer> % :e %/
                      augroup END
                      ]])
        end,
    },
    -- {
    --     -- https://github.com/chipsenkbeil/distant.nvim
    --     "chipsenkbeil/distant.nvim",
    --     lazy = true,
    --     build = { "DistantInstall" },
    --     cmd = { "DistantLaunch", "DistantRun" },
    --     config = function()
    --         require("distant").setup({
    --             -- Applies Chip's personal settings to every machine you connect to
    --             --
    --             -- 1. Ensures that distant servers terminate with no connections
    --             -- 2. Provides navigation bindings for remote directories
    --             -- 3. Provides keybinding to jump into a remote file's parent directory
    --             ["*"] = vim.tbl_extend(
    --                 "force",
    --                 require("distant.settings").chip_default(),
    --                 { mode = "ssh" } -- use SSH mode by default
    --             ),
    --         })
    --     end,
    -- },
}
