-- More ideas
-- https://github.com/siduck76/NvChad/tree/main/lua

map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return require("packer").startup(function(use)
    -- Packer can manage itself
    use({
        -- https://github.com/wbthomason/packer.nvim
        "wbthomason/packer.nvim",
    })
    use({
        -- https://github.com/lewis6991/impatient.nvim
        "lewis6991/impatient.nvim",
        config = function()
            -- To profile the cache run :LuaCacheProfile
            -- require("impatient").enable_profile()
            require("impatient")
        end,
    })

    ----------------------
    -- git
    ----------------------
    use({
        -- https://github.com/tpope/vim-dispatch
        "tpope/vim-dispatch",
        opt = true,
        cmd = { "Dispatch", "Make", "Focus", "Start" },
    })
    use({
        -- Give this a try:
        -- use {"TimUntersberger/neogit"}
        -- https://github.com/tpope/vim-fugitive
        "tpope/vim-fugitive",
        opt = true,
        cmd = {
            "Git",
            "GBrowse",
            "Gdiffsplit",
            "Gstatus",
            "Gwrite",
            "0Gclog",
            "Gclog",
            "Gmove",
            "Gedit",
            "Gremove",
        },
        ft = { "fugitive" },
        config = function()
            vim.cmd("autocmd BufReadPost fugitive://* set bufhidden=delete")
            vim.cmd([[
                function! LightLineFugitive()
                  if exists('*fugitive#Head')
                      let l:_ = fugitive#Head()
                      return strlen(l:_) > 0 ? l:_ . ' ' : ''
                  endif
                  return ''
                endfunction
            ]])
            vim.cmd([[
                let g:lightline.active.left[1] = [ "bomb", "diff", "scrollbind", "noeol", "readonly", "fugitive", "filename", "modified" ]
                let g:lightline.component_function.fugitive = "LightLineFugitive"
                call lightline#init()
            ]])
        end,
    })

    ----------------------
    -- file management
    ----------------------
    -- use({
    --     -- https://github.com/tpope/vim-vinegar
    --     "tpope/vim-vinegar",
    -- })
    use({
        -- https://github.com/kyazdani42/nvim-tree.lua
        "kyazdani42/nvim-tree.lua",
        opt = true,
        cmd = { "NvimTreeOpen", "NvimTreeToggle" },
        requires = {
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
    })
    use({
        -- https://github.com/nvim-telescope/telescope.nvim
        "nvim-telescope/telescope.nvim",
        requires = {
            -- https://github.com/nvim-lua/popup.nvim
            "nvim-lua/popup.nvim",
            -- https://github.com/nvim-lua/plenary.nvim
            "nvim-lua/plenary.nvim",
            {
                -- https://github.com/nvim-telescope/telescope-fzy-native.nvim
                "nvim-telescope/telescope-fzy-native.nvim",
                run = { "make" },
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
        -- opt = true, -- FIXME opt doesn't work for some unknown reason
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
    })
    -- use({
    --     -- https://github.com/elihunter173/dirbuf.nvim
    --     "elihunter173/dirbuf.nvim",
    --     opt = true,
    --     cmd = { "Dirbuf", "Explore", "Sexplore", "Vexplore" },
    --     keys = { { "n", "<Plug>(dirbuf_up)" } },
    --     setup = function()
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
    -- })
    use({
        -- https://github.com/justinmk/vim-dirvish
        "justinmk/vim-dirvish",
        -- requires = {
        --     -- https://github.com/bounceme/remote-viewer
        --     "bounceme/remote-viewer",
        -- },
        opt = true,
        cmd = { "Dirvish" },
        keys = { { "n", "<Plug>(dirvish_up)" } },
        setup = function()
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
                          autocmd FileType dirvish nnoremap <buffer> <space>cr :e %/README.md
                          autocmd FileType dirvish nnoremap <buffer> % :e %/
                      augroup END
                  ]])
        end,
    })
    -- use({
    --     -- https://github.com/chipsenkbeil/distant.nvim
    --     "chipsenkbeil/distant.nvim",
    --     opt = true,
    --     run = { "DistantInstall" },
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
    -- })

    ----------------------
    -- movement
    ----------------------
    -- use({
    --     -- https://github.com/ggandor/lightspeed.nvim
    --     "ggandor/lightspeed.nvim",
    --     setup = function()
    --         map("n", "<Space>/", "/", { noremap = true })
    --         map("n", "<Space>?", "?", { noremap = true })
    --         map("n", "/", "<Plug>Lightspeed_s", {})
    --         map("n", "?", "<Plug>Lightspeed_S", {})
    --         map("x", "/", "<Plug>Lightspeed_x", {})
    --         map("x", "?", "<Plug>Lightspeed_X", {})
    --     end,
    -- })
    use({
        -- https://github.com/anuvyklack/hydra.nvim
        "anuvyklack/hydra.nvim",
        config = function()
            local Hydra = require("hydra")
            -- local dap = require("dap")

            -- Hydra({
            --     name = "Debug",
            --     mode = { "n", "x" },
            --     body = "<Space>,",
            --     heads = {
            --         -- { "b", dap.toggle_breakpoint, { desc = "toggle breakpoint", silent = true } },
            --         -- { "c", dap.continue, { desc = "continue", silent = true } },
            --         -- { "i", dap.step_into, { desc = "step in", silent = true } },
            --         -- { "o", dap.step_out, { desc = "step out", silent = true } },
            --         -- { "q", dap.close, { desc = "quit hydra", exit = true } },
            --         -- { "r", dap.repl_open, { desc = "repl", silent = true } },
            --         -- { "R", dap.run_last, { desc = "run last" }, silent = true },
            --         -- { "s", dap.step_over, { desc = "step over", silent = true } },
            --         { "b", "<cmd>DapToggleBreakpoint<CR>", { desc = "toggle breakpoint", silent = true } },
            --         { "c", "<cmd>DapContinue<CR>", { desc = "continue", silent = true } },
            --         { "C", "<cmd>DapRerun<CR>", { desc = "run last" }, silent = true },
            --         { "i", "<cmd>DapStepInto<CR>", { desc = "step in", silent = true } },
            --         { "o", "<cmd>DapStepOut<CR>", { desc = "step out", silent = true } },
            --         { "q", "<cmd>DapStop<CR>", { desc = "quit hydra", exit = true } },
            --         { "r", "<cmd>DapToggleRepl<CR>", { desc = "repl", silent = true } },
            --         { "s", "<cmd>DapStepOver<CR>", { desc = "step over", silent = true } },
            --     },
            -- })
            Hydra({
                name = "Window",
                mode = "n",
                body = "<Space>w",
                heads = {
                    { "h", "<C-w>h" },
                    { "H", "<C-w>H" },
                    { "j", "<C-w>j" },
                    { "J", "<C-w>J" },
                    { "k", "<C-w>k" },
                    { "K", "<C-w>K" },
                    { "l", "<C-w>l" },
                    { "L", "<C-w>L" },
                    { "p", "<C-w>p" },
                    { "s", "<C-w>s", { desc = "hsplit" } },
                    { ",", "gT", { desc = "prev pab" } },
                    { ".", "gt", { desc = "next tab" } },
                    { "v", "<C-w>v", { desc = "vsplit" } },
                },
            })
        end,
    })
    use({
        -- https://github.com/phaazon/hop.nvim
        "phaazon/hop.nvim",
        branch = "v2", -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            -- require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
            require("hop").setup()
            -- map("n", "<Space>/", "/", { noremap = true })
            -- map("n", "<Space>?", "?", { noremap = true })
            map("n", "<C-f>", "<cmd>HopChar1<cr>", {})
            map("o", "<C-f>", "<cmd>HopChar1<cr>", {})
            -- map("n", "/", "<cmd>HopChar2AC<cr>", {})
            -- map("n", "?", "<cmd>HopChar2BC<cr>", {})
            -- map("o", "/", "<cmd>HopChar2AC<cr>", {})
            -- map("o", "?", "<cmd>HopChar2BC<cr>", {})
        end,
    })
    use({
        -- https://github.com/Houl/repmo-vim
        "Houl/repmo-vim",
        as = "repmo",
        setup = function()
            local opts = { noremap = true, expr = true }
            -- map a motion and its reverse motion:
            map("", "h", 'repmo#SelfKey("h", "l")', opts)
            unmap("s", "h")
            map("", "l", 'repmo#SelfKey("l", "h")', opts)
            unmap("s", "l")
            map("", "<C-E>", 'repmo#SelfKey("<C-E>", "<C-Y>")', opts)
            unmap("s", "<C-E>")
            map("", "<C-Y>", 'repmo#SelfKey("<C-Y>", "<C-E>")', opts)
            unmap("s", "<C-Y>")
            map("", "<C-D>", 'repmo#SelfKey("<C-D>", "<C-U>")', opts)
            unmap("s", "<C-D>")
            map("", "<C-U>", 'repmo#SelfKey("<C-U>", "<C-D>")', opts)
            unmap("s", "<C-U>")
            map("", "<C-F>", 'repmo#SelfKey("<C-F>", "<C-B>")', opts)
            unmap("s", "<C-F>")
            map("", "<C-B>", 'repmo#SelfKey("<C-B>", "<C-F>")', opts)
            unmap("s", "<C-B>")
            map("", "e", 'repmo#SelfKey("e", "ge")', opts)
            unmap("s", "e")
            map("", "ge", 'repmo#SelfKey("ge", "e")', opts)
            unmap("s", "ge")
            map("", "b", 'repmo#SelfKey("b", "w")', opts)
            unmap("s", "b")
            map("", "w", 'repmo#SelfKey("w", "b")', opts)
            unmap("s", "w")
            map("", "B", 'repmo#SelfKey("B", "W")', opts)
            unmap("s", "B")
            map("", "W", 'repmo#SelfKey("W", "B")', opts)
            unmap("s", "W")
            -- repeat the last [count]motion or the last zap-key:
            map("", ";", 'repmo#LastKey(";")', opts)
            unmap("s", ";")
            map("", ",", 'repmo#LastRevKey(",")', opts)
            unmap("s", ",")
            -- add these mappings when repeating with `;' or `,':
            map("", "f", 'repmo#ZapKey("f", 1)', opts)
            unmap("s", "f")
            map("", "F", 'repmo#ZapKey("F", 1)', opts)
            unmap("s", "F")
            map("", "t", 'repmo#ZapKey("t", 1)', opts)
            unmap("s", "t")
            map("", "T", 'repmo#ZapKey("T", 1)', opts)
            unmap("s", "T")
        end,
    })
    use({
        -- https://github.com/arp242/jumpy.vim
        "arp242/jumpy.vim",
    })
    use({
        -- https://github.com/vim-scripts/lastpos.vim
        "vim-scripts/lastpos.vim",
    })
    use({
        -- https://github.com/jceb/vim-shootingstar
        "jceb/vim-shootingstar",
    })
    use({
        -- https://github.com/mg979/vim-visual-multi
        "mg979/vim-visual-multi",
        opt = true,
        keys = {
            { "n", "<C-j>" },
            { "n", "<C-k>" },
            { "n", "<C-c>" },
            { "n", "<C-n>" },
            { "v", "<C-n>" },
        },
        setup = function()
            vim.cmd([[
            let g:VM_Mono_hl   = 'Substitute'
            let g:VM_Cursor_hl = 'IncSearch'
            ]])
            vim.g.VM_maps = {
                ["Find Under"] = "<C-n>",
                ["Find Subword Under"] = "<C-n>",
                ["Next"] = "n",
                ["Previous"] = "N",
                ["Skip"] = "q",
                ["Add Cursor Down"] = "<C-j>",
                ["Add Cursor Up"] = "<C-k>",
                ["Select l"] = "<S-Left>",
                ["Select r"] = "<S-Right>",
                ["Add Cursor at Position"] = [[\\\]],
                ["Select All"] = "<C-c>",
                ["Visual All"] = "<C-c>",
                -- ["Start Regex Search"] = "<C-/>",
                ["Exit"] = "<Esc>",
            }
            -- let g:VM_leader = {'default': '\', 'visual': '\', 'buffer': 'z'}
        end,
    })
    use({
        -- https://github.com/vim-scripts/StarRange
        "vim-scripts/StarRange",
    })
    use({
        -- https://github.com/tpope/vim-unimpaired
        "tpope/vim-unimpaired",
        opt = true,
        keys = {
            { "n", "yoc" },
            { "n", "yod" },
            { "n", "yoh" },
            { "n", "yoi" },
            { "n", "yol" },
            { "n", "yon" },
            { "n", "yor" },
            { "n", "yos" },
            { "n", "you" },
            { "n", "yow" },
            { "n", "yox" },
            { "n", "[a" },
            { "n", "]a" },
            { "n", "[A" },
            { "n", "]A" },
            { "n", "[b" },
            { "n", "]b" },
            { "n", "[B" },
            { "n", "]B" },
            { "n", "[e" },
            { "n", "]e" },
            { "n", "[f" },
            { "n", "]f" },
            { "n", "[l" },
            { "n", "]l" },
            { "n", "[L" },
            { "n", "]L" },
            { "n", "[n" },
            { "n", "]n" },
            { "n", "[q" },
            { "n", "]q" },
            { "n", "[Q" },
            { "n", "]Q" },
            { "n", "[t" },
            { "n", "]t" },
            { "n", "[T" },
            { "n", "]T" },
            { "n", "[u" },
            { "n", "]u" },
            { "n", "[x" },
            { "n", "]x" },
            { "n", "[y" },
            { "n", "]y" },
            { "n", "[Y" },
            { "n", "]Y" },
            { "n", "[<Space>" },
            { "n", "]<Space>" },
        },
        config = function()
            -- disable legacy mappings
            map("n", "co", "<Nop>", {})
            map("n", "=o", "<Nop>", {})
        end,
    })
    use({
        -- https://github.com/tpope/vim-rsi
        "tpope/vim-rsi",
        setup = function()
            vim.g.rsi_no_meta = 1
        end,
    })
    use({
        -- https://github.com/vim-scripts/diffwindow_movement
        "vim-scripts/diffwindow_movement",
        opt = true,
        requires = {
            -- https://github.com/inkarkat/vim-CountJump
            "inkarkat/vim-CountJump",
            -- https://github.com/inkarkat/vim-ingo-library
            "inkarkat/vim-ingo-library",
        },
        config = function()
            local opts = { noremap = true }
            map(
                "n",
                "]C",
                ':<C-u>call CountJump#JumpFunc("n", "CountJump#Region#JumpToNextRegion", function("diffwindow_movement#IsDiffLine"), 1, 1, 1, 0)<CR>',
                opts
            )
            map(
                "n",
                "[C",
                ':<C-u>call CountJump#JumpFunc("n", "CountJump#Region#JumpToNextRegion", function("diffwindow_movement#IsDiffLine"), 1, -1, 0, 0)<CR>',
                opts
            )
        end,
    })
    use({
        -- https://github.com/abecodes/tabout.nvim
        "abecodes/tabout.nvim",
        -- opt=true,
        -- keys = {{'i', '<C-j>'}},
        config = function()
            require("tabout").setup({
                tabkey = "", -- key to trigger tabout, set to an empty string to disable
                backwards_tabkey = "", -- key to trigger backwards tabout, set to an empty string to disable
                act_as_tab = false, -- shift content if tab out is not possible
                act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
                enable_backwards = true, -- well ...
                completion = false, -- if the tabkey is used in a completion pum
                tabouts = {
                    { open = "'", close = "'" },
                    { open = '"', close = '"' },
                    { open = "`", close = "`" },
                    { open = "(", close = ")" },
                    { open = "[", close = "]" },
                    { open = "{", close = "}" },
                    { open = "<", close = ">" },
                },
                ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
                exclude = {}, -- tabout will ignore these filetypes
            })
        end,
        wants = { "nvim-treesitter/nvim-treesitter" }, -- or require if not used so far
    })
    -- use({
    --     -- TODO: not yet fully configured
    --     -- https://github.com/ray-x/navigator.lua
    --     "ray-x/navigator.lua",
    --     -- opt = true,
    --     requires = {
    --         {
    --             -- https://github.com/ray-x/guihua.lua
    --             "ray-x/guihua.lua",
    --             run = "cd lua/fzy && make",
    --         },
    --         -- https://github.com/nvim-treesitter/nvim-treesitter-refactor
    --         "nvim-treesitter/nvim-treesitter-refactor",
    --     },
    --     -- keys = { { "n", "gp" } },
    --     config = function()
    --         require("navigator").setup()
    --     end,
    -- })

    ----------------------
    -- session management
    ----------------------
    use({
        -- https://github.com/tpope/vim-obsession
        "tpope/vim-obsession",
        -- opt = false,
        -- cmd = {"Obsession"}
    })
    use({
        -- https://github.com/jceb/vim-cd
        "jceb/vim-cd",
    })
    -- use({
    --     -- https://github.com/folke/todo-comments.nvim
    --     "folke/todo-comments.nvim",
    --    requires = {
    --        -- https://github.com/nvim-lua/plenary.nvim
    --        "nvim-lua/plenary.nvim",
    --        -- https://github.com/nvim-lua/popup.nvim
    --        "nvim-lua/popup.nvim" },
    --     opt = true,
    --     cmd = {
    --         "TodoTelescope",
    --         "TodoQuickFix",
    --         "TodoLocList",
    --         "TodoTrouble",
    --     },
    --     config = function()
    --         require("todo-comments").setup({})
    --     end,
    -- })
    use({
        -- https://github.com/jceb/vim-editqf
        "jceb/vim-editqf",
        cmd = { "QFAddNote" },
    })

    ----------------------
    -- buffer management
    ----------------------
    use({
        -- https://github.com/mhinz/vim-sayonara
        "mhinz/vim-sayonara",
        opt = true,
        cmd = { "Sayonara" },
    })
    -- use({
    --     -- replacement for saynara?
    --     -- https://github.com/famiu/bufdelete.nvim
    --     "famiu/bufdelete.nvim",
    --     opt = true,
    --     cmd = { "Bdelete", "Bwipeout" },
    -- })
    use({
        -- https://github.com/troydm/easybuffer.vim
        "troydm/easybuffer.vim",
        opt = true,
        cmd = { "EasyBufferBotRight" },
        config = function()
            vim.g.easybuffer_chars = {
                "a",
                "s",
                "f",
                "i",
                "w",
                "e",
                "z",
                "c",
                "v",
            }
        end,
    })
    -- use({
    --     -- https://github.com/matbme/JABS.nvim
    --     "matbme/JABS.nvim",
    --     opt = true,
    --     cmd = { "JABSOpen" },
    --     config = function()
    --         require("jabs").setup({
    --             width = 100,
    --             height = 20,
    --         })
    --     end,
    -- })
    -- use({
    --     -- https://github.com/tpope/vim-projectionist
    --     "tpope/vim-projectionist",
    --     opt = true,
    -- })

    ----------------------
    -- completion
    ----------------------
    -- use({
    --     -- https://github.com/gelguy/wilder.nvim
    --     "gelguy/wilder.nvim",
    --     config = function()
    --         vim.call("wilder#enable_cmdline_enter")
    --         vim.opt.wildcharm = 9
    --         map(
    --             "c",
    --             "<Tab>",
    --             "wilder#in_context() ? wilder#next() : \"<Tab>\"",
    --             { expr = true }
    --         )
    --         map(
    --             "c",
    --             "<S-Tab>",
    --             "wilder#in_context() ? wilder#previous() : \"<S-Tab>\"",
    --             { expr = true }
    --         )
    --         -- only / and ? are enabled by default
    --         vim.call("wilder#set_option", "modes", { "/", "?", ":" })
    --     end,
    -- })
    -- use({
    --     -- https://github.com/neoclide/coc.nvim
    --     "neoclide/coc.nvim",
    --     run = "npm run build",
    --     cmd = "CocUpdate",
    -- })
    use({
        -- https://github.com/rcarriga/nvim-dap-ui
        "rcarriga/nvim-dap-ui",
        requires = {
            -- https://github.com/mfussenegger/nvim-dap
            "mfussenegger/nvim-dap",
            -- https://github.com/leoluz/nvim-dap-go
            "leoluz/nvim-dap-go",
        },
        config = function()
            -- Adapter installation: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
            -- Adapters are the basis of the debugging experience - it connects
            -- to the debugger
            local dap = require("dap")
            local dapui = require("dapui")
            require("dap-go").setup()
            dap.adapters.rustgdb = {
                type = "executable",
                command = vim.fn.resolve(vim.fn.exepath("rust-gdb")), -- adjust as needed, must be absolute path
                name = "rustgdb",
            }
            dap.adapters.lldb = {
                type = "executable",
                command = vim.fn.resolve(vim.fn.exepath("lldb-vscode")), -- adjust as needed, must be absolute path
                name = "lldb",
            }
            -- dap.adapters.rust = { dap.adapters.rustgdb, dap.adapters.lldb } -- convenience functions for sepecifying custom launch.json configurations
            dap.adapters.rust = dap.adapters.lldb -- convenience functions for sepecifying custom launch.json configurations
            dap.adapters.c = dap.adapters.lldb -- convenience functions for sepecifying custom launch.json configurations
            dap.adapters.cpp = dap.adapters.lldb -- convenience functions for sepecifying custom launch.json configurations
            -- Configurations are user facing, they define the parameters that
            -- are passed to the adapters
            -- For special purposes custom debug configurations can be loaded
            dap.configurations.cpp = {
                {
                    name = "Launch",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
                    end,
                    args = function()
                        local input = vim.trim(vim.fn.input("Arguments (leave empty for no arguments): ", "", "file"))
                        if input == "" then
                            return {}
                        else
                            return vim.split(input, " ")
                        end
                    end,
                    -- args = {},
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
            dap.configurations.c = dap.configurations.cpp
            dap.configurations.rust = dap.configurations.cpp

            -- Installation instructions: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript-firefox
            dap.adapters.firefox = {
                type = "executable",
                command = "node",
                args = { os.getenv("HOME") .. "/Documents/Software/vscode-firefox-debug/dist/adapter.bundle.js" },
            }

            dap.configurations.typescript = {
                name = "Debug with Firefox",
                type = "firefox",
                request = "launch",
                reAttach = true,
                url = "http://localhost:3000",
                webRoot = "${workspaceFolder}",
                firefoxExecutable = os.getenv("HOME") .. "/.local/firefox/firefox",
            }
            dapui.setup()
            -- automatically open the UI upon DAP events
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
            vim.api.nvim_create_user_command("DapuiOpen", 'lua require("dapui").open()', {})
            vim.api.nvim_create_user_command("DapuiClose", 'lua require("dapui").close()', {})
            vim.api.nvim_create_user_command("DapuiToggle", 'lua require("dapui").toggle()', {})
            vim.api.nvim_create_user_command("DapuiEval", 'lua require("dapui").eval()', {})
        end,
    })
    use({
        -- https://github.com/alexaandru/nvim-lspupdate
        "alexaandru/nvim-lspupdate",
        opt = true,
        cmd = { "LspUpdate" },
    })
    use({
        -- https://github.com/neovim/nvim-lspconfig
        "neovim/nvim-lspconfig",
        requires = {
            {
                -- https://github.com/lukas-reineke/lsp-format.nvim
                "lukas-reineke/lsp-format.nvim",
                config = function()
                    require("lsp-format").setup({})
                end,
            },
            -- https://github.com/jose-elias-alvarez/null-ls.nvim
            {
                "jose-elias-alvarez/null-ls.nvim",
                -- commit = "65a9e5cd43eaf6ca3f72cf990f29b874a74e16a0"
            },
            -- https://github.com/simrat39/rust-tools.nvim
            "simrat39/rust-tools.nvim",
        },
        -- add more language servers: https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
        run = {
            ":LspUpdate",
            "npm i -g ls_emmet",
            -- "go install github.com/mattn/efm-langserver@latest",
            -- npm -g install yaml-language-server vscode-langservers-extracted vim-language-server typescript-language-server typescript pyright prettier open-cli ls_emmet dockerfile-language-server-nodejs bash-language-server
        },
        config = function()
            local capabilities =
                require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            local custom_lsp_attach = function(_, bufnr)
                -- See `:help nvim_buf_set_keymap()` for more information
                vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true })
                vim.api.nvim_buf_set_keymap(
                    bufnr,
                    "n",
                    "gd",
                    "<cmd>lua vim.lsp.buf.definition()<CR>",
                    { noremap = true }
                )
                -- ... and other keymappings for LSP

                -- Use LSP as the handler for omnifunc.
                --    See `:help omnifunc` and `:help ins-completion` for more information.
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                -- Use LSP as the handler for formatexpr.
                --    See `:help formatexpr` for more information.
                vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

                vim.api.nvim_buf_set_keymap(
                    bufnr,
                    "n",
                    "<Space>gR",
                    "<cmd>lua vim.lsp.buf.rename()<CR>",
                    { noremap = true }
                )

                vim.api.nvim_buf_set_keymap(
                    bufnr,
                    "n",
                    "<Space>gr",
                    "<cmd>lua vim.lsp.buf.references()<CR>",
                    { noremap = true }
                )

                -- For plugins with an `on_attach` callback, call them here. For example:
                -- require('completion').on_attach()
            end

            -- See also https://sharksforarms.dev/posts/neovim-rust/
            local opts = {
                -- all the opts to send to nvim-lspconfig
                -- these override the defaults set by rust-tools.nvim
                -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
                server = {
                    -- on_attach is a callback called when the language server attachs to the buffer
                    on_attach = custom_lsp_attach,
                    settings = {
                        -- to enable rust-analyzer settings visit:
                        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                        ["rust-analyzer"] = {
                            -- enable clippy on save
                            checkOnSave = {
                                command = "clippy",
                            },
                        },
                    },
                },
                dap = {}, -- the confiugration is done as part of the dap configuration
            }
            require("rust-tools").setup(opts)

            capabilities.textDocument.completion.completionItem.snippetSupport = true

            local lspconfig = require("lspconfig")
            local null_ls = require("null-ls")

            null_ls.setup({
                on_attach = require("lsp-format").on_attach,
                sources = {
                    -- list of sources: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
                    -- null_ls.builtins.formatting.remark,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.clang_format,
                    null_ls.builtins.formatting.deno_fmt.with({}),
                    null_ls.builtins.formatting.gofumpt,
                    null_ls.builtins.formatting.just,
                    null_ls.builtins.formatting.nixfmt,
                    null_ls.builtins.formatting.prettier.with({
                        filetypes = { "html", "yaml", "css", "scss", "less", "graphql" },
                    }),
                    null_ls.builtins.formatting.rustfmt.with({
                        extra_args = function()
                            return { "--edition", "2021" }
                        end,
                    }),
                    null_ls.builtins.formatting.shfmt,
                    null_ls.builtins.formatting.stylish_haskell,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.taplo,
                    null_ls.builtins.formatting.terraform_fmt, -- maybe not needed
                    -- null_ls.builtins.formatting.yamlfmt, -- too simple, unfortunately
                    -- null_ls.builtins.formatting.shellcheck,
                },
            })

            lspconfig.bashls.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            -- lspconfig.ccls.setup({ capabilities = capabilities,on_attach = custom_lsp_attach, })
            lspconfig.clangd.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            lspconfig.cssls.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            -- lspconfig.denols.setup({
            --     capabilities = capabilities,
            --     on_attach = custom_lsp_attach,
            -- }) -- best suited for deno code as the imports don't support simple names without a map
            lspconfig.dockerls.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            lspconfig.gopls.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            -- lspconfig.graphql.setup({ capabilities = capabilities ,on_attach = custom_lsp_attach,})
            lspconfig.html.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            lspconfig.jsonls.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })

            local sumneko_root_path = "/usr/share/lua-language-server/"
            local sumneko_binary = "/usr/bin/lua-language-server"
            local runtime_path = vim.split(package.path, ";")
            table.insert(runtime_path, "lua/?.lua")
            table.insert(runtime_path, "lua/?/init.lua")
            lspconfig.sumneko_lua.setup({
                cmd = {
                    sumneko_binary,
                    "-E",
                    sumneko_root_path .. "/main.lua",
                },
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = "LuaJIT",
                            -- Setup your lua path
                            path = runtime_path,
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = { "vim" },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    },
                },
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            lspconfig.pyright.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            -- lspconfig.svelte.setup({
            --     capabilities = capabilities,
            --     on_attach = custom_lsp_attach,
            -- })
            lspconfig.terraformls.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            lspconfig.tsserver.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            lspconfig.vimls.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            -- lspconfig.vuels.setup({ capabilities = capabilities,on_attach = custom_lsp_attach, })
            lspconfig.yamlls.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            lspconfig.ls_emmet.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
        end,
    })
    use({
        -- https://github.com/hrsh7th/nvim-cmp
        "hrsh7th/nvim-cmp",
        requires = {
            -- https://github.com/f3fora/cmp-spell
            -- "f3fora/cmp-spell",
            -- https://github.com/hrsh7th/cmp-buffer
            "hrsh7th/cmp-buffer",
            -- https://github.com/petertriho/cmp-git
            -- "petertriho/cmp-git",
            -- https://github.com/hrsh7th/cmp-calc
            -- "hrsh7th/cmp-calc",
            -- https://github.com/hrsh7th/cmp-emoji
            -- "hrsh7th/cmp-emoji",
            -- https://github.com/hrsh7th/cmp-nvim-lsp
            "hrsh7th/cmp-nvim-lsp",
            -- https://github.com/hrsh7th/cmp-nvim-lua
            "hrsh7th/cmp-nvim-lua",
            -- https://github.com/hrsh7th/cmp-cmdline
            -- "hrsh7th/cmp-cmdline",
            -- https://github.com/hrsh7th/cmp-path
            "hrsh7th/cmp-path",
            -- https://github.com/lukas-reineke/cmp-rg
            -- "lukas-reineke/cmp-rg",
            -- https://github.com/octaltree/cmp-look
            "octaltree/cmp-look",
            -- https://github.com/onsails/lspkind-nvim
            "onsails/lspkind-nvim",
            -- https://github.com/petertriho/cmp-git
            -- "petertriho/cmp-git",
            -- https://github.com/saadparwaiz1/cmp_luasnip
            "saadparwaiz1/cmp_luasnip",
            -- https://github.com/tjdevries/complextras.nvim
            "tjdevries/complextras.nvim",
            -- https://github.com/uga-rosa/cmp-dictionary
            -- "uga-rosa/cmp-dictionary",
            -- https://github.com/windwp/nvim-autopairs
            -- "windwp/nvim-autopairs",
        },
        config = function()
            -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local lspkind = require("lspkind")
            local cmp = require("cmp")
            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        with_text = true,
                        maxwidth = 50,
                        menu = {
                            buffer = "[buf]",
                            nvim_lsp = "[lsp]",
                            nvim_lua = "[api]",
                            path = "[path]",
                            luasnip = "[snip]",
                        },
                    }),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    -- ["<C-S-y>"] = cmp.mapping.abort(),
                    ["<c-e>"] = function(fallback)
                        if cmp.visible() then
                            cmp.confirm({
                                behavior = cmp.ConfirmBehavior.Insert,
                                select = true,
                            })
                        else
                            fallback() -- The fallback function sends a already mapped key. In this case, it's mapping.confirm `<Tab>`.
                        end
                    end,
                    -- ["<c-y>"] = cmp.mapping.confirm({
                    --     behavior = cmp.ConfirmBehavior.Insert,
                    --     select = true,
                    -- }),
                    ["<c-space>"] = cmp.mapping.complete(),
                }),
                sources = {
                    { name = "buffer", keyword_length = 4 },
                    -- { name = "calc" },
                    -- { name = "cmp_git" },
                    -- { name = "dictionary", keyword_length = 2 },
                    -- { name = "emoji" },
                    {
                        name = "look",
                        keyword_length = 4,
                        optoins = { convert_case = true, loud = true },
                    },
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "path" },
                    -- { name = "rg" },
                    -- { name = "spell", keyword_length = 4, },
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                experimental = {
                    -- I like the new menu better! Nice work hrsh7th
                    native_menu = false,

                    -- Let's play with this for a day or two
                    ghost_text = true,
                },
                window = {},
            })

            -- cmp.event:on(
            --     "confirm_done",
            --     cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })
            -- )
            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).

            -- cmp.setup.cmdline("/", {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = {
            --         { name = "buffer" },
            --     },
            -- })

            -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            -- cmp.setup.cmdline(":", {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = cmp.config.sources({
            --         { name = "path" },
            --     }, {
            --         { name = "cmdline" },
            --     }),
            -- })
        end,
    })
    use({
        -- https://github.com/ziontee113/icon-picker.nvim
        "ziontee113/icon-picker.nvim",
        requires = {
            "stevearc/dressing.nvim",
        },
        config = function()
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "<Space>ci", "<cmd>PickIcons<cr>", opts)
            vim.keymap.set("n", "<Space>cs", "<cmd>PickAltFontAndSymbols<cr>", opts)
            vim.keymap.set("i", "<C-i>", "<cmd>PickIconsInsert<cr>", opts)
            vim.keymap.set("i", "<C-S-i>", "<cmd>PickAltFontAndSymbolsInsert<cr>", opts)
            vim.keymap.set("i", "<A-i>", "<cmd>PickIconsInsert<cr>", opts)
            vim.keymap.set("i", "<M-s>", "<cmd>PickAltFontAndSymbolsInsert<cr>", opts)

            require("icon-picker")
        end,
    })
    use({
        -- https://github.com/ziontee113/color-picker.nvim
        "ziontee113/color-picker.nvim",
        config = function()
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "<Space>cc", "<cmd>PickColor<cr>", opts)
            vim.keymap.set("i", "<C-S-c>", "<cmd>PickColorInsert<cr>", opts)

            require("color-picker").setup({
                -- ["icons"] = { "ﱢ", "" },
                -- ["icons"] = { "ﮊ", "" },
                -- ["icons"] = { "", "ﰕ" },
                -- ["icons"] = { "", "" },
                -- ["icons"] = { "", "" },
                ["icons"] = { "ﱢ", "" },
                -- ["keymap"] = { -- mapping example:
                --     ["U"] = "<Plug>Slider5Decrease",
                --     ["O"] = "<Plug>Slider5Increase",
                -- },
            })
            vim.cmd([[hi FloatBorder guibg=NONE]])
        end,
    })

    ----------------------
    -- copy / paste
    ----------------------
    use({
        -- https://github.com/svermeulen/vim-yoink
        "svermeulen/vim-yoink",
        opt = true,
        keys = {
            { "n", "p" },
            { "n", "P" },
            { "n", "<M-n>" },
            { "n", "<M-p>" },
        },
        config = function()
            vim.g.yoinkAutoFormatPaste = 0 -- this doesn't work properly, so fix it to <F11> manualy
            vim.g.yoinkMaxItems = 20

            map("n", "<M-n>", "<plug>(YoinkPostPasteSwapBack)", {})
            map("n", "<M-p>", "<plug>(YoinkPostPasteSwapForward)", {})
            map("n", "p", "<plug>(YoinkPaste_p)", {})
            map("n", "P", "<plug>(YoinkPaste_P)", {})
        end,
    })

    ----------------------
    -- text transformation
    ----------------------
    use({
        -- https://github.com/tpope/vim-abolish
        "tpope/vim-abolish",
        opt = true,
        cmd = { "Abolish", "S", "Subvert" },
        keys = { { "n", "cr" } },
    })
    use({
        -- https://github.com/numToStr/Comment.nvim
        "numToStr/Comment.nvim",
        opt = true,
        requires = {
            -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        keys = {
            { "n", "gc" },
            { "v", "gc" },
            { "n", "gb" },
            { "v", "gb" },
            { "i", "<C-c>" },
        },
        config = function()
            require("Comment").setup({
                ---@param ctx Ctx
                pre_hook = function(ctx)
                    -- Only calculate commentstring for tsx filetypes
                    if
                        vim.bo.filetype == "typescriptreact"
                        or vim.bo.filetype == "tyescriptjsx"
                        or vim.bo.filetype == "javascriptreact"
                        or vim.bo.filetype == "javascriptjsx"
                    then
                        local U = require("Comment.utils")

                        -- Detemine whether to use linewise or blockwise commentstring
                        local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

                        -- Determine the location where to calculate commentstring from
                        local location = nil
                        if ctx.ctype == U.ctype.block then
                            location = require("ts_context_commentstring.utils").get_cursor_location()
                        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                            location = require("ts_context_commentstring.utils").get_visual_start_location()
                        end

                        return require("ts_context_commentstring.internal").calculate_commentstring({
                            key = type,
                            location = location,
                        })
                    end
                end,
            })
            vim.cmd([[
                      function! InsertCommentstring()
                          let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
                          let col = col('.')
                          let line = line('.')
                          let g:ics_pos = [line, col + strlen(l)]
                          return l.r
                      endfunction
                  ]])
            vim.cmd([[
                      function! ICSPositionCursor()
                          call cursor(g:ics_pos[0], g:ics_pos[1])
                          unlet g:ics_pos
                      endfunction
                  ]])

            map("i", "<C-c>", "<C-r>=InsertCommentstring()<CR><C-o>:call ICSPositionCursor()<CR>", { noremap = true })
        end,
    })
    -- use({
    --     -- https://github.com/tpope/vim-commentary
    --     "tpope/vim-commentary",
    --     opt = true,
    --     keys = {
    --         { "n", "gc" },
    --         { "v", "gc" },
    --         { "n", "gcc" },
    --         { "i", "<C-c>" },
    --     },
    --     config = function()
    --         vim.cmd([[
    --                   function! InsertCommentstring()
    --                       let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
    --                       let col = col('.')
    --                       let line = line('.')
    --                       let g:ics_pos = [line, col + strlen(l)]
    --                       return l.r
    --                   endfunction
    --               ]])
    --         vim.cmd([[
    --                   function! ICSPositionCursor()
    --                       call cursor(g:ics_pos[0], g:ics_pos[1])
    --                       unlet g:ics_pos
    --                   endfunction
    --               ]])

    --         map(
    --             "i",
    --             "<C-c>",
    --             "<C-r>=InsertCommentstring()<CR><C-o>:call ICSPositionCursor()<CR>",
    --             { noremap = true }
    --         )
    --     end,
    -- })
    -- use({
    --     -- https://github.com/tomtom/tcomment_vim
    --     "tomtom/tcomment_vim",
    --     as = "tcomment",
    --     opt = true,
    --     keys = { { "n", "gc" }, { "v", "gc" }, { "n", "gcc" }, { "i", "<C-c>" } },
    --     setup = function()
    --         vim.g.tcomment_maps = 0
    --         -- vim.g.tcomment_mapleader1 = ""
    --         -- vim.g.tcomment_mapleader2 = ""
    --     end,
    --     config = function()
    --         vim.cmd([[
    --                    function! InsertCommentstring()
    --                        let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
    --                        let col = col('.')
    --                        let line = line('.')
    --                        let g:ics_pos = [line, col + strlen(l)]
    --                        return l.r
    --                    endfunction
    --                    nmap <silent> gc <Plug>TComment_gc
    --                    xmap <silent> gc <Plug>TComment_gcb
    --                ]])
    --         vim.cmd([[
    --                    function! ICSPositionCursor()
    --                        call cursor(g:ics_pos[0], g:ics_pos[1])
    --                        unlet g:ics_pos
    --                    endfunction
    --                ]])
    --
    --         map(
    --             "i",
    --             "<C-c>",
    --             "<C-r>=InsertCommentstring()<CR><C-o>:call ICSPositionCursor()<CR>",
    --             { noremap = true }
    --         )
    --     end,
    -- })
    use({
        -- https://github.com/windwp/nvim-autopairs
        "windwp/nvim-autopairs",
        keys = {
            { "i", "{" },
            { "i", "[" },
            { "i", "(" },
            { "i", "<" },
            { "i", "'" },
            { "i", '"' },
        },
        config = function()
            require("nvim-autopairs").setup({})
        end,
    })
    use({
        -- https://github.com/svermeulen/vim-subversive
        "svermeulen/vim-subversive",
        opt = true,
        keys = {
            { "n", "gr" },
            { "n", "gR" },
            { "n", "grr" },
            { "n", "grs" },
            { "x", "grs" },
            { "n", "grss" },
        },
        config = function()
            map("n", "gR", "<plug>(SubversiveSubstituteToEndOfLine)", {})
            map("n", "gr", "<plug>(SubversiveSubstitute)", {})
            map("n", "grr", "<plug>(SubversiveSubstituteLine)", {})
            map("n", "grs", "<plug>(SubversiveSubstituteRange)", {})
            map("x", "grs", "<plug>(SubversiveSubstituteRange)", {})
            map("n", "grss", "<plug>(SubversiveSubstituteWordRange)", {})
        end,
    })
    use({
        -- https://github.com/junegunn/vim-easy-align
        "junegunn/vim-easy-align",
        opt = true,
        keys = { { "n", "<Plug>(EasyAlign)" }, { "x", "<Plug>(EasyAlign)" } },
        config = function()
            map("x", "g=", "<Plug>(EasyAlign)", {})
            map("n", "g=", "<Plug>(EasyAlign)", {})
            map("n", "g/", "g=ip*|", {})
        end,
    })
    use({
        -- https://github.com/tpope/vim-surround
        "tpope/vim-surround",
        opt = true,
        keys = {
            { "n", "ys" },
            { "n", "yss" },
            { "n", "ds" },
            { "n", "cs" },
            { "v", "S" },
        },
        config = function()
            vim.g.surround_no_insert_mappings = 1
        end,
    })
    use({
        -- https://github.com/tpope/vim-repeat
        "tpope/vim-repeat",
    })
    use({
        -- https://github.com/jceb/vim-textobj-uri
        "jceb/vim-textobj-uri",
        requires = {
            -- https://github.com/kana/vim-textobj-user
            "kana/vim-textobj-user",
        },
        -- opt = false,
        -- keys = { { "n", "go" } },
        config = function()
            vim.call(
                "textobj#uri#add_pattern",
                "",
                "[bB]ug:\\? #\\?\\([0-9]\\+\\)",
                ":silent !open-cli 'http://forge.univention.org/bugzilla/show_bug.cgi?id=%s' &"
            )
            vim.call(
                "textobj#uri#add_pattern",
                "",
                "[tT]icket:\\? #\\?\\([0-9]\\+\\)",
                ":silent !open-cli 'https://gorm.knut.univention.de/otrs/index.pl?Action=AgentTicketZoom&TicketNumber=%s' &"
            )
            vim.call(
                "textobj#uri#add_pattern",
                "",
                "[iI]ssue:\\? #\\?\\([0-9]\\+\\)",
                ":silent !open-cli 'https://univention.plan.io/issues/%s' &"
            )
            vim.call(
                "textobj#uri#add_pattern",
                "",
                "[tT][gG]-\\([0-9]\\+\\)",
                ":!open-cli 'https://tree.taiga.io/project/jceb-identinet-development/us/%s' &"
            )
        end,
    })
    use({
        -- https://github.com/vim-scripts/VisIncr
        "vim-scripts/VisIncr",
        opt = true,
        cmd = { "I", "II" },
    })
    use({
        -- https://github.com/mjbrownie/swapit
        "mjbrownie/swapit",
        requires = {
            {
                -- https://github.com/tpope/vim-speeddating
                "tpope/vim-speeddating",
                as = "speeddating",
                setup = function()
                    local opts = { noremap = true, silent = true }
                    vim.g.speeddating_no_mappings = 1
                    map("n", "<Plug>SpeedDatingFallbackUp", "<C-a>", opts)
                    map("n", "<Plug>SpeedDatingFallbackDown", "<C-x>", opts)
                end,
            },
        },
        opt = true,
        keys = {
            { "n", "<Plug>SwapItFallbackIncrement" },
            { "n", "<Plug>SwapItFallbackDecrement" },
            { "n", "<C-a>" },
            { "n", "<C-x>" },
            { "n", "<C-t>" },
        },
        fn = { "SwapWord" },
        config = function()
            local opts = { silent = true }
            map(
                "n",
                "<Plug>SwapItFallbackIncrement",
                ":<C-u>let sc=v:count1<Bar>call speeddating#increment(sc)<Bar>unlet sc<CR>",
                opts
            )
            map(
                "n",
                "<Plug>SwapItFallbackDecrement",
                ":<C-u>let sc=v:count1<Bar>call speeddating#increment(-sc)<Bar>unlet sc<CR>",
                opts
            )
            map(
                "n",
                "<C-a>",
                ':<C-u>let swap_count = v:count<Bar>call SwapWord(expand("<cword>"), swap_count, "forward", "no")<Bar>silent! call repeat#set("\\<Plug>SwapIncrement", swap_count)<Bar>unlet swap_count<CR>',
                opts
            )
            map(
                "n",
                "<C-x>",
                ':<C-u>let swap_count = v:count<Bar>call SwapWord(expand("<cword>"), swap_count, "backward","no")<Bar>silent! call repeat#set("\\<Plug>SwapDecrement", swap_count)<Bar>unlet swap_count<CR>',
                opts
            )
        end,
    })
    -- use({
    --     -- https://github.com/monaqa/dial.nvim
    --     "monaqa/dial.nvim",
    --     -- maybe a pluging to replace swapit with
    -- })
    -- use({
    --     -- https://github.com/Ron89/thesaurus_query.vim
    --     "Ron89/thesaurus_query.vim",
    --     opt = true,
    --     ft = {
    --         "mail",
    --         "help",
    --         "debchangelog",
    --         "tex",
    --         "plaintex",
    --         "txt",
    --         "asciidoc",
    --         "markdown",
    --         "org",
    --     },
    --     setup = function()
    --         vim.g.tq_map_keys = 1
    --         vim.g.tq_use_vim_autocomplete = 0
    --         vim.g.tq_language = { "en", "de" }
    --     end,
    -- })
    use({
        -- https://github.com/L3MON4D3/LuaSnip
        "L3MON4D3/LuaSnip",
        requires = {
            -- https://github.com/rafamadriz/friendly-snippets
            "rafamadriz/friendly-snippets",
        },
        config = function()
            -- See https://github.com/L3MON4D3/LuaSnip/wiki/Misc#choicenode-popup
            local current_nsid = vim.api.nvim_create_namespace("LuaSnipChoiceListSelections")
            local current_win = nil

            local function window_for_choiceNode(choiceNode)
                local buf = vim.api.nvim_create_buf(false, true)
                local buf_text = {}
                local row_selection = 0
                local row_offset = 0
                local text
                for _, node in ipairs(choiceNode.choices) do
                    text = node:get_docstring()
                    -- find one that is currently showing
                    if node == choiceNode.active_choice then
                        -- current line is starter from buffer list which is length usually
                        row_selection = #buf_text
                        -- finding how many lines total within a choice selection
                        row_offset = #text
                    end
                    vim.list_extend(buf_text, text)
                end

                vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
                local w, h = vim.lsp.util._make_floating_popup_size(buf_text)

                -- adding highlight so we can see which one is been selected.
                local extmark = vim.api.nvim_buf_set_extmark(buf, current_nsid, row_selection, 0, {
                    hl_group = "incsearch",
                    end_line = row_selection + row_offset,
                })

                -- shows window at a beginning of choiceNode.
                local win = vim.api.nvim_open_win(buf, false, {
                    relative = "win",
                    width = w,
                    height = h,
                    bufpos = choiceNode.mark:pos_begin_end(),
                    style = "minimal",
                    border = "rounded",
                })

                -- return with 3 main important so we can use them again
                return { win_id = win, extmark = extmark, buf = buf }
            end

            function choice_popup(choiceNode)
                -- build stack for nested choiceNodes.
                if current_win then
                    vim.api.nvim_win_close(current_win.win_id, true)
                    vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
                end
                local create_win = window_for_choiceNode(choiceNode)
                current_win = {
                    win_id = create_win.win_id,
                    prev = current_win,
                    node = choiceNode,
                    extmark = create_win.extmark,
                    buf = create_win.buf,
                }
            end

            function update_choice_popup(choiceNode)
                vim.api.nvim_win_close(current_win.win_id, true)
                vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
                local create_win = window_for_choiceNode(choiceNode)
                current_win.win_id = create_win.win_id
                current_win.extmark = create_win.extmark
                current_win.buf = create_win.buf
            end

            function choice_popup_close()
                vim.api.nvim_win_close(current_win.win_id, true)
                vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
                -- now we are checking if we still have previous choice we were in after exit nested choice
                current_win = current_win.prev
                if current_win then
                    -- reopen window further down in the stack.
                    local create_win = window_for_choiceNode(current_win.node)
                    current_win.win_id = create_win.win_id
                    current_win.extmark = create_win.extmark
                    current_win.buf = create_win.buf
                end
            end

            vim.cmd([[
                augroup choice_popup
                au!
                au User LuasnipChoiceNodeEnter lua choice_popup(require("luasnip").session.event_node)
                au User LuasnipChoiceNodeLeave lua choice_popup_close()
                au User LuasnipChangeChoice lua update_choice_popup(require("luasnip").session.event_node)
                augroup END
                ]])
            -- See https://github.com/L3MON4D3/LuaSnip/wiki/Nice-Configs
            local types = require("luasnip.util.types")
            local util = require("luasnip.util.util")
            require("luasnip").config.setup({
                ext_opts = {
                    [types.choiceNode] = {
                        active = {
                            virt_text = { { "●", "Title" } },
                        },
                    },
                    [types.insertNode] = {
                        active = {
                            virt_text = { { "●", "ErrorMsg" } },
                        },
                    },
                },
                parser_nested_assembler = function(_, snippet)
                    local select = function(snip, no_move)
                        snip.parent:enter_node(snip.indx)
                        -- upon deletion, extmarks of inner nodes should shift to end of
                        -- placeholder-text.
                        for _, node in ipairs(snip.nodes) do
                            node:set_mark_rgrav(true, true)
                        end

                        -- SELECT all text inside the snippet.
                        if not no_move then
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                            local pos_begin, pos_end = snip.mark:pos_begin_end()
                            util.normal_move_on(pos_begin)
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, false, true), "n", true)
                            util.normal_move_before(pos_end)
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes("o<C-G>", true, false, true),
                                "n",
                                true
                            )
                        end
                    end
                    function snippet:jump_into(dir, no_move)
                        if self.active then
                            -- inside snippet, but not selected.
                            if dir == 1 then
                                self:input_leave()
                                return self.next:jump_into(dir, no_move)
                            else
                                select(self, no_move)
                                return self
                            end
                        else
                            -- jumping in from outside snippet.
                            self:input_enter()
                            if dir == 1 then
                                select(self, no_move)
                                return self
                            else
                                return self.inner_last:jump_into(dir, no_move)
                            end
                        end
                    end

                    -- this is called only if the snippet is currently selected.
                    function snippet:jump_from(dir, no_move)
                        if dir == 1 then
                            return self.inner_first:jump_into(dir, no_move)
                        else
                            self:input_leave()
                            return self.prev:jump_into(dir, no_move)
                        end
                    end

                    return snippet
                end,
            })

            local t = function(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
            end
            local ls = require("luasnip")

            _G.jump_extend = function()
                if ls.expand_or_jumpable() then
                    return t("<cmd>lua require'luasnip'.expand_or_jump()<Cr>")
                else
                    return t("<Plug>(Tabout)")
                end
            end
            _G.s_jump_extend = function()
                if ls.jumpable() then
                    return t("<cmd>lua require'luasnip'.jump(-1)<Cr>")
                else
                    return t("<Plug>(TaboutBack)")
                end
            end

            vim.api.nvim_set_keymap("i", "<C-z>", "<Plug>luasnip-prev-choice", {})
            vim.api.nvim_set_keymap("s", "<C-z>", "<Plug>luasnip-prev-choice", {})
            vim.api.nvim_set_keymap("i", "<C-s>", "<Plug>luasnip-next-choice", {})
            vim.api.nvim_set_keymap("s", "<C-s>", "<Plug>luasnip-next-choice", {})
            vim.api.nvim_set_keymap("i", "<C-j>", "v:lua.jump_extend()", { expr = true })
            vim.api.nvim_set_keymap("s", "<C-j>", "v:lua.jump_extend()", { expr = true })
            vim.api.nvim_set_keymap("i", "<C-k>", "v:lua.s_jump_extend()", { expr = true })
            vim.api.nvim_set_keymap("s", "<C-k>", "v:lua.s_jump_extend()", { expr = true })

            local s = ls.snippet
            local sn = ls.snippet_node
            local t = ls.text_node
            local i = ls.insert_node
            local f = ls.function_node
            local c = ls.choice_node
            local d = ls.dynamic_node
            -- Create snippets here

            -- ls.snippets = {
            --     all = {s("trigger", t("Wow! Text!"))}
            -- }

            -- Snippet definitions https://code.visualstudio.com/docs/editor/userdefinedsnippets
            require("luasnip.loaders.from_vscode").lazy_load({})
        end,
    })
    use({
        -- https://github.com/dpelle/vim-LanguageTool
        "dpelle/vim-LanguageTool",
        opt = true,
        cmd = { "LanguageToolCheck" },
        run = { "~/.config/nvim/download_LanguageTool.sh" },
        config = function()
            vim.cmd([[
            let g:languagetool_jar=$HOME . '/.config/nvim/packer/opt/vim-LanguageTool/LanguageTool/languagetool-commandline.jar'
            ]])
        end,
    })
    -- use({
    --     -- https://github.com/ThePrimeagen/refactoring.nvim
    --     "ThePrimeagen/refactoring.nvim",
    --     opt = true,
    --    requires = {
    --        -- https://github.com/nvim-lua/popup.nvim
    --        "nvim-lua/popup.nvim",
    --        -- https://github.com/nvim-lua/plenary.nvim
    --        "nvim-lua/plenary.nvim",
    --        -- https://github.com/nvim-treesitter/nvim-treesitter
    --        "nvim-treesitter/nvim-treesitter",
    --     },
    -- })

    ----------------------
    -- settings
    ----------------------
    use({
        -- https://github.com/editorconfig/editorconfig-vim
        "editorconfig/editorconfig-vim",
        config = function()
            vim.g.EditorConfig_exclude_patterns = {
                "fugitive://.*",
                "scp://.*",
            }
        end,
    })

    ----------------------
    -- visuals
    ----------------------
    use({
        -- https://github.com/jceb/blinds.nvim
        "jceb/blinds.nvim",
        config = function()
            vim.g.blinds_guibg = "#cdcdcd"
        end,
    })
    use({
        -- https://github.com/xiyaowong/nvim-cursorword
        "xiyaowong/nvim-cursorword",
        setup = function()
            vim.cmd([[
         hi link CursorWord DiffAdd
         augroup MyCursorWord
             autocmd!
             autocmd VimEnter,Colorscheme * hi link CursorWord DiffAdd
         augroup END
         ]])
        end,
    })

    use({
        -- https://github.com/rktjmp/highlight-current-n.nvim
        "rktjmp/highlight-current-n.nvim",
        opt = true,
        keys = { { "n", "n" }, { "n", "N" } },
        config = function()
            vim.cmd([[
        nmap n <Plug>(highlight-current-n-n)
        nmap N <Plug>(highlight-current-n-N)
        ]])
        end,
    })
    -- use({
    --     -- https://github.com/lukas-reineke/indent-blankline.nvim
    --     "lukas-reineke/indent-blankline.nvim",
    -- })
    use({
        -- https://github.com/vasconcelloslf/vim-interestingwords
        "vasconcelloslf/vim-interestingwords",
        opt = true,
        keys = { { "n", "<Space>i" }, { "v", "<Space>i" } },
        setup = function()
            map("n", "<Space>i", '<cmd>call InterestingWords("n")<CR>', {})
            map("v", "<Space>i", '<cmd>call InterestingWords("n")<CR>', {})
            vim.cmd("command! InterestingWordsClear :call UncolorAllWords()")
        end,
    })
    use({
        -- https://github.com/jceb/Lite-Tab-Page
        "jceb/Lite-Tab-Page",
    })
    use({
        -- https://github.com/norcalli/nvim-colorizer.lua
        "norcalli/nvim-colorizer.lua",
        opt = true,
        cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
        config = function()
            require("colorizer").setup(nil, { css = true })
        end,
    })
    use({
        -- https://github.com/andymass/vim-matchup
        "andymass/vim-matchup",
        event = "VimEnter",
    })
    use({
        -- https://github.com/nvim-treesitter/nvim-treesitter
        "nvim-treesitter/nvim-treesitter",
        run = { ":TSInstall all", ":TSUpdate" },
        requires = {
            -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
            "JoosepAlviste/nvim-ts-context-commentstring",
            -- https://github.com/nvim-treesitter/nvim-treesitter-context
            "nvim-treesitter/nvim-treesitter-context",
        },
        setup = function() end,
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
                indent = {
                    enable = false,
                },
                context_commentstring = {
                    enable = true,
                },
            })
            -- Enable support for rest.nvim https://github.com/NTBBloodbath/rest.nvim
            local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
            parser_configs.http = {
                install_info = {
                    url = "https://github.com/NTBBloodbath/tree-sitter-http",
                    files = { "src/parser.c" },
                    branch = "main",
                },
            }
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        end,
    })
    use({
        -- https://github.com/itchyny/lightline.vim
        "itchyny/lightline.vim",
        -- opt = true,
        as = "lightline",
        setup = function()
            vim.cmd([[
                function! LightLineFilename(n)
                  let buflist = tabpagebuflist(a:n)
                  let winnr = tabpagewinnr(a:n)
                  let _ = expand('#'.buflist[winnr - 1].':p')
                  let stripped_ = substitute(_, '^'.fnamemodify(getcwd(tabpagewinnr(a:n), a:n), ':h').'/', '', '')
                  return _ !=# '' ? (stripped_ !=# '' ? stripped_ : _) :  '[No Name]'
                endfunction
            ]])
            vim.g.lightline = {
                colorscheme = "PaperColor_light",
                component = {
                    bomb = '%{&bomb?"💣":""}',
                    diff = '%{&diff?"◑":""}',
                    lineinfo = " %3l:%-2v",
                    modified = '%{&modified?"±":""}',
                    noeol = '%{&endofline?"":"!↵"}',
                    readonly = '%{&readonly?"":""}',
                    scrollbind = '%{&scrollbind?"∞":""}',
                },
                component_visible_condition = {
                    bomb = "&bomb==1",
                    diff = "&diff==1",
                    modified = "&modified==1",
                    noeol = "&endofline==0",
                    scrollbind = "&scrollbind==1",
                },
                -- FIXME somehow lightline doesn't accept an empty list
                -- here
                component_function = {
                    test = "fake",
                },
                tab_component_function = {
                    tabfilename = "LightLineFilename",
                },
                separator = { left = "", right = "" },
                subseparator = { left = "", right = "" },
                tab = {
                    active = { "tabnum", "tabfilename", "modified" },
                    inactive = { "tabnum", "tabfilename", "modified" },
                },
                active = {
                    left = {
                        { "winnr", "mode", "paste" },
                        {
                            "bomb",
                            "diff",
                            "scrollbind",
                            "noeol",
                            "readonly",
                            "filename",
                            "modified",
                        },
                    },
                    right = {
                        { "lineinfo" },
                        { "percent" },
                        { "fileformat", "fileencoding", "filetype" },
                    },
                },
                inactive = {
                    left = {
                        {
                            "winnr",
                            "diff",
                            "scrollbind",
                            "filename",
                            "modified",
                        },
                    },
                    right = { { "lineinfo" }, { "percent" } },
                },
            }
        end,
    })
    -- use {
    --     -- https://github.com/hoob3rt/lualine.nvim
    --     "hoob3rt/lualine.nvim",
    --    requires = {
    --        -- https://github.com/kyazdani42/nvim-web-devicons
    --        "kyazdani42/nvim-web-devicons", opt = true},
    --     config = function()
    --         require('lualine').setup()
    --     end
    -- }
    use({
        -- https://github.com/NLKNguyen/papercolor-theme
        "NLKNguyen/papercolor-theme",
        as = "papercolor",
        opt = true,
        setup = function()
            vim.g.PaperColor_Theme_Options = {
                theme = {
                    default = {
                        light = {
                            transparent_background = 1,
                            override = {
                                color04 = { "#87afd7", "110" },
                                color16 = { "#87afd7", "110" },
                                statusline_active_fg = { "#444444", "238" },
                                statusline_active_bg = { "#eeeeee", "255" },
                                visual_bg = { "#005f87", "110" },
                                folded_fg = { "#005f87", "31" },
                                difftext_fg = { "#87afd7", "110" },
                                tabline_inactive_bg = { "#87afd7", "110" },
                                buftabline_inactive_bg = { "#87afd7", "110" },
                            },
                        },
                    },
                },
            }
        end,
    })
    use({
        -- https://github.com/folke/tokyonight.nvim
        "folke/tokyonight.nvim",
        as = "tokyonight",
        opt = true,
    })
    use({
        -- Alternative: to nord-vim?
        -- https://github.com/shaunsingh/nord.nvim
        "shaunsingh/nord.nvim",
        as = "nord",
        opt = true,
    })
    -- use({
    --     -- https://github.com/arcticicestudio/nord-vim
    --     "arcticicestudio/nord-vim",
    --     as = "nord",
    --     opt = true,
    -- })
    -- -- Use specific branch, dependency and run lua file after load
    -- use {
    --     -- https://github.com/glepnir/galaxyline.nvim
    --   "glepnir/galaxyline.nvim", branch = 'main', config = function() require'statusline' end,
    --  requires = {
    --      -- https://github.com/kyazdani42/nvim-web-devicons
    --      "kyazdani42/nvim-web-devicons"}
    -- }

    -- use {
    --     -- https://github.com/romgrk/barbar.nvim
    --    "romgrk/barbar.nvim", requires = {
    --        -- https://github.com/kyazdani42/nvim-web-devicons
    --        "kyazdani42/nvim-web-devicons"},
    -- config = function()
    --   -- check out https://github.com/akinsho/nvim-bufferline.lua if not satisfied
    --   -- with barbar
    --   vim.g.bufferline = {
    --     icon_pinned = '車',
    --     exclude_ft = { 'dirvish' }
    --   }
    --
    --     local opts = { noremap = true, silent = true }
    --
    --       -- Tab movement
    --       map('n', '<M-h>', 'gT', opts)
    --       map('n', '<M-S-h>', '<cmd>tabmove -<CR>', opts)
    --       map('n', '<M-l>', 'gt', opts)
    --       map('n', '<M-S-l>', '<cmd>tabmove +<CR>', opts)
    --       map('n', '<M-C-1>', '1gt', opts)
    --       map('n', '<M-C-2>', '2gt', opts)
    --       map('n', '<M-C-3>', '3gt', opts)
    --       map('n', '<M-C-4>', '4gt', opts)
    --       map('n', '<M-C-5>', '5gt', opts)
    --       map('n', '<M-C-6>', '6gt', opts)
    --       map('n', '<M-C-7>', '7gt', opts)
    --       map('n', '<M-C-8>', '8gt', opts)
    --       map('n', '<M-C-9>', '9gt', opts)
    --
    --       -- Move to previous/next
    --       map('n', '<A-,>', ':BufferPrevious<CR>', opts)
    --       map('n', '<A-.>', ':BufferNext<CR>', opts)
    --       -- Re-order to previous/next
    --       map('n', '<A-<>', ':BufferMovePrevious<CR>', opts)
    --       map('n', '<A->>', ' :BufferMoveNext<CR>', opts)
    --       -- Goto buffer in position...
    --       map('n', '<A-1>', ':BufferGoto 1<CR>', opts)
    --       map('n', '<A-2>', ':BufferGoto 2<CR>', opts)
    --       map('n', '<A-3>', ':BufferGoto 3<CR>', opts)
    --       map('n', '<A-4>', ':BufferGoto 4<CR>', opts)
    --       map('n', '<A-5>', ':BufferGoto 5<CR>', opts)
    --       map('n', '<A-6>', ':BufferGoto 6<CR>', opts)
    --       map('n', '<A-7>', ':BufferGoto 7<CR>', opts)
    --       map('n', '<A-8>', ':BufferGoto 8<CR>', opts)
    --       map('n', '<A-9>', ':BufferGoto 9<CR>', opts)
    --       map('n', '<A-0>', ':BufferLast<CR>', opts)
    --       -- Pin/unpin buffer
    --       map('n', '<A-b>', ':BufferPin<CR>', opts)
    --       -- Close buffer
    --       map('n', '<A-c>', ':BufferClose<CR>', opts)
    --       -- Wipeout buffer
    --       --                 :BufferWipeout<CR>
    --       -- Close commands
    --       --                 :BufferCloseAllButCurrent<CR>
    --       --                 :BufferCloseBuffersLeft<CR>
    --       --                 :BufferCloseBuffersRight<CR>
    --       -- Magic buffer-picking mode
    --       map('n', '<C-s>', ':BufferPick<CR>', opts)
    --   end
    -- }

    ----------------------
    -- ftplugins
    ----------------------
    -- use({
    --     -- https://github.com/nathom/filetype.nvim
    --     "nathom/filetype.nvim",
    -- })
    -- use({
    --     -- https://github.com/jceb/yaml-path
    --     "jceb/yaml-path",
    --     run = { "go install" },
    -- })
    use({
        -- https://github.com/NoahTheDuke/vim-just.git
        "NoahTheDuke/vim-just",
    })
    use({
        -- https://github.com/cuducos/yaml.nvim
        "cuducos/yaml.nvim",
        opt = true,
        ft = { "yaml" }, -- optional
        requires = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- optional
        },
    })
    use({
        -- https://github.com/google/vim-jsonnet
        "google/vim-jsonnet",
    })
    use({
        -- https://github.com/tpope/vim-apathy
        "tpope/vim-apathy",
    })
    -- use({
    --     -- https://github.com/jceb/emmet.snippets
    --     "jceb/emmet.snippets",
    --     opt = true,
    -- })
    use({
        -- https://github.com/tomlion/vim-solidity
        "tomlion/vim-solidity",
        opt = true,
        ft = { "solidity" },
    })
    -- use({
    --     -- https://github.com/posva/vim-vue
    --     "posva/vim-vue", opt = true, ft = { "vue" } })
    use({
        -- https://github.com/asciidoc/vim-asciidoc
        "asciidoc/vim-asciidoc",
        ft = { "asciidoc" },
    })
    use({
        -- https://github.com/ray-x/go.nvim
        "ray-x/go.nvim",
        requires = {
            {
                -- https://github.com/ray-x/guihua.lua
                "ray-x/guihua.lua",
                run = "cd lua/fzy && make",
            },
        },
        -- opt = true,
        -- ft = { "go" },
        run = { ":GoUpdateBinaries" },
        config = function()
            -- TODO: integrate debugging: https://github.com/ray-x/go.nvim#debug-with-dlv
            require("go").setup({})
            vim.cmd([[
              " nmap <C-]> gd
              au Filetype go
                    \  exec "command! -bang A GoAlt"
                    \ | exec "command! -bang AV GoAltV"
                    \ | exec "command! -bang AS GoAltS"
            ]])
        end,
    })
    -- use({
    --     -- https://github.com/fatih/vim-go
    --     "fatih/vim-go",
    --     opt = true,
    --     ft = { "go" },
    --     run = { ":GoUpdateBinaries" },
    --     config = function()
    --         vim.cmd([[
    --         nmap grd <Plug>(go-referrers)
    --         ]])
    --         vim.cmd([[
    --           au Filetype go
    --                 \  exec "command! -bang A call go#alternate#Switch(<bang>0, 'edit')"
    --                 \| exec "command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')"
    --                 \| exec "command! -bang AS call go#alternate#Switch(<bang>0, 'split')"
    --         ]])
    --     end,
    -- })
    use({
        -- https://github.com/dag/vim-fish
        "dag/vim-fish",
        opt = true,
        ft = { "fish" },
    })
    use({
        -- https://github.com/LhKipp/nvim-nu
        "LhKipp/nvim-nu",
        opt = true,
        ft = { "nu" },
        config = function()
            require("nu").setup({ complete_cmd_names = true })
        end,
    })
    -- use({
    --     -- https://github.com/jparise/vim-graphql
    --     "jparise/vim-graphql",
    --     opt = true,
    --     ft = {
    --         "javascript",
    --         "javascriptreact",
    --         "typescript",
    --         "typescriptreact",
    --         "vue",
    --         "php",
    --         "reason",
    --     },
    -- })
    -- use({
    --     -- https://github.com/leafOfTree/vim-svelte-plugin
    --     "leafOfTree/vim-svelte-plugin", opt = true, ft = { "svelte" } })
    use({
        -- https://github.com/towolf/vim-helm
        "towolf/vim-helm",
        ft = { "yaml" },
    })
    use({
        -- https://github.com/aklt/plantuml-syntax
        "aklt/plantuml-syntax",
        opt = true,
        ft = { "plantuml" },
    })
    use({
        -- https://github.com/tpope/vim-markdown
        "tpope/vim-markdown",
        opt = true,
        ft = { "markdown" },
    })
    use({
        -- https://github.com/hashivim/vim-terraform
        "hashivim/vim-terraform",
        opt = true,
        ft = { "terraform" },
        setup = function()
            vim.g.terraform_fmt_on_save = 1
            vim.g.terraform_fold_sections = 1
            vim.g.markdown_fenced_languages = {
                "bash=sh",
                "css",
                "html",
                "javascript",
                "json",
                "python",
                "yaml",
            }
        end,
    })
    -- use({
    --     -- https://github.com/sukima/vim-tiddlywiki
    --     "sukima/vim-tiddlywiki", opt = true, ft = { "tiddlywiki" } })
    use({
        -- https://github.com/iamcco/markdown-preview.nvim
        "iamcco/markdown-preview.nvim",
        run = "cd app && yarn install",
        opt = true,
        ft = { "markdown" },
        config = {
            vim.cmd("doau BufEnter"),
        },
    })
    -- use({
    --     -- https://github.com/mustache/vim-mustache-handlebars
    --     "mustache/vim-mustache-handlebars",
    --     opt = true,
    --     ft = { "mustache" },
    -- })

    ----------------------
    -- terminal
    ----------------------
    use({
        -- https://github.com/kassio/neoterm
        "kassio/neoterm",
        opt = true,
        fn = { "neoterm#new" },
        cmd = { "Tnew" },
        setup = function()
            vim.g.neoterm_direct_open_repl = 0
            vim.g.neoterm_open_in_all_tabs = 1
            vim.g.neoterm_autoscroll = 1
            vim.g.neoterm_term_per_tab = 1
            vim.g.neoterm_shell = "fish"
            vim.g.neoterm_autoinsert = 1
            vim.g.neoterm_automap_keys = "<F23>"
        end,
    })
    use({
        -- https://github.com/voldikss/vim-floaterm
        "voldikss/vim-floaterm",
        opt = true,
        cmd = {
            "FloatermToggle",
            "FloatermNew",
            "FloatermPrev",
            "FloatermNext",
        },
        keys = { { "n", "<M-/>" } },
        setup = function()
            vim.g.floaterm_autoclose = 1
            vim.g.floaterm_shell = "fish"
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
    })
    -- use {
    --     -- https://github.com/akinsho/nvim-toggleterm.lua
    --     "akinsho/nvim-toggleterm.lua",
    --     opt = true,
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

    ----------------------
    -- window management
    ----------------------
    -- use({
    --     -- https://github.com/rbong/vim-buffest
    --     "rbong/vim-buffest",
    -- })
    use({
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
    })
    -- use({
    --     -- https://github.com/szw/vim-maximizer
    --     "szw/vim-maximizer",
    --     opt = true,
    --     cmd = { "MaximizerToggle" },
    --     config = function()
    --         vim.g.maximizer_restore_on_winleave = 1
    --     end,
    -- })
    use({
        -- https://github.com/folke/zen-mode.nvim
        "folke/zen-mode.nvim",
        opt = true,
        cmd = { "ZenMode" },
        config = function()
            require("zen-mode").setup({})
        end,
    })
    -- use({
    --     -- https://github.com/junegunn/goyo.vim
    --     "junegunn/goyo.vim",
    --     opt = true,
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
    -- })

    ----------------------
    -- commands
    ----------------------
    use({
        -- https://github.com/tpope/vim-eunuch
        "tpope/vim-eunuch",
        opt = true,
        cmd = {
            "Remove",
            "Unlink",
            "Move",
            "Rename",
            "Delete",
            "Chmod",
            "SudoEdit",
            "SudoWrite",
            "Mkdir",
        },
    })
    use({
        -- https://github.com/mhinz/vim-grepper
        "mhinz/vim-grepper",
        opt = true,
        cmd = { "Grepper" },
        keys = { { "n", "gs" }, { "x", "gs" } },
        config = function()
            map("n", "gs", "<plug>(GrepperOperator)", {})
            map("x", "gs", "<plug>(GrepperOperator)", {})
            vim.cmd("runtime plugin/grepper.vim")
            vim.g.grepper.tools = { "rg", "grep", "git" }
            vim.g.grepper.prompt = 1
            vim.g.grepper.highlight = 0
            vim.g.grepper.open = 1
            vim.g.grepper.switch = 1
            vim.g.grepper.dir = "repo,cwd,file"
            vim.g.grepper.jump = 0
        end,
    })
    use({
        -- https://github.com/neomake/neomake
        "neomake/neomake",
        opt = true,
        cmd = { "Neomake" },
        config = function()
            vim.g.neomake_plantuml_default_maker = {
                exe = "plantuml",
                args = {},
                errorformat = [[%EError\ line\ %l\ in\ file:\ %f,%Z%m]],
            }
            vim.g.neomake_plantuml_svg_maker = {
                exe = "plantumlsvg",
                args = {},
                errorformat = [[%EError\ line\ %l\ in\ file:\ %f,%Z%m]],
            }
            vim.g.neomake_plantuml_pdf_maker = {
                exe = "plantumlpdf",
                args = {},
                errorformat = [[%EError\ line\ %l\ in\ file:\ %f,%Z%m]],
            }
            vim.g.neomake_plantuml_enabled_makers = { "default" }
            vim.cmd([[
                function! LightLineNeomake()
                  let l:jobs = neomake#GetJobs()
                  if len(l:jobs) > 0
                      return len(l:jobs).'⚒'
                  endif
                  return ''
                endfunction
            ]])
            vim.cmd([[
                let g:lightline.active.left[0] = [ "winnr", "neomake", "mode", "paste" ]
                let g:lightline.component_function.neomake = "LightLineNeomake"
                call lightline#init()
            ]])
        end,
    })
    use({
        -- https://github.com/jceb/vim-helpwrapper
        "jceb/vim-helpwrapper",
        opt = true,
        cmd = {
            "Help",
            "HelpXlst2",
            "HelpDocbk",
            "HelpMarkdown",
            "HelpTerraform",
        },
    })
    -- use({
    --     -- https://github.com/danymat/neogen
    --     "danymat/neogen",
    --    requires = {
    --        -- https://github.com/nvim-treesitter/nvim-treesitter
    --        "nvim-treesitter/nvim-treesitter"},
    --     opt = true,
    --     cmd = { "Neogen" },
    --     config = function()
    --         require("neogen").setup({})
    --     end,
    -- })

    ----------------------
    -- information
    ----------------------
    use({
        -- https://github.com/liuchengxu/vista.vim
        "liuchengxu/vista.vim",
        opt = true,
        cmd = { "Vista" },
        config = function()
            vim.g.vista_sidebar_width = 50
        end,
    })
    use({
        -- https://github.com/simrat39/symbols-outline.nvim
        "simrat39/symbols-outline.nvim",
        opt = true,
        cmd = {
            "SymbolsOutline",
            "SymbolsOutlineOpen",
            "SymbolsOutlineClose",
        },
    })
    -- use({
    --     -- https://github.com/mfussenegger/nvim-lint
    --     "mfussenegger/nvim-lint",
    --     confg = function()
    --         vim.cmd([[
    --             au BufWritePost <buffer> lua require('lint').try_lint()
    --             au BufWritePost <buffer> markdown require('lint').try_lint()
    --             au BufWritePost <buffer> javascript,javascriptjsx require('lint').try_lint()
    --             au BufWritePost <buffer> typescript,typescriptjsx require('lint').try_lint()
    --             au BufWritePost <buffer> go require('lint').try_lint()
    --             au BufWritePost <buffer> html require('lint').try_lint()
    --         ]])
    --         require("lint").linters_by_ft = {
    --             asciidoc = { "value", "languagetool" },
    --             css = { "stylint" },
    --             dockerfile = { "hadolint" },
    --             go = { "golangcilint" },
    --             html = { "tidy", "stylint", "vale" },
    --             javascript = { "eslint" },
    --             javascriptjsx = { "eslint" },
    --             lua = { "luacheck" },
    --             markdown = { "stylint", "value", "languagetool" },
    --             nix = { "nix" },
    --             sh = { "shellcheck" },
    --             txt = { "languagetool" },
    --             typescript = { "eslint" },
    --             typescriptjsx = { "eslint" },
    --         }
    --     end,
    -- })
    -- use({
    --     -- https://github.com/folke/trouble.nvim
    --     "folke/trouble.nvim",
    --     requires = {
    --         -- https://github.com/kyazdani42/nvim-web-devicons
    --         "kyazdani42/nvim-web-devicons",
    --     },
    --     config = function()
    --         require("trouble").setup({})
    --     end,
    -- })
    use({
        -- https://github.com/dbeniamine/cheat.sh-vim
        "dbeniamine/cheat.sh-vim",
        opt = true,
        cmd = { "Cheat" },
        confg = function()
            vim.g.CheatSheetDoNotMap = 1
            vim.g.CheatDoNotReplaceKeywordPrg = 1
        end,
    })

    ----------------------
    -- misc
    ----------------------
    -- use ({
    --     -- https://github.com/raghur/vim-ghost
    --     "raghur/vim-ghost"})
    use({
        -- https://github.com/rafcamlet/nvim-luapad
        "rafcamlet/nvim-luapad",
        opt = true,
        cmd = { "Luapad" },
    })
    use({
        -- https://github.com/glacambre/firenvim
        "glacambre/firenvim",
        run = function()
            vim.fn["firenvim#install"](0)
        end,
        config = function()
            vim.cmd([[
                      if exists('g:started_by_firenvim')
                        set laststatus=0
                        set showtabline=0
                        set nonumber norelativenumber
                        " au BufEnter *.txt set filetype=markdown

                        let g:firenvim_config = { 'globalSettings': { 'alt': 'all', }, 'localSettings': { '.*': { 'cmdline': 'firenvim', 'priority': 0, 'selector': 'textarea', 'takeover': 'never', }, } }
                        let fc = g:firenvim_config['localSettings']
                        let fc['https?://[^/]*twitter\.com/'] = { 'takeover': 'never', 'priority': 1 }
                        let fc['https?://[^/]*trello\.com/'] = { 'takeover': 'never', 'priority': 1 }
                      else
                          set laststatus=2
                          " set laststatus=3
                      endif
                    ]])
        end,
    })
    use({
        -- https://github.com/equalsraf/neovim-gui-shim
        "equalsraf/neovim-gui-shim",
    })
    use({
        -- https://github.com/tpope/vim-characterize
        "tpope/vim-characterize",
        opt = true,
        keys = { { "n", "ga" } },
        config = function()
            map("n", "ga", "<Plug>(characterize)", {})
        end,
    })
    -- use({
    --     -- https://github.com/sakhnik/nvim-gdb
    --     "sakhnik/nvim-gdb",
    --     opt = true,
    --     cmd = {
    --         "GdbStart",
    --         "GdbStartLLDB",
    --         "GdbStartPDB",
    --         "GdbStartBashDB",
    --         "GdbBreakpointToggle",
    --         "GdbUntil",
    --         "GdbContinue",
    --         "GdbNext",
    --         "GdbStep",
    --         "GdbFinish",
    --         "GdbFrameUp",
    --         "GdbFrameDown",
    --     },
    -- })
    -- use {'diepm/vim-rest-console', setup=function()
    --     vim.cmd([[
    --         augroup ft_rest
    --           au!
    --           au BufReadPost,BufNewFile *.rest		packadd rest-console|setf rest
    --         augroup END
    --         command! -nargs=0 Restconsole :packadd rest-console|if &ft != "rest"|new|set ft=rest|endif
    --         " let g:vrc_show_command = 1
    --         let g:vrc_show_command = 0
    --         let g:vrc_curl_opts = { '--connect-timeout' : 10, '-L': '', '-i': '', '--max-time': 60, '-k': '', '-sS': '', }
    --                     " \ '-v': '',
    --                     " \ '-H': 'accept: application/json',
    --         let g:vrc_auto_format_response_patterns = { 'json': 'jq .', 'xml': 'xmllint --format -', }
    --     ]])
    --
    -- end}
    use({
        -- https://github.com/NTBBloodbath/rest.nvim
        "NTBBloodbath/rest.nvim",
        requires = {
            -- https://github.com/nvim-lua/plenary.nvim
            "nvim-lua/plenary.nvim",
        },
        -- FIXMED: opt doesn't seem to work
        -- opt = true,
        -- ft = { "http" },
        config = function()
            require("rest-nvim").setup({
                result_split_horizontal = false,
            })
            vim.cmd([[
            au FileType http nmap <buffer> <silent> <C-j> <Plug>RestNvim
            au FileType http nmap <buffer> <silent> <C-q> <Plug>RestNvimPreview
            ]])
        end,
    })
    -- use({
    --     -- https://github.com/jceb/vim-hier
    --     "jceb/vim-hier",
    -- })
    -- use({
    --     -- https://github.com/sjl/gundo.vim
    --     "sjl/gundo.vim",
    -- })
end)
