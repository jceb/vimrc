return {
  -- https://github.com/hrsh7th/nvim-cmp
  -- "hrsh7th/nvim-cmp",
  -- https://github.com/iguanacucumber/magazine.nvim
  "iguanacucumber/magazine.nvim",
  name = "nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- https://github.com/f3fora/cmp-spell
    -- "f3fora/cmp-spell",
    -- https://github.com/hrsh7th/cmp-buffer
    "hrsh7th/cmp-buffer",
    -- https://github.com/petertriho/cmp-git
    "petertriho/cmp-git",
    -- https://github.com/hrsh7th/cmp-calc
    -- "hrsh7th/cmp-calc",
    -- https://github.com/hrsh7th/cmp-emoji
    -- "hrsh7th/cmp-emoji",
    -- https://github.com/hrsh7th/cmp-nvim-lsp
    "hrsh7th/cmp-nvim-lsp",
    -- https://github.com/hrsh7th/cmp-nvim-lua
    -- "hrsh7th/cmp-nvim-lua",
    -- https://github.com/hrsh7th/cmp-cmdline
    "hrsh7th/cmp-cmdline",
    -- https://github.com/hrsh7th/cmp-path
    "hrsh7th/cmp-path",
    -- https://github.com/lukas-reineke/cmp-rg
    -- "lukas-reineke/cmp-rg",
    -- https://github.com/octaltree/cmp-look
    -- "octaltree/cmp-look",
    -- https://github.com/onsails/lspkind-nvim
    "onsails/lspkind-nvim",
    -- https://github.com/petertriho/cmp-git
    -- "petertriho/cmp-git",
    -- https://github.com/saadparwaiz1/cmp_luasnip
    "saadparwaiz1/cmp_luasnip",
    -- https://github.com/tjdevries/complextras.nvim
    -- "tjdevries/complextras.nvim",
    -- https://github.com/uga-rosa/cmp-dictionary
    -- "uga-rosa/cmp-dictionary",
    -- https://github.com/windwp/nvim-autopairs
    -- "windwp/nvim-autopairs",
    -- https://github.com/jmbuhr/otter.nvim
    "jmbuhr/otter.nvim",
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
                  "vi: ft=%s:tw=%d:sw=%d:ts=%d:sts=%d:%s",
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
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("o<C-G>", true, false, true), "n", true)
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

        _G.jump_extend = function()
          if ls.expand_or_jumpable() then
            -- if ls.expand_or_locally_jumpable() then
            return t("<cmd>lua require'luasnip'.expand_or_jump()<Cr>")
            -- return ls.expand_or_jump()
          else
            return t("<Plug>(Tabout)")
          end
        end

        _G.s_jump_extend = function()
          if ls.jumpable() then
            return t("<cmd>lua require'luasnip'.jump(-1)<Cr>")
            -- return ls.jump(-1)
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
            git = "[git]",
            -- nvim_lua = "[api]",
            path = "[path]",
            luasnip = "[snip]",
          },
        }),
      },
      mapping = cmp.mapping.preset.insert({
        -- Select the [n]ext item
        ["<C-n>"] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ["<C-p>"] = cmp.mapping.select_prev_item(),

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ["<C-y>"] = cmp.mapping.confirm({
          --     behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
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
        ["<c-.>"] = cmp.mapping.complete(),
        -- ["<CR>"] = cmp.mapping.complete({ select = true }),
      }),
      sources = {
        { name = "buffer", keyword_length = 3 },
        -- { name = "calc" },
        -- { name = "cmp_git" },
        -- { name = "dictionary", keyword_length = 2 },
        -- { name = "emoji" },
        -- {
        --     name = "look",
        --     keyword_length = 4,
        --     optoins = { convert_case = true, loud = true },
        -- },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        -- { name = "nvim_lua" },
        { name = "path" },
        -- { name = "rg" },
        -- { name = "spell", keyword_length = 4, },
        { name = "otter" },
        {
          name = "lazydev",
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        },
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      experimental = {
        -- I like the new menu better! Nice work hrsh7th
        -- native_menu = false,

        -- Let's play with this for a day or two
        -- ghost_text = true,
      },
      window = {},
    })

    -- cmp.event:on(
    --     "confirm_done",
    --     cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })
    -- )

    -- -- Set configuration for specific filetype.
    -- cmp.setup.filetype('gitcommit', {
    --   sources = cmp.config.sources({
    --     { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    --     { name = "buffer", keyword_length = 3 },
    --     { name = 'luasnip' },
    --   })
    -- })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    -- cmp.setup.cmdline("/", {
    --     mapping = cmp.mapping.preset.cmdline(),
    --     sources = {
    --         { name = "buffer" },
    --     },
    -- })

    -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    -- cmp.setup.cmdline(":", {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = cmp.config.sources({
    --     { name = "path" },
    --     { name = "cmdline" },
    --     { name = 'luasnip' },
    --   }),
    -- })
  end,
}
