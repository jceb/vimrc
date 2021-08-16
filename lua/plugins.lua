-- More ideas
-- https://github.com/siduck76/NvChad/tree/main/lua

map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

global_opts = {noremap = true, silent = true}
map("n", "<M-h>", "gT", global_opts)
map("n", "<M-S-h>", "<cmd>tabmove -<CR>", global_opts)
map("n", "<M-l>", "gt", global_opts)
map("n", "<M-S-l>", "<cmd>tabmove +<CR>", global_opts)
map("n", "<M-1>", "1gt", global_opts)
map("n", "<M-2>", "2gt", global_opts)
map("n", "<M-3>", "3gt", global_opts)
map("n", "<M-4>", "4gt", global_opts)
map("n", "<M-5>", "5gt", global_opts)
map("n", "<M-6>", "6gt", global_opts)
map("n", "<M-7>", "7gt", global_opts)
map("n", "<M-8>", "8gt", global_opts)
map("n", "<M-9>", "9gt", global_opts)

return require("packer").startup(
    function()
        -- Packer can manage itself
        use "wbthomason/packer.nvim"

        ----------------------
        -- git
        ----------------------
        use {"tpope/vim-dispatch", opt = true, cmd = {"Dispatch", "Make", "Focus", "Start"}}
        use {
            -- Give this a try:
            -- use {"TimUntersberger/neogit"}
            "tpope/vim-fugitive",
            opt = true,
            config = function()
                vim.cmd("autocmd BufReadPost fugitive://* set bufhidden=delete")
                vim.cmd(
                    [[
                    let g:lightline.active.left[1] = [ 'bomb', 'diff', 'scrollbind', 'noeol', 'readonly', 'fugitive', 'filename', 'modified' ]
                    let g:lightline.component_function.neomake = 'LightLineFugitive'
                    function! LightLineFugitive()
                      if exists('*fugitive#head')
                          let _ = fugitive#head()
                          return strlen(_) ? _ . ' ' : ''
                      endif
                      return ''
                    endfunction
                    ]]
                )
            end,
            cmd = {"Git", "GBrowse", "Gdiffsplit", "Gstatus", "Gwrite", "0Gclog", "Gclog", "Gmove", "Gedit"}
        }

        ----------------------
        -- file management
        ----------------------
        -- use {'tpope/vim-vinegar'}
        use {
            "kyazdani42/nvim-tree.lua",
            opt = true,
            cmd = {"NvimTreeToggle"},
            setup = function()
                vim.g.nvim_tree_ignore = {".git", "node_modules", ".cache"}
                vim.g.nvim_tree_gitignore = 1
                vim.g.nvim_tree_quit_on_open = 1
                vim.g.nvim_tree_follow = 1
                vim.g.nvim_tree_indent_markers = 1
            end,
            config = function()
                local tree_cb = require "nvim-tree.config".nvim_tree_callback
                vim.g.nvim_tree_bindings = {
                    {key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit")},
                    {key = {"<2-RightMouse>", "<C-]>"}, cb = tree_cb("cd")},
                    {key = "<C-v>", cb = tree_cb("vsplit")},
                    {key = "<C-x>", cb = tree_cb("split")},
                    {key = "<C-t>", cb = tree_cb("tabnew")},
                    {key = "<", cb = tree_cb("prev_sibling")},
                    {key = ">", cb = tree_cb("next_sibling")},
                    {key = "P", cb = tree_cb("parent_node")},
                    {key = "<BS>", cb = tree_cb("close_node")},
                    {key = "<S-CR>", cb = tree_cb("close_node")},
                    {key = "<Tab>", cb = tree_cb("preview")},
                    {key = "K", cb = tree_cb("first_sibling")},
                    {key = "J", cb = tree_cb("last_sibling")},
                    {key = "I", cb = tree_cb("toggle_ignored")},
                    {key = "H", cb = tree_cb("toggle_dotfiles")},
                    {key = "R", cb = tree_cb("refresh")},
                    {key = "a", cb = tree_cb("create")},
                    {key = "d", cb = tree_cb("remove")},
                    {key = "r", cb = tree_cb("rename")},
                    {key = "<C-r>", cb = tree_cb("full_rename")},
                    {key = "x", cb = tree_cb("cut")},
                    {key = "c", cb = tree_cb("copy")},
                    {key = "p", cb = tree_cb("paste")},
                    {key = "y", cb = tree_cb("copy_name")},
                    {key = "Y", cb = tree_cb("copy_path")},
                    {key = "gy", cb = tree_cb("copy_absolute_path")},
                    {key = "[c", cb = tree_cb("prev_git_item")},
                    {key = "]c", cb = tree_cb("next_git_item")},
                    {key = "-", cb = tree_cb("dir_up")},
                    {key = "q", cb = tree_cb("close")},
                    {key = "g?", cb = tree_cb("toggle_help")}
                }
            end
        }
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                -- "nvim-lua/popup.nvim",
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-fzy-native.nvim",
                "kyazdani42/nvim-web-devicons"
            },
            -- opt = true, -- FIXME opt doesn't work for some unknown reason
            cmd = {"Telescope"},
            config = function()
                local actions = require("telescope.actions")
                local sorters = require("telescope.sorters")
                -- Global remapping
                ------------------------------
                require("telescope").load_extension("fzy_native")
                require("telescope").setup {
                    defaults = {
                        mappings = {
                            i = {
                                ["<c-x>"] = false,
                                ["<C-s>"] = actions.file_split
                                -- ["<esc>"] = actions.close,
                            },
                            n = {
                                ["<esc>"] = actions.close
                            }
                        }
                    }
                }
                vim.cmd("highlight link TelescopeMatching IncSearch")
            end
        }
        use {
            "justinmk/vim-dirvish",
            opt = true,
            cmd = {"Dirvish", "Explore", "Sexplore", "Vexplore"},
            keys = {{"n", "-"}},
            setup = function()
                vim.g.netrw_browsex_viewer = "xdg-open-background"

                vim.g.dirvish_mode = [[ :sort ,^.*[\/], ]]

                local opts = {noremap = true, silent = true}
                map(
                    "n",
                    "<Plug>NetrwBrowseX",
                    ':call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : "<cfile>")),netrw#CheckIfRemote())<CR>',
                    opts
                )
                map("n", "gx", "<Plug>NetrwBrowseX", {})
                map("v", "<Plug>NetrwBrowseXVis", ":<c-u>call netrw#BrowseXVis()<CR>", opts)
                map("v", "gx", "<Plug>NetrwBrowseXVis", {})
            end,
            config = function()
                vim.cmd("command! -nargs=? -complete=dir Explore Dirvish <args>")
                vim.cmd("command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>")
                vim.cmd("command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>")

                vim.cmd(
                    [[
                      augroup my_dirvish_events
                          autocmd!
                          " Map t to "open in new tab".
                          autocmd FileType dirvish  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>|xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
                          " Enable :Gstatus and friends.
                          " autocmd FileType dirvish call fugitive#detect(@%)

                          " Map `gh` to hide dot-prefixed files.
                          " To "toggle" this, just press `R` to reload.
                          autocmd FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>
                          autocmd FileType dirvish nnoremap <buffer> <space>e :e %/
                      augroup END
                  ]]
                )
            end
        }

        ----------------------
        -- movement
        ----------------------
        use {'Houl/repmo-vim', config=function()
          local opts = { noremap = true, expr = true }
          -- map a motion and its reverse motion:
          map('', 'h', 'repmo#SelfKey("h", "l")', opts)
          unmap('s', 'h')
          map('', 'l', 'repmo#SelfKey("l", "h")', opts)
          unmap('s', 'l')
          map('', '<C-E>', 'repmo#SelfKey("<C-E>", "<C-Y>")', opts)
          unmap('s', '<C-E>')
          map('', '<C-Y>', 'repmo#SelfKey("<C-Y>", "<C-E>")', opts)
          unmap('s', '<C-Y>')
          map('', '<C-D>', 'repmo#SelfKey("<C-D>", "<C-U>")', opts)
          unmap('s', '<C-D>')
          map('', '<C-U>', 'repmo#SelfKey("<C-U>", "<C-D>")', opts)
          unmap('s', '<C-U>')
          map('', '<C-F>', 'repmo#SelfKey("<C-F>", "<C-B>")', opts)
          unmap('s', '<C-F>')
          map('', '<C-B>', 'repmo#SelfKey("<C-B>", "<C-F>")', opts)
          unmap('s', '<C-B>')
          map('', 'e', 'repmo#SelfKey("e", "ge")', opts)
          unmap('s', 'e')
          map('', 'ge', 'repmo#SelfKey("ge", "e")', opts)
          unmap('s', 'ge')
          map('', 'b', 'repmo#SelfKey("b", "w")', opts)
          unmap('s', 'b')
          map('', 'w', 'repmo#SelfKey("w", "b")', opts)
          unmap('s', 'w')
          map('', 'B', 'repmo#SelfKey("B", "W")', opts)
          unmap('s', 'B')
          map('', 'W', 'repmo#SelfKey("W", "B")', opts)
          unmap('s', 'W')
          -- repeat the last [count]motion or the last zap-key:
          map('', ';', 'repmo#LastKey(";")', opts)
          unmap('s', ';')
          map('', ',', 'repmo#LastRevKey(",")', opts)
          unmap('s', ',')
          -- add these mappings when repeating with `;' or `,':
          map('', 'f', 'repmo#ZapKey("f", 1)', opts)
          unmap('s', 'f')
          map('', 'F', 'repmo#ZapKey("F", 1)', opts)
          unmap('s', 'F')
          map('', 't', 'repmo#ZapKey("t", 1)', opts)
          unmap('s', 't')
          map('', 'T', 'repmo#ZapKey("T", 1)', opts)
          unmap('s', 'T')
        end}
        use {"arp242/jumpy.vim"}
        use {"vim-scripts/lastpos.vim"}
        use {"jceb/vim-shootingstar"}
        use {
            "mg979/vim-visual-multi",
            opt = true,
            keys = {{"n", "<C-Up>"}, {"n", "<C-Down>"}, {"n", "<C-n>"}, {"v", "<C-n>"}},
            setup = function()
                vim.g.VM_maps = {}
                -- let g:VM_leader = {'default': '\', 'visual': '\', 'buffer': 'z'}
            end
        }
        use {"vim-scripts/StarRange"}
        use {
            "tpope/vim-unimpaired",
            opt = true,
            keys = {
                {"n", "[e"},
                {"n", "]e"},
                {"n", "[<Space>"},
                {"n", "]<Space>"},
                {"n", "yod"},
                {"n", "yow"}
            },
            config = function()
                -- disable legacy mappings
                map("n", "co", "<Nop>", {})
                map("n", "=o", "<Nop>", {})
            end
        }
        use {
            "tpope/vim-rsi",
            setup = function()
                vim.g.rsi_no_meta = 1
            end
        }
        use {
            "vim-scripts/diffwindow_movement",
            opt = true,
            requires = {"inkarkat/vim-CountJump", "inkarkat/vim-ingo-library"},
            config = function()
                local opts = {noremap = true}
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
            end
        }
        use {
            "abecodes/tabout.nvim",
            config = function()
                require("tabout").setup {
                    tabkey = "<C-j>", -- key to trigger tabout, set to an empty string to disable
                    backwards_tabkey = "<C-k>", -- key to trigger backwards tabout, set to an empty string to disable
                    act_as_tab = false, -- shift content if tab out is not possible
                    act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
                    enable_backwards = true, -- well ...
                    completion = false, -- if the tabkey is used in a completion pum
                    tabouts = {
                        {open = "'", close = "'"},
                        {open = '"', close = '"'},
                        {open = "`", close = "`"},
                        {open = "(", close = ")"},
                        {open = "[", close = "]"},
                        {open = "{", close = "}"},
                        {open = "<", close = ">"}
                    },
                    ignore_beginning = true --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]],
                    exclude = {} -- tabout will ignore these filetypes
                }
            end,
            wants = {"nvim-treesitter/nvim-treesitter"} -- or require if not used so far
        }

        ----------------------
        -- session management
        ----------------------
        use {"tpope/vim-obsession", opt = true, cmd = {"Obsession"}}
        use {
            "jceb/vim-cd",
            opt = true,
            cmd = {
                "CD",
                "Cd",
                "LCD",
                "Lcd",
                "TCD",
                "Tcd",
                "Wcd",
                "Wlcd",
                "Wtcd",
                "WindoCD",
                "WindoCd",
                "WindoLCD",
                "WindoLcd",
                "WindoTCD",
                "WindoTcd",
                "Cdroot",
                "Lcdroot",
                "Tcdroot",
                "WindoCdroot",
                "WindoLcdroot",
                "WindoTcdroot",
                "Pathadd",
                "Pathrm",
                "PathaddRoot",
                "PathrmRoot"
            },
            fn = {
                "GetRootDir"
            }
        }
        use {
            "folke/todo-comments.nvim",
            requires = {"nvim-lua/plenary.nvim"},
            opt = true,
            cmd = {"TodoTelescope", "TodoQuickFix", "TodoLocList", "TodoTrouble"},
            config = function()
                require("todo-comments").setup {}
            end
        }

        ----------------------
        -- buffer management
        ----------------------
        use {"mhinz/vim-sayonara", opt = true, cmd = {"Sayonara"}}
        use {
            "troydm/easybuffer.vim",
            opt = true,
            cmd = {"EasyBufferBotRight"},
            config = function()
                vim.g.easybuffer_chars = {"a", "s", "f", "i", "w", "e", "z", "c", "v"}
            end
        }
        use {"tpope/vim-projectionist", opt = true}

        ----------------------
        -- completion
        ----------------------
        -- use {'gelguy/wilder.nvim', config=function()
        --   vim.call('wilder#enable_cmdline_enter')
        --   vim.opt.wildcharm=9
        --   map('c',  '<Tab>', 'wilder#in_context() ? wilder#next() : "<Tab>"', {expr = true})
        --   map('c',  '<S-Tab>', 'wilder#in_context() ? wilder#previous() : "<S-Tab>"', {expr = true})
        --   -- only / and ? are enabled by default
        --   vim.call('wilder#set_option', 'modes', { '/', '?', ':' })
        -- end}
        -- use {"neoclide/coc.nvim", run = "npm run build", cmd = "CocUpdate"}
        use {
            "neovim/nvim-lspconfig",
            -- add more language servers: https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
            run = "yarn global add dockerfile-language-server-nodejs graphql-language-service-cli vscode-langservers-extracted typescript typescript-language-server vim-language-server vls yaml-language-server prettier eslint_d lua-fmt",
            config = function()
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                capabilities.textDocument.completion.completionItem.snippetSupport = true

                require "lspconfig".dockerls.setup {
                    capabilities = capabilities
                }
                require "lspconfig".bashls.setup {
                    capabilities = capabilities
                }
                -- require'lspconfig'.ccls.setup{}
                require "lspconfig".clangd.setup {
                    capabilities = capabilities
                }
                require "lspconfig".denols.setup {
                    capabilities = capabilities
                }
                require "lspconfig".gopls.setup {
                    capabilities = capabilities
                }
                require "lspconfig".graphql.setup {
                    capabilities = capabilities
                }
                require "lspconfig".html.setup {
                    capabilities = capabilities
                }
                require "lspconfig".cssls.setup {
                    capabilities = capabilities
                }
                require "lspconfig".jsonls.setup {
                    capabilities = capabilities
                }
                require "lspconfig".pyright.setup {
                    capabilities = capabilities
                }
                require "lspconfig".rust_analyzer.setup {
                    capabilities = capabilities
                }
                require "lspconfig".svelte.setup {
                    capabilities = capabilities
                }
                require "lspconfig".terraformls.setup {
                    capabilities = capabilities
                }
                require "lspconfig".tsserver.setup {
                    capabilities = capabilities
                }
                require "lspconfig".vimls.setup {
                    capabilities = capabilities
                }
                require "lspconfig".vuels.setup {
                    capabilities = capabilities
                }
                require "lspconfig".yamlls.setup {
                    capabilities = capabilities
                }
            end
        }
        use {
            "hrsh7th/nvim-compe",
            config = function()
                require "compe".setup {
                    enabled = true,
                    autocomplete = true,
                    debug = false,
                    min_length = 1,
                    preselect = "enable",
                    throttle_time = 80,
                    source_timeout = 200,
                    resolve_timeout = 800,
                    incomplete_delay = 400,
                    max_abbr_width = 100,
                    max_kind_width = 100,
                    max_menu_width = 100,
                    documentation = {
                        border = {"", "", "", " ", "", "", "", " "}, -- the border option is the same as `|help nvim_open_win|`
                        winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
                        max_width = 120,
                        min_width = 60,
                        max_height = math.floor(vim.o.lines * 0.3),
                        min_height = 1
                    },
                    source = {
                        path = true,
                        emoji = true,
                        spell = true,
                        tags = true,
                        buffer = true,
                        calc = true,
                        nvim_lsp = true,
                        nvim_lua = true,
                        luasnip = true
                    }
                }
                vim.api.nvim_set_keymap(
                    "i",
                    "<c-Space>",
                    [[compe#complete()]],
                    {expr = true, noremap = true, silent = true}
                )
                -- vim.api.nvim_set_keymap(
                --     "i",
                --     "<cr>",
                --     [[compe#confirm(luaeval("require 'nvim-autopairs'.autopairs_cr()"))]],
                --     {expr = true, noremap = true, silent = true}
                -- )
                vim.api.nvim_set_keymap(
                    "i",
                    "<c-e>",
                    [[compe#close('<C-e>')]],
                    {expr = true, noremap = true, silent = true}
                )

                local t = function(str)
                    return vim.api.nvim_replace_termcodes(str, true, true, true)
                end

                local check_back_space = function()
                    local col = vim.fn.col(".") - 1
                    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
                end

                -- Use (s-)tab to:
                --- move to prev/next item in completion menuone
                --- jump to prev/next snippet's placeholder
                _G.tab_complete = function()
                    if vim.fn.pumvisible() == 1 then
                        return t "<C-n>"
                    elseif vim.fn["vsnip#available"](1) == 1 then
                        return t "<Plug>(vsnip-expand-or-jump)"
                    elseif check_back_space() then
                        return t "<Tab>"
                    else
                        return vim.fn["compe#complete"]()
                    end
                end
                _G.s_tab_complete = function()
                    if vim.fn.pumvisible() == 1 then
                        return t "<C-p>"
                    elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                        return t "<Plug>(vsnip-jump-prev)"
                    else
                        -- If <S-Tab> is not working in your terminal, change it to <C-h>
                        return t "<S-Tab>"
                    end
                end

                vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
                vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
                vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
                vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
            end
        }

        ----------------------
        -- copy / paste
        ----------------------
        use {
            "svermeulen/vim-yoink",
            opt = true,
            keys = {{"n", "p"}, {"n", "P"}, {"n", "<M-n>"}, {"n", "<M-p>"}},
            config = function()
                vim.g.yoinkAutoFormatPaste = 0 -- this doesn't work properly, so fix it to <F11> manualy
                vim.g.yoinkMaxItems = 20

                map("n", "<M-n>", "<plug>(YoinkPostPasteSwapBack)", {})
                map("n", "<M-p>", "<plug>(YoinkPostPasteSwapForward)", {})
                map("n", "p", "<plug>(YoinkPaste_p)", {})
                map("n", "P", "<plug>(YoinkPaste_P)", {})
            end
        }

        ----------------------
        -- text transformation
        ----------------------
        use {"tpope/vim-abolish", opt = true, cmd = {"Abolish", "S", "Subvert"}}
        use {
            "tomtom/tcomment_vim",
            as = "tcomment",
            opt = true,
            keys = {{"n", "gc"}, {"v", "gc"}, {"n", "gcc"}, {"i", "<C-c>"}},
            setup = function()
                vim.g.tcomment_mapleader1 = ""
                vim.g.tcomment_mapleader2 = ""
            end,
            config = function()
                vim.cmd(
                    [[
                      function! InsertCommentstring()
                          let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
                          let col = col('.')
                          let line = line('.')
                          let g:ics_pos = [line, col + strlen(l)]
                          return l.r
                      endfunction
                  ]]
                )
                vim.cmd(
                    [[
                      function! ICSPositionCursor()
                          call cursor(g:ics_pos[0], g:ics_pos[1])
                          unlet g:ics_pos
                      endfunction
                  ]]
                )

                map("i", "<C-c>", "<C-r>=InsertCommentstring()<CR><C-o>:call ICSPositionCursor()<CR>", {noremap = true})
            end
        }
        use {
            "windwp/nvim-autopairs",
            opt = true,
            keys = {{"i", "{"}, {"i", "["}, {"i", "("}, {"i", "<"}, {"i", "'"}, {"i", '"'}},
            config = function()
                require("nvim-autopairs").setup {}
            end
        }
        use {
            "svermeulen/vim-subversive",
            opt = true,
            keys = {{"n", "gr"}, {"n", "gR"}, {"n", "grr"}, {"n", "grs"}, {"x", "grs"}, {"n", "grss"}},
            config = function()
                map("n", "gR", "<plug>(SubversiveSubstituteToEndOfLine)", {})
                map("n", "gr", "<plug>(SubversiveSubstitute)", {})
                map("n", "grr", "<plug>(SubversiveSubstituteLine)", {})
                map("n", "grs", "<plug>(SubversiveSubstituteRange)", {})
                map("x", "grs", "<plug>(SubversiveSubstituteRange)", {})
                map("n", "grss", "<plug>(SubversiveSubstituteWordRange)", {})
            end
        }
        use {
            "junegunn/vim-easy-align",
            opt = true,
            keys = {{"n", "<Plug>(EasyAlign)"}, {"x", "<Plug>(EasyAlign)"}},
            config = function()
                map("x", "g=", "<Plug>(EasyAlign)", {})
                map("n", "g=", "<Plug>(EasyAlign)", {})
                map("n", "g/", "g=ip*|", {})
            end
        }
        use {
            "tpope/vim-surround",
            opt = true,
            keys = {{"n", "ys"}, {"n", "yss"}, {"n", "ds"}, {"n", "cs"}},
            config = function()
                vim.g.surround_no_insert_mappings = 1
            end
        }
        use {"tpope/vim-repeat"}
        use {
            "jceb/vim-textobj-uri",
            requires = {"kana/vim-textobj-user"},
            opt = true,
            keys = {{"n", "go"}},
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
            end
        }
        use {"vim-scripts/VisIncr", opt = true, cmd = {"I", "II"}}
        use {
            "sbdchd/neoformat",
            opt = true,
            cmd = {"Neoformat"},
            config = function()
                vim.g.neoformat_yaml_yq = {
                    exe = "yq",
                    args = {"-P", "eval", ".", "-"},
                    stdin = 1,
                    no_append = 1
                }
                vim.g.neoformat_enabled_yaml = {"yq"}
            end
        }
        use {
            "mjbrownie/swapit",
            requires = {
                {
                    "tpope/vim-speeddating",
                    as = "speeddating",
                    setup = function()
                        local opts = {noremap = true, silent = true}
                        vim.g.speeddating_no_mappings = 1
                        map("n", "<Plug>SpeedDatingFallbackUp", "<C-a>", opts)
                        map("n", "<Plug>SpeedDatingFallbackDown", "<C-x>", opts)
                    end
                }
            },
            opt = true,
            keys = {
                {"n", "<Plug>SwapItFallbackIncrement"},
                {"n", "<Plug>SwapItFallbackDecrement"},
                {"n", "<C-a>"},
                {"n", "<C-x>"},
                {"n", "<C-t>"}
            },
            config = function()
                local opts = {silent = true}
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
            end
        }
        use {
            "Ron89/thesaurus_query.vim",
            opt = true,
            ft = {"mail", "help", "debchangelog", "tex", "plaintex", "txt", "asciidoc", "markdown", "org"},
            setup = function()
                vim.g.tq_map_keys = 1
                vim.g.tq_use_vim_autocomplete = 0
                vim.g.tq_language = {"en", "de"}
            end
        }
        -- use {
        --     "SirVer/ultisnips",
        --     requires = {"honza/vim-snippets"},
        --     setup = function()
        --         vim.cmd(
        --             [[
        --         let g:UltiSnipsRemoveSelectModeMappings = 0
        --         let g:UltiSnipsExpandTrigger = '<c-h>'
        --     ]]
        --         )
        --     end
        -- }
        use {
            "L3MON4D3/LuaSnip",
            requires = {"rafamadriz/friendly-snippets"},
            config = function()
                local ls = require "luasnip"
                local s = ls.snippet
                local sn = ls.snippet_node
                local t = ls.text_node
                local i = ls.insert_node
                local f = ls.function_node
                local c = ls.choice_node
                local d = ls.dynamic_node
                -- Create snippets here
                s("trigger", t("Wow! Text!"))
                require("luasnip/loaders/from_vscode").load(
                    {paths = {"~/.local/share/nvim/site/pack/packer/start/friendly-snippets"}}
                )
            end
        }

        -- use {"dpelle/vim-LanguageTool"}

        ----------------------
        -- settings
        ----------------------
        use {
            "editorconfig/editorconfig-vim",
            config = function()
                vim.g.EditorConfig_exclude_patterns = {"fugitive://.*", "scp://.*"}
            end
        }

        ----------------------
        -- visuals
        ----------------------
        use {
            "jceb/blinds.nvim",
            config = function()
                vim.g.blinds_guibg = "#cdcdcd"
            end
        }
        -- use {'lukas-reineke/indent-blankline.nvim'}
        use {
            "vasconcelloslf/vim-interestingwords",
            opt = true,
            keys = {{"n", "<Space-i>"}, {"v", "<Space-i>"}},
            setup = function()
                map("n", "<Space-i>", '<cmd>call InterestingWords("n")<CR>', {})
                map("v", "<Space-i>", '<cmd>call InterestingWords("n")<CR>', {})
                vim.cmd("command! InterestingWordsClear :call UncolorAllWords()")
            end
        }
        use "norcalli/nvim-colorizer.lua"
        use {"andymass/vim-matchup", event = "VimEnter"}
        use {
            "nvim-treesitter/nvim-treesitter",
            run = {":TSInstall all", ":TSUpdate"},
            config = function()
                require "nvim-treesitter.configs".setup {
                    highlight = {
                        enable = true
                    },
                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = "gnn",
                            node_incremental = "grn",
                            scope_incremental = "grc",
                            node_decremental = "grm"
                        }
                    },
                    indent = {
                        enable = false
                    }
                }
                vim.opt.foldmethod = "expr"
                vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            end
        }
        use {
            "itchyny/lightline.vim",
            -- opt = true,
            as = "lightline",
            setup = function()
                vim.cmd(
                    [[
                    " let g:lightline = {
                    "     \ 'colorscheme': 'PaperColor',
                    "     \ 'component': {
                    "     \   'bomb': '%{&bomb?"💣":""}',
                    "     \   'diff': '%{&diff?"◑":""}',
                    "     \   'lineinfo': ' %3l:%-2v',
                    "     \   'modified': '%{&modified?"±":""}',
                    "     \   'noeol': '%{&endofline?"":"!↵"}',
                    "     \   'readonly': '%{&readonly?"":""}',
                    "     \   'scrollbind': '%{&scrollbind?"∞":""}',
                    "     \ },
                    "     \ 'component_visible_condition': {
                    "     \   'bomb': '&bomb==1',
                    "     \   'diff': '&diff==1',
                    "     \   'modified': '&modified==1',
                    "     \   'noeol': '&endofline==0',
                    "     \   'scrollbind': '&scrollbind==1',
                    "     \ },
                    "     \ 'component_function': {
                    "     \ },
                    "     \ 'separator': { 'left': '', 'right': '' },
                    "     \ 'subseparator': { 'left': '', 'right': '' },
                    "     \ 'active' : {
                    "     \ 'left': [ [ 'winnr', 'mode', 'paste' ],
                    "     \           [ 'bomb', 'diff', 'scrollbind', 'noeol', 'readonly', 'filename', 'modified' ] ],
                    "     \ 'right': [ [ 'lineinfo' ],
                    "     \            [ 'percent' ],
                    "     \            [ 'fileformat', 'fileencoding', 'filetype' ] ]
                    "     \ },
                    "     \ 'inactive' : {
                    "     \ 'left': [ [ 'winnr', 'diff', 'scrollbind', 'filename', 'modified' ] ],
                    "     \ 'right': [ [ 'lineinfo' ],
                    "     \            [ 'percent' ] ]
                    "     \ },
                    "     \ }
                    let g:lightline = { 'colorscheme': 'PaperColor', 'component': { 'bomb': '%{&bomb?"💣":""}', 'diff': '%{&diff?"◑":""}', 'lineinfo': ' %3l:%-2v', 'modified': '%{&modified?"±":""}', 'noeol': '%{&endofline?"":"!↵"}', 'readonly': '%{&readonly?"":""}', 'scrollbind': '%{&scrollbind?"∞":""}', }, 'component_visible_condition': { 'bomb': '&bomb==1', 'diff': '&diff==1', 'modified': '&modified==1', 'noeol': '&endofline==0', 'scrollbind': '&scrollbind==1', }, 'component_function': { }, 'separator': { 'left': '', 'right': '' }, 'subseparator': { 'left': '', 'right': '' }, 'active' : { 'left': [ [ 'winnr', 'mode', 'paste' ], [ 'bomb', 'diff', 'scrollbind', 'noeol', 'readonly', 'filename', 'modified' ] ], 'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ] ] }, 'inactive' : { 'left': [ [ 'winnr', 'diff', 'scrollbind', 'filename', 'modified' ] ], 'right': [ [ 'lineinfo' ], [ 'percent' ] ] }, }
                    ]]
                )
            end
        }
        use {
            "NLKNguyen/papercolor-theme",
            as = "papercolor",
            opt = true,
            setup = function()
                -- " let g:PaperColor_Theme_Options = {
                -- "             \ 'theme': {
                -- "             \   'default.light': {
                -- "             \     'transparent_background': 1,
                -- "             \     'override': {
                -- "             \       'color04' : ['#87afd7', '110'],
                -- "             \       'color16' : ['#87afd7', '110'],
                -- "             \       'statusline_active_fg' : ['#444444', '238'],
                -- "             \       'statusline_active_bg' : ['#eeeeee', '255'],
                -- "             \       'visual_bg' : ['#005f87', '110'],
                -- "             \       'folded_fg' : ['#005f87', '31'],
                -- "             \       'difftext_fg':   ['#87afd7', '110'],
                -- "             \       'tabline_inactive_bg': ['#87afd7', '110'],
                -- "             \       'buftabline_inactive_bg': ['#87afd7', '110']
                -- "             \     }
                -- "             \   }
                -- "             \ }
                -- "             \ }
                vim.cmd(
                    [[
                      let g:PaperColor_Theme_Options = { 'theme': { 'default.light': { 'transparent_background': 1, 'override': { 'color04' : ['#87afd7', '110'], 'color16' : ['#87afd7', '110'], 'statusline_active_fg' : ['#444444', '238'], 'statusline_active_bg' : ['#eeeeee', '255'], 'visual_bg' : ['#005f87', '110'], 'folded_fg' : ['#005f87', '31'], 'difftext_fg':   ['#87afd7', '110'], 'tabline_inactive_bg': ['#87afd7', '110'], 'buftabline_inactive_bg': ['#87afd7', '110'] } } } }
                    ]]
                )
            end
        }
        use {
            -- Alternative:
            -- use {"shaunsingh/nord.nvim", as = "nord", opt = true}
            "arcticicestudio/nord-vim",
            as = "nord",
            opt = true
        }
        -- -- Use specific branch, dependency and run lua file after load
        -- use {
        --   'glepnir/galaxyline.nvim', branch = 'main', config = function() require'statusline' end,
        --   requires = {'kyazdani42/nvim-web-devicons'}
        -- }

        -- use {'romgrk/barbar.nvim', requires = {'kyazdani42/nvim-web-devicons'},
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
        use {"tpope/vim-apathy"}
        -- use {"jceb/emmet.snippets", opt = true}
        use {"tomlion/vim-solidity", opt = true, ft = {"solidity"}}
        use {"posva/vim-vue", opt = true, ft = {"vue"}}
        use {"asciidoc/vim-asciidoc", ft = {"asciidoc"}}
        use {"fatih/vim-go", opt = true, ft = {"go"}, run = {":GoUpdateBinaries"}}
        use {"dag/vim-fish", opt = true, ft = {"fish"}}
        use {
            "jparise/vim-graphql",
            opt = true,
            ft = {"javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "php", "reason"}
        }
        use {"leafOfTree/vim-svelte-plugin", opt = true, ft = {"svelte"}}
        use {"aklt/plantuml-syntax", opt = true, ft = {"plantuml"}}
        use {"tpope/vim-markdown", opt = true, ft = {"markdown"}}
        use {
            "hashivim/vim-terraform",
            opt = true,
            ft = {"terraform"},
            setup = function()
                vim.g.terraform_fmt_on_save = 1
            end
        }
        use {"sukima/vim-tiddlywiki", opt = true, ft = {"tiddlywiki"}}
        use {"iamcco/markdown-preview.nvim", run = "cd app && yarn install", cmd = "MarkdownPreview"}

        ----------------------
        -- terminal
        ----------------------
        use {
            "kassio/neoterm",
            opt = true,
            fn = {"neoterm#new"},
            setup = function()
                vim.cmd(
                    [[
                let g:neoterm_direct_open_repl=0
                let g:neoterm_open_in_all_tabs=1
                let g:neoterm_autoscroll=1
                let g:neoterm_term_per_tab=1
                let g:neoterm_shell="fish"
                let g:neoterm_autoinsert=1
                let g:neoterm_automap_keys='<F23>'
            ]]
                )
            end
        }
        use {
            "voldikss/vim-floaterm",
            opt = true,
            cmd = {"FloatermPrev", "FloatermNext"},
            setup = function()
                vim.cmd(
                    [[
                let g:floaterm_autoclose = 1
                let g:floaterm_shell = 'fish'
            ]]
                )
            end,
            config = function()
                vim.cmd(
                    [[
                tnoremap <silent> <M-h> <C-\><C-n>:FloatermPrev<CR>
                tnoremap <silent> <M-l> <C-\><C-n>:FloatermNext<CR>
                nnoremap <silent> <M-/> :FloatermToggle<CR>
                tnoremap <silent> <M-/> <C-\><C-n>:FloatermToggle<CR>
                nnoremap <silent> <M-t> :FloatermNew<CR>
                tnoremap <silent> <M-t> <C-\><C-n>:FloatermNew<CR>
                nnoremap <silent> <M-e> :FloatermNew nnn -Q<CR>
                tnoremap <silent> <M-e> <C-\><C-n>:FloatermNew nnn -Q<CR>
            ]]
                )
            end
        }
        -- use {
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
        -- use {'rbong/vim-buffest'}
        use {
            "szw/vim-maximizer",
            opt = true,
            cmd = {"MaximizerToggle"},
            config = function()
                vim.g.maximizer_restore_on_winleave = 1
            end
        }
        use {
            "junegunn/goyo.vim",
            config = function()
                vim.cmd(
                    [[
                    function! TmuxMaximize()
                      if exists('$TMUX')
                          silent! !tmux set-option status off
                          silent! !tmux resize-pane -Z
                      endif
                    endfun
                  ]]
                )
                vim.cmd(
                    [[
                    function! TmuxRestore()
                      if exists('$TMUX')
                          silent! !tmux set-option status on
                          silent! !tmux resize-pane -Z
                      endif
                    endfun
                  ]]
                )
                vim.cmd('let g:goyo_callbacks = [ function("TmuxMaximize"), function("TmuxRestore") ]')
            end
        }

        ----------------------
        -- commands
        ----------------------
        use {
            "tpope/vim-eunuch",
            opt = true,
            cmd = {"Remove", "Unlink", "Move", "Rename", "Delete", "Chmod", "SudoEdit", "SudoWrite", "Mkdir"}
        }
        use {
            "mhinz/vim-grepper",
            opt = true,
            cmd = {"Grepper"},
            config = function()
                map("n", "gs", "<plug>(GrepperOperator)", {})
                map("x", "gs", "<plug>(GrepperOperator)", {})
                vim.cmd("runtime plugin/grepper.vim")
                vim.g.grepper.tools = {"rg", "grep", "git"}
                vim.g.grepper.prompt = 1
                vim.g.grepper.highlight = 0
                vim.g.grepper.open = 1
                vim.g.grepper.switch = 1
                vim.g.grepper.dir = "repo,cwd,file"
                vim.g.grepper.jump = 0
            end
        }
        use {
            "neomake/neomake",
            opt = true,
            cmd = {"Neomake"},
            config = function()
                vim.g.neomake_plantuml_default_maker = {
                    exe = "plantuml",
                    args = {},
                    errorformat = [[%EError\ line\ %l\ in\ file:\ %f,%Z%m]]
                }
                vim.g.neomake_plantuml_svg_maker = {
                    exe = "plantumlsvg",
                    args = {},
                    errorformat = [[%EError\ line\ %l\ in\ file:\ %f,%Z%m]]
                }
                vim.g.neomake_plantuml_pdf_maker = {
                    exe = "plantumlpdf",
                    args = {},
                    errorformat = [[%EError\ line\ %l\ in\ file:\ %f,%Z%m]]
                }
                vim.g.neomake_plantuml_enabled_makers = {"default"}

                vim.cmd(
                    [[
                    let g:lightline.active.left[0] = [ 'winnr', 'neomake', 'mode', 'paste' ]
                    let g:lightline.component_function.neomake = 'LightLineNeomake'
                    function! LightLineNeomake()
                      let l:jobs = neomake#GetJobs()
                      if len(l:jobs) > 0
                          return len(l:jobs).'⚒'
                      endif
                      return ''
                    endfun
                    ]]
                )
            end
        }
        use {
            "jceb/vim-helpwrapper",
            opt = true,
            cmd = {"Help", "HelpXlst2", "HelpDocbk", "HelpMarkdown", "HelpTerraform"}
        }

        ----------------------
        -- information
        ----------------------
        use {
            "liuchengxu/vista.vim",
            opt = true,
            cmd = {"Vista"},
            config = function()
                vim.g.vista_sidebar_width = 50
            end
        }
        -- use {'dbeniamine/cheat.sh-vim'}

        ----------------------
        -- misc
        ----------------------
        -- use {'raghur/vim-ghost'}
        use {
            "glacambre/firenvim",
            run = function()
                vim.fn["firenvim#install"](0)
            end,
            config = function()
                vim.cmd(
                    [[
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
                      endif
                    ]]
                )
            end
        }
        use {"equalsraf/neovim-gui-shim"}
        use {
            "tpope/vim-characterize",
            opt = true,
            keys = {{"n", "ga"}},
            config = function()
                map("n", "ga", "<Plug>(characterize)", {})
            end
        }
        use {
            "sakhnik/nvim-gdb",
            opt = true,
            cmd = {
                "GdbStart",
                "GdbStartLLDB",
                "GdbStartPDB",
                "GdbStartBashDB",
                "GdbBreakpointToggle",
                "GdbUntil",
                "GdbContinue",
                "GdbNext",
                "GdbStep",
                "GdbFinish",
                "GdbFrameUp",
                "GdbFrameDown"
            }
        }
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
        use {
            -- FIXME doesn't work yet
            "NTBBloodbath/rest.nvim",
            requires = {"nvim-lua/plenary.nvim"},
            opt = true,
            ft = {"http"},
            config = function()
                require("rest-nvim").setup(
                    {
                        result_split_horizontal = false
                    }
                )
            end
        }
        -- use {'jceb/vim-hier'}
        -- use {'sjl/gundo.vim'}
    end
)
