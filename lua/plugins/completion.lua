map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

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
    {
        -- https://github.com/neovim/nvim-lspconfig
        "neovim/nvim-lspconfig",
        dependencies = {
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
        build = {
            -- { "npm i -g ls_emmet" },
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
                    -- null_ls.builtins.formatting.rome.with({}),
                    null_ls.builtins.formatting.gofumpt,
                    null_ls.builtins.formatting.just,
                    null_ls.builtins.formatting.nixfmt,
                    null_ls.builtins.formatting.prettier.with({
                        filetypes = { "html", "yaml", "css", "scss", "less", "graphql", "astro" },
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
                    null_ls.builtins.formatting.xmllint.with({
                        filetypes = { "xml", "svg" },
                    }),
                    -- null_ls.builtins.formatting.xmlformat,
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
            lspconfig.denols.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            }) -- best suited for deno code as the imports don't support simple names without a map
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
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        -- runtime = {
                        --     -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        --     version = "LuaJIT",
                        --     -- Setup your lua path
                        --     path = runtime_path,
                        -- },
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
            -- provided by rust-tools:
            -- lspconfig.rust_analyzer.setup({
            --     capabilities = capabilities,
            --     on_attach = custom_lsp_attach,
            -- })
            -- lspconfig.svelte.setup({
            --     capabilities = capabilities,
            --     on_attach = custom_lsp_attach,
            -- })
            lspconfig.terraformls.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            -- lspconfig.tsserver.setup({
            --     capabilities = capabilities,
            --     on_attach = custom_lsp_attach,
            -- })
            lspconfig.vimls.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            -- lspconfig.vuels.setup({ capabilities = capabilities,on_attach = custom_lsp_attach, })
            lspconfig.yamlls.setup({
                capabilities = capabilities,
                on_attach = custom_lsp_attach,
            })
            -- lspconfig.ls_emmet.setup({
            --     capabilities = capabilities,
            --     on_attach = custom_lsp_attach,
            -- })
        end,
    },
    {
        -- https://github.com/hrsh7th/nvim-cmp
        "hrsh7th/nvim-cmp",
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
    },
}
