map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
    ----------------------
    -- text transformation
    ----------------------
    -- {
    --     -- https://github.com/ziontee113/icon-picker.nvim
    --     "ziontee113/icon-picker.nvim",
    --     dependencies = {
    --         "stevearc/dressing.nvim",
    --     },
    --     config = function()
    --         local opts = { noremap = true, silent = true }
    --         vim.keymap.set("n", "<Space>ci", "<cmd>PickIcons<cr>", opts)
    --         vim.keymap.set("n", "<Space>cs", "<cmd>PickAltFontAndSymbols<cr>", opts)
    --         -- vim.keymap.set("i", "<C-i>", "<cmd>PickIconsInsert<cr>", opts)
    --         -- vim.keymap.set("i", "<C-S-i>", "<cmd>PickAltFontAndSymbolsInsert<cr>", opts)
    --         vim.keymap.set("i", "<A-i>", "<cmd>PickIconsInsert<cr>", opts)
    --         vim.keymap.set("i", "<M-s>", "<cmd>PickAltFontAndSymbolsInsert<cr>", opts)
    --
    --         require("icon-picker")
    --     end,
    -- },
    {
        -- https://github.com/uga-rosa/ccc.nvim
        "uga-rosa/ccc.nvim",
        lazy = true,
        keys = { { "<Space>cc", "<cmd>CccPick<cr>" }, { "<C-S-c>", "<Plug>(ccc-insert)", mode = "i" } },
        config = function()
            local opts = { noremap = false, silent = true }
            vim.keymap.set("n", "<Space>cc", "<cmd>CccPick<cr>", opts)
            vim.keymap.set("i", "<C-S-c>", "<Plug>(ccc-insert)", opts)

            local ccc = require("ccc")
            local mapping = ccc.mapping
            ccc.setup({
                -- Your favorite settings
                highlighter = {
                    auto_enable = true,
                    filetypes = { "css" },
                },
                mappings = {
                    -- Disable only 'q' (|ccc-action-quit|)
                    -- q = mapping.none,
                },
            })
            -- vim.cmd([[hi FloatBorder guibg=NONE]])
        end,
    },
    {
        -- https://github.com/tpope/vim-abolish
        "tpope/vim-abolish",
        lazy = true,
        cmd = { "Abolish", "S", "Subvert" },
        keys = { { "cr" } },
    },
    {
        -- https://github.com/numToStr/Comment.nvim
        "numToStr/Comment.nvim",
        lazy = true,
        dependencies = {
            -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        keys = {
            { "gc" },
            { "gc", mode = "v" },
            { "gb" },
            { "gb", mode = "v" },
            { "<C-c>", mode = "i" },
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
    },
    -- {
    --     -- https://github.com/tpope/vim-commentary
    --     "tpope/vim-commentary",
    --     lazy = true,
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
    -- },
    -- {
    --     -- https://github.com/tomtom/tcomment_vim
    --     "tomtom/tcomment_vim",
    --     name = "tcomment",
    --     lazy = true,
    --     keys = { { "n", "gc" }, { "v", "gc" }, { "n", "gcc" }, { "i", "<C-c>" } },
    --     init = function()
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
    -- },
    {
        -- https://github.com/windwp/nvim-autopairs
        "windwp/nvim-autopairs",
        keys = {
            { "{", mode = "i" },
            { "[", mode = "i" },
            { "(", mode = "i" },
            { "<", mode = "i" },
            { "'", mode = "i" },
            { '"', mode = "i" },
        },
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
    {
        -- https://github.com/svermeulen/vim-subversive
        "svermeulen/vim-subversive",
        lazy = true,
        keys = {
            { "gr" },
            { "gR" },
            { "grr" },
            { "grs" },
            { "grs", mode = "x" },
            { "grss" },
        },
        config = function()
            map("n", "gR", "<plug>(SubversiveSubstituteToEndOfLine)", {})
            map("n", "gr", "<plug>(SubversiveSubstitute)", {})
            map("n", "grr", "<plug>(SubversiveSubstituteLine)", {})
            map("n", "grs", "<plug>(SubversiveSubstituteRange)", {})
            map("x", "grs", "<plug>(SubversiveSubstituteRange)", {})
            map("n", "grss", "<plug>(SubversiveSubstituteWordRange)", {})
        end,
    },
    {
        -- https://github.com/junegunn/vim-easy-align
        "junegunn/vim-easy-align",
        lazy = true,
        keys = { { "<Plug>(EasyAlign)" }, { "<Plug>(EasyAlign)", mode = "x" } },
        init = function()
            map("x", "g=", "<Plug>(EasyAlign)", {})
            map("n", "g=", "<Plug>(EasyAlign)", {})
            map("n", "g/", "g=ip*|", {})
        end,
        config = function() end,
    },
    {
        -- https://github.com/tpope/vim-surround
        "tpope/vim-surround",
        lazy = true,
        keys = {
            { "ys" },
            { "yss" },
            { "ds" },
            { "cs" },
            { "S", mode = "v" },
        },
        config = function()
            vim.g.surround_no_insert_mappings = 1
        end,
    },
    {
        -- https://github.com/tpope/vim-repeat
        "tpope/vim-repeat",
    },
    {
        -- https://github.com/jceb/vim-textobj-uri
        "jceb/vim-textobj-uri",
        dependencies = {
            -- https://github.com/kana/vim-textobj-user
            "kana/vim-textobj-user",
        },
        -- lazy = false,
        -- keys = { { "go" } },
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
    },
    {
        -- https://github.com/vim-scripts/VisIncr
        "vim-scripts/VisIncr",
        lazy = true,
        cmd = { "I", "II" },
    },
    {
        -- https://github.com/mjbrownie/swapit
        "mjbrownie/swapit",
        dependencies = {
            {
                -- https://github.com/tpope/vim-speeddating
                "tpope/vim-speeddating",
                name = "speeddating",
                init = function()
                    local opts = { noremap = true, silent = true }
                    vim.g.speeddating_no_mappings = 1
                    map("n", "<Plug>SpeedDatingFallbackUp", "<C-a>", opts)
                    map("n", "<Plug>SpeedDatingFallbackDown", "<C-x>", opts)
                end,
            },
        },
        lazy = true,
        keys = {
            { "<Plug>SwapItFallbackIncrement" },
            { "<Plug>SwapItFallbackDecrement" },
            { "<C-a>" },
            { "<C-x>" },
            { "<C-t>" },
        },
        init = function(plugin)
            vim.fn["SwapWord"] = function(...)
                vim.fn["SwapWord"] = nil
                require("lazy").load({ plugins = { plugin } })
                return vim.fn["SwapWord"](...)
            end
        end,
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
    },
    -- {
    --     -- https://github.com/monaqa/dial.nvim
    --     "monaqa/dial.nvim",
    --     -- maybe a pluging to replace swapit with
    -- },
    -- {
    --     -- https://github.com/Ron89/thesaurus_query.vim
    --     "Ron89/thesaurus_query.vim",
    --     lazy = true,
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
    -- },
    {
        -- https://github.com/L3MON4D3/LuaSnip
        "L3MON4D3/LuaSnip",
        dependencies = {
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

            local ls = require("luasnip")
            local s = ls.snippet
            -- local sn = ls.snippet_node
            -- local t = ls.text_node
            -- local i = ls.insert_node
            local f = ls.function_node
            -- local c = ls.choice_node
            -- local d = ls.dynamic_node
            -- local r = ls.restore_node
            -- local l = require("luasnip.extras").lambda
            -- local rep = require("luasnip.extras").rep
            -- local p = require("luasnip.extras").partial
            -- local m = require("luasnip.extras").match
            -- local n = require("luasnip.extras").nonempty
            -- local dl = require("luasnip.extras").dynamic_lambda
            -- local fmt = require("luasnip.extras.fmt").fmt
            -- local fmta = require("luasnip.extras.fmt").fmta
            -- local types = require("luasnip.util.types")
            -- local conds = require("luasnip.extras.conditions")
            -- local conds_expand = require("luasnip.extras.conditions.expand")

            ls.add_snippets("all", {
                -- vi modline snippet
                s("vi", {
                    f(function(_, _, _)
                        return string.format(
                            vim.o.commentstring,
                            string.format(
                                "vi ft=%s:tw=%d:sw=%d:ts=%d:sts=%d:%s",
                                vim.o.filetype,
                                vim.o.textwidth,
                                vim.o.shiftwidth,
                                vim.o.tabstop,
                                vim.o.softtabstop,
                                vim.o.expandtab and "et" or "noet"
                            )
                        )
                    end, {}, { user_args = {} }),
                }),
            })

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
    },
    {
        -- https://github.com/dpelle/vim-LanguageTool
        "dpelle/vim-LanguageTool",
        lazy = true,
        cmd = { "LanguageToolCheck" },
        build = { "~/.config/nvim/download_LanguageTool.sh" },
        config = function()
            vim.cmd([[
                                let g:languagetool_jar=$HOME . '/.config/nvim/packer/opt/vim-LanguageTool/LanguageTool/languagetool-commandline.jar'
                                ]])
        end,
    },
    -- {
    --     -- https://github.com/ThePrimeagen/refactoring.nvim
    --     "ThePrimeagen/refactoring.nvim",
    --     lazy = true,
    --    dependencies = {
    --        -- https://github.com/nvim-lua/popup.nvim
    --        "nvim-lua/popup.nvim",
    --        -- https://github.com/nvim-lua/plenary.nvim
    --        "nvim-lua/plenary.nvim",
    --        -- https://github.com/nvim-treesitter/nvim-treesitter
    --        "nvim-treesitter/nvim-treesitter",
    --     },
    -- },
}
