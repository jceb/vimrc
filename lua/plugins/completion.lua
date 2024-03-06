map = vim.keymap.set
unmap = vim.keymap.unset

return {
  ----------------------
  -- completion
  ----------------------
  -- {
  --     -- https://github.com/gelguy/wilder.nvim
  --     "gelguy/wilder.nvim",
  --     config = function()
  --         vim.call("wilder#enable_cmdline_enter")
  --         vim.o.wildcharm = 9
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
  -- },
  -- {
  --     -- https://github.com/neoclide/coc.nvim
  --     "neoclide/coc.nvim",
  --     build = "npm run build",
  --     cmd = "CocUpdate",
  -- },
  -- {
  --     -- https://github.com/rcarriga/nvim-dap-ui
  --     "rcarriga/nvim-dap-ui",
  --     dependencies = {
  --         -- https://github.com/mfussenegger/nvim-dap
  --         "mfussenegger/nvim-dap",
  --         -- https://github.com/leoluz/nvim-dap-go
  --         "leoluz/nvim-dap-go",
  --     },
  --     config = function()
  --         -- Adapter installation: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
  --         -- Adapters are the basis of the debugging experience - it connects
  --         -- to the debugger
  --         local dap = require("dap")
  --         local dapui = require("dapui")
  --         require("dap-go").setup()
  --         dap.adapters.rustgdb = {
  --             type = "executable",
  --             command = vim.fn.resolve(vim.fn.exepath("rust-gdb")), -- adjust as needed, must be absolute path
  --             name = "rustgdb",
  --         }
  --         dap.adapters.lldb = {
  --             type = "executable",
  --             command = vim.fn.resolve(vim.fn.exepath("lldb-vscode")), -- adjust as needed, must be absolute path
  --             name = "lldb",
  --         }
  --         -- dap.adapters.rust = { dap.adapters.rustgdb, dap.adapters.lldb } -- convenience functions for sepecifying custom launch.json configurations
  --         dap.adapters.rust = dap.adapters.lldb -- convenience functions for sepecifying custom launch.json configurations
  --         dap.adapters.c = dap.adapters.lldb -- convenience functions for sepecifying custom launch.json configurations
  --         dap.adapters.cpp = dap.adapters.lldb -- convenience functions for sepecifying custom launch.json configurations
  --         -- Configurations are user facing, they define the parameters that
  --         -- are passed to the adapters
  --         -- For special purposes custom debug configurations can be loaded
  --         dap.configurations.cpp = {
  --             {
  --                 name = "Launch",
  --                 type = "lldb",
  --                 request = "launch",
  --                 program = function()
  --                     return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
  --                 end,
  --                 args = function()
  --                     local input = vim.trim(vim.fn.input("Arguments (leave empty for no arguments): ", "", "file"))
  --                     if input == "" then
  --                         return {}
  --                     else
  --                         return vim.split(input, " ")
  --                     end
  --                 end,
  --                 -- args = {},
  --                 cwd = "${workspaceFolder}",
  --                 stopOnEntry = false,
  --             },
  --         }
  --         dap.configurations.c = dap.configurations.cpp
  --         dap.configurations.rust = dap.configurations.cpp
  --
  --         -- Installation instructions: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript-firefox
  --         dap.adapters.firefox = {
  --             type = "executable",
  --             command = "node",
  --             args = { os.getenv("HOME") .. "/Documents/Software/vscode-firefox-debug/dist/adapter.bundle.js" },
  --         }
  --
  --         dap.configurations.typescript = {
  --             name = "Debug with Firefox",
  --             type = "firefox",
  --             request = "launch",
  --             reAttach = true,
  --             url = "http://localhost:3000",
  --             webRoot = "${workspaceFolder}",
  --             firefoxExecutable = os.getenv("HOME") .. "/.local/firefox/firefox",
  --         }
  --         dapui.setup()
  --         -- automatically open the UI upon DAP events
  --         dap.listeners.after.event_initialized["dapui_config"] = function()
  --             dapui.open()
  --         end
  --         dap.listeners.before.event_terminated["dapui_config"] = function()
  --             dapui.close()
  --         end
  --         dap.listeners.before.event_exited["dapui_config"] = function()
  --             dapui.close()
  --         end
  --         vim.api.nvim_create_user_command("DapuiOpen", 'lua require("dapui").open()', {})
  --         vim.api.nvim_create_user_command("DapuiClose", 'lua require("dapui").close()', {})
  --         vim.api.nvim_create_user_command("DapuiToggle", 'lua require("dapui").toggle()', {})
  --         vim.api.nvim_create_user_command("DapuiEval", 'lua require("dapui").eval()', {})
  --     end,
  -- },
  -- {
  --     -- https://github.com/alexaandru/nvim-lspupdate
  --     "alexaandru/nvim-lspupdate",
  --     lazy = true,
  --     cmd = { "LspUpdate" },
  -- },
  -- {
  --   -- https://github.com/pmizio/typescript-tools.nvim
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", },
  --   opts = {},
  -- },
  {
    -- https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      -- "williamboman/mason.nvim",
      -- "williamboman/mason-lspconfig.nvim",
      -- "WhoIsSethDaniel/mason-tool-installer.nvim",
      {
        -- https://github.com/lukas-reineke/lsp-format.nvim
        -- "lukas-reineke/lsp-format.nvim",
        "jceb/lsp-format.nvim",
        branch = "feat/toggle-per-buffer",
        config = function()
          require("lsp-format").setup({})
        end,
      },
      {
        -- https://github.com/nvimtools/none-ls.nvim
        "nvimtools/none-ls.nvim",
      },
      {
        -- https://github.com/mrcjkb/rustaceanvim
        "mrcjkb/rustaceanvim",
      },
    },
    -- add more language servers: https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
    -- build = {
    --   -- { "npm i -g ls_emmet" },
    --   -- "go install github.com/mattn/efm-langserver@latest",
    --   -- "npm -g install yaml-language-server vscode-langservers-extracted vim-language-server typescript-language-server typescript pyright prettier open-cli ls_emmet dockerfile-language-server-nodejs bash-language-server"
    --   -- "npm -g install @olrtg/emmet-language-server @astrojs/language-server unocss-language-server @mdx-js/language-service"
    -- },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          -- NOTE: Remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself
          -- many times.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-T>.
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("g?", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>fs", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          map("<leader>fS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map("K", vim.lsp.buf.hover, "Hover Documentation")

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- See also https://sharksforarms.dev/posts/neovim-rust/
      vim.g.rustaceanvim = {
        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
        server = {
          -- on_attach is a callback called when the language server attachs to the buffer
          -- on_attach = custom_lsp_attach,
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

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      local lspconfig = require("lspconfig")
      local null_ls = require("null-ls")
      local lsp_format = require("lsp-format").on_attach

      null_ls.setup({
        capabilities = capabilities,
        on_attach = lsp_format,
        sources = {
          -- list of sources: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
          -- null_ls.builtins.formatting.remark,
          null_ls.builtins.formatting.black.with({ filetypes = { "python" } }),
          null_ls.builtins.formatting.clang_format.with({
            filetypes = { "c", "cpp", "cs", "java", "cuda", "proto" },
          }),
          -- null_ls.builtins.formatting.rome.with({}),
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.just,
          null_ls.builtins.formatting.nixfmt,
          null_ls.builtins.formatting.prettier.with({
            filetypes = { "html", "yaml", "css", "scss", "less", "graphql", "astro" },
          }),
          null_ls.builtins.formatting.shfmt,
          -- null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.terraform_fmt, -- maybe not needed
          -- null_ls.builtins.formatting.xmllint.with({
          --     filetypes = { "xml", "svg" },
          -- }),
          -- null_ls.builtins.formatting.xmlformat,
          -- null_ls.builtins.formatting.yamlfmt, -- too simple, unfortunately
          -- null_ls.builtins.formatting.shellcheck,
        },
      })

      local servers = {
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- ["typescirpt-tools"] = {},
        tsserver = {},
        -- biome = { single_file_support = true },
        marksman = {},
        -- mdx_analyzer = {},
        -- pyright = {},
        -- provided by rust-tools:
        -- rust_analyzer = {},
        -- svelte = {},
        ansiblels = {},
        astro = {},
        bashls = {},
        clangd = {},
        cssls = {},
        -- denols = {
        --   -- filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "markdown", "json", "jsonc" },
        --   filetypes = { "markdown", "json", "jsonc" },
        -- },
        dockerls = {},
        emmet_language_server = {},
        gopls = {},
        helm_ls = {},
        html = {},
        lemminx = {},
        nickel_ls = {},
        pyright = {},
        taplo = {},
        terraformls = {},
        unocss = {},
        vimls = {},
        yamlls = {},
        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your neovim configuration.
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
                -- If lua_ls is really slow on your computer, you can try this instead:
                -- library = { vim.env.VIMRUNTIME },
              },
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                enable = false,
              },
            },
          },
        },
      }
      for server, config in pairs(servers) do
        lspconfig[server].setup(vim.tbl_deep_extend("force", {
          on_attach = lsp_format,
          capabilities = capabilities,
        }, config))
      end
    end,
  },
  {
    -- https://github.com/hrsh7th/nvim-cmp
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
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
      -- "octaltree/cmp-look",
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
              nvim_lua = "[api]",
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
          { name = "buffer",  keyword_length = 2 },
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
  },
}
