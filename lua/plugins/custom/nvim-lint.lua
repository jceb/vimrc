return {
  -- https://github.com/mfussenegger/nvim-lint
  "mfussenegger/nvim-lint",
  config = function()
    vim.cmd([[
              au BufWritePost <buffer> lua require('lint').try_lint()
              au BufWritePost <buffer> markdown require('lint').try_lint()
              au BufWritePost <buffer> javascript,javascriptjsx require('lint').try_lint()
              au BufWritePost <buffer> typescript,typescriptjsx require('lint').try_lint()
              au BufWritePost <buffer> go require('lint').try_lint()
              au BufWritePost <buffer> html require('lint').try_lint()
          ]])
    require("lint").linters_by_ft = {
      asciidoc = { "value", "languagetool" },
      css = { "stylint" },
      dockerfile = { "hadolint" },
      go = { "golangcilint" },
      html = { "tidy", "stylint", "vale" },
      javascript = { "eslint" },
      javascriptjsx = { "eslint" },
      lua = { "luacheck" },
      markdown = { "stylint", "value", "languagetool" },
      nix = { "nix" },
      sh = { "shellcheck" },
      txt = { "languagetool" },
      typescript = { "eslint" },
      typescriptjsx = { "eslint" },
    }
  end,
}
