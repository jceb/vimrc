return {
  -- https://github.com/stevearc/conform.nvim
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
  end,
  opts = {
    -- see https://github.com/stevearc/conform.nvim?tab=readme-ov-file#options
    -- and https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
    formatters_by_ft = {
      -- see https://github.com/stevearc/conform.nvim/tree/master/lua/conform/formatters
      -- :h conform-formatter
      lua = { "stylua" },
      markdown = { "deno_fmt", "prettierd", "prettierd" },
      python = { "black", "yapf" },
      rust = { "rustfmt" },
      javascript = { "deno_fmt", "prettierd", "prettier", "eslint_d" },
      javascriptreact = { "deno_fmt", "prettierd", "prettier" },
      typescript = { "deno_fmt", "prettierd", "prettier" },
      typescriptreact = { "deno_fmt", "prettierd", "prettier" },
      json = { "deno_fmt", "prettierd", "prettierd" },
      css = { "prettierd", "prettier" },
      html = { "prettierd", "prettier" },
      yaml = { "prettierd", "prettier", "yamlfmt", "yq" },
      xml = { "xmllint", "xmlformat" },
      nix = { "nixfmt", "nixpkgs-fmt" },
      -- nu = { "nufmt" },
      sh = { "shellcheck" },
    },
    default_format_opts = {
      lsp_format = "fallback",
      stop_after_first = true,
    },
    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      local ignore_filetypes = {}
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match("/node_modules/") then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    format_after_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { lsp_format = "fallback" }
    end,
    -- Set the log level. Use `:ConformInfo` to see the location of the log file.
    log_level = vim.log.levels.ERROR,
    -- Conform will notify you when a formatter errors
    notify_on_error = true,
    -- Conform will notify you when no formatters are available for the buffer
    notify_no_formatters = true,
  },
}
