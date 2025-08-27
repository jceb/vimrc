local map = vim.keymap.set
return {
  -- https://github.com/neovim/nvim-lspconfig
  "neovim/nvim-lspconfig",
  dependencies = {
    -- https://github.com/Saghen/blink.cmp
    "saghen/blink.cmp",
    -- Automatically install LSPs and related tools to stdpath for neovim
    -- "williamboman/mason.nvim",
    -- "williamboman/mason-lspconfig.nvim",
    -- "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- {
    --   -- https://github.com/lukas-reineke/lsp-format.nvim
    --   -- "lukas-reineke/lsp-format.nvim",
    --   "jceb/lsp-format.nvim",
    --   branch = "feat/toggle-per-buffer",
    --   config = function()
    --     require("lsp-format").setup({})
    --   end,
    -- },
    -- -- https://github.com/nvimtools/none-ls.nvim
    -- "nvimtools/none-ls.nvim",
    -- https://github.com/mrcjkb/rustaceanvim
    "mrcjkb/rustaceanvim",
    -- https://github.com/SmiteshP/nvim-navic
    "SmiteshP/nvim-navic",
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
        if client:supports_method("textDocument/completion") then
          -- Set enstable additional LSP auto completion feature
          if vim.lsp.completion ~= nil then
            vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = false })
          end
        end
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

    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
    local lspconfig = require("lspconfig")
    -- local null_ls = require("null-ls")
    -- local lsp_format = require("lsp-format").on_attach
    local navic = require("nvim-navic")
    local extension_attach = function(client, bufnr)
      -- if client.supports_method("format") then
      --   lsp_format(client, bufnr)
      -- end
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end
    end

    -- See also https://sharksforarms.dev/posts/neovim-rust/
    vim.g.rustaceanvim = {
      -- all the opts to send to nvim-lspconfig
      -- these override the defaults set by rust-tools.nvim
      -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#rust_analyzer
      server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = extension_attach,
        settings = {
          -- to enable rust-analyzer settings visit:
          -- https://github.com/rust-lang/rust-analyzer/blob/master/docs/book/src/configuration_generated.md
          ["rust-analyzer"] = {
            -- enable clippy on save, instead of standard check
            check = {
              command = "clippy",
            },
          },
        },
      },
      -- dap = {}, -- the confiugration is done as part of the dap configuration
    }

    -- null_ls.setup({
    --   capabilities = capabilities,
    --   on_attach = lsp_format,
    --   -- on_attach = extension_attach,
    --   sources = {
    --     -- list of sources: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    --     -- null_ls.builtins.formatting.remark,
    --     null_ls.builtins.formatting.black.with({ filetypes = { "python" } }),
    --     null_ls.builtins.formatting.clang_format.with({
    --       filetypes = { "c", "cpp", "cs", "java", "cuda", "proto" },
    --     }),
    --     -- null_ls.builtins.formatting.rome.with({}),
    --     null_ls.builtins.formatting.gofumpt,
    --     null_ls.builtins.formatting.just,
    --     -- null_ls.builtins.formatting.nixfmt,
    --     null_ls.builtins.formatting.prettier.with({
    --       filetypes = {
    --         "json",
    --         "astro",
    --         "css",
    --         "graphql",
    --         "html",
    --         "less",
    --         "markdown",
    --         "scss",
    --         "yaml",
    --       },
    --     }),
    --     null_ls.builtins.formatting.shfmt,
    --     -- null_ls.builtins.formatting.stylua,
    --     null_ls.builtins.formatting.terraform_fmt, -- maybe not needed
    --     -- null_ls.builtins.formatting.xmllint.with({
    --     --     filetypes = { "xml", "svg" },
    --     -- }),
    --     -- null_ls.builtins.formatting.xmlformat,
    --     -- null_ls.builtins.formatting.yamlfmt, -- too simple, unfortunately
    --     -- null_ls.builtins.formatting.shellcheck,
    --   },
    -- })

    local servers = {
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      -- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/configs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`tsserver`) will work just fine
      -- ["typescirpt-tools"] = {},
      -- ts_ls = {},
      -- biome = { single_file_support = true },
      marksman = {},
      -- mdx_analyzer = {},
      -- pyright = {},
      -- provided by rust-tools:
      -- rust_analyzer = {},
      -- svelte = {},
      ansiblels = {},
      astro = {},
      bashls = {
        filetypes = {
          "sh",
        },
      },
      clangd = {},
      harper_ls = {
        -- https://github.com/elijah-potter/harper/tree/master/harper-ls
        filetypes = {
          -- "markdown",
          "gitcommit",
          -- "asciidoc",
          -- "org",
        },
      },
      cssls = {},
      -- jsonls = {},
      -- biome = {},
      denols = {
        -- Deno doesn't support formatting for JS https://docs.deno.com/runtime/reference/lsp_integration/#language-ids
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          -- "markdown",
          "json",
          "jsonc",
        },
        init_options = {
          lint = true,
          unstable = true,
        },
        root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc", "package.json"),
      },
      dockerls = {},
      -- emmet_language_server = {},
      eslint = {},
      -- dartls = {},
      gopls = {},
      -- tflint = {},
      helm_ls = {},
      html = {},
      lemminx = {},
      -- nickel_ls = {},
      nushell = {},
      pyright = {},
      taplo = {},
      terraformls = {},
      -- unocss = {},
      nixd = {},
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
      -- integration with nvim-ufo
      config.capabilities = config.capabilities and config.capabilities or {}
      config.capabilities.textDocument = config.capabilities.textDocument and config.capabilities.textDocument or {}
      config.capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local opts = {
        on_attach = extension_attach,
        capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities),
        -- capabilities = capabilities,
      }
      -- Nushell doesn't support navic. Therefore, to avoid a navic error, attach lsp_format format directly
      -- if vim.tbl_contains({ "nushell", "eslint", "unocss" }, server) then
      --   opts.on_attach = lsp_format
      -- end
      lspconfig[server].setup(vim.tbl_deep_extend("force", opts, config))
    end
  end,
}
