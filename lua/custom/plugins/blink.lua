return {
  -- https://github.com/Saghen/blink.cmp
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = {
    -- https://github.com/jmbuhr/otter.nvim
    -- {
    --   "jmbuhr/otter.nvim",
    --   dependencies = {
    --     "nvim-treesitter/nvim-treesitter",
    --   },
    --   opts = {},
    --   init = function()
    --     vim.api.nvim_create_user_command("OtterActivate", function()
    --       require("otter").activate()
    --     end, {})
    --     vim.api.nvim_create_user_command("OtterDeactivate", function()
    --       require("otter").deactivate()
    --     end, {})
    --   end,
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

        -- vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
        -- vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})
        -- vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
        -- vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
        vim.api.nvim_set_keymap(
          "s",
          "<C-p>",
          "<cmd>lua local luasnip = require('luasnip'); if luasnip.choice_active() then luasnip.change_choice(-1) else vim.api.nvim_feedkeys('<C-p>', 'n', false) end<CR>",
          {}
        )
        vim.api.nvim_set_keymap(
          "i",
          "<C-p>",
          "<cmd>lua local luasnip = require('luasnip'); if luasnip.choice_active() then luasnip.change_choice(-1) else vim.api.nvim_feedkeys('<C-p>', 'n', false) end<CR>",
          {}
        )
        vim.api.nvim_set_keymap(
          "s",
          "<C-n>",
          "<cmd>lua local luasnip = require('luasnip'); if luasnip.choice_active() then luasnip.change_choice(1) else vim.api.nvim_feedkeys('<C-n>', 'n', false) end<CR>",
          {}
        )
        vim.api.nvim_set_keymap(
          "i",
          "<C-n>",
          "<cmd>lua local luasnip = require('luasnip'); if luasnip.choice_active() then luasnip.change_choice(1) else vim.api.nvim_feedkeys('<C-n>', 'n', false) end<CR>",
          {}
        )
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

  -- use a release tag to download pre-built binaries
  version = "*",
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-e: Hide menu
    -- C-k: Toggle signature help
    --
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = { preset = "default" },
    cmdline = {
      keymap = {
        -- see ../../../lazy/blink.cmp/lua/blink/cmp/keymap/presets.lua
        preset = "cmdline",
        -- disable blink keymap to make % expansion possible for eunuch / Move
        ["<Tab>"] = {},
        ["<S-Tab>"] = {},
        -- disable blink keymap in favor of rsi.vim
        -- ["<C-e>"] = {},
        ["<C-e>"] = { "cancel", "fallback" },
      },
    },
    snippets = { preset = "luasnip" },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      -- use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },
    completion = {
      menu = {
        -- Don't automatically show the completion menu
        auto_show = true,
      },
      -- documentation = { auto_show = false },
      -- ghost_text = { enabled = false },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
        "lazydev",
        "omni",
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
          score_offset = -1,
        },
      },
    },

    -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
