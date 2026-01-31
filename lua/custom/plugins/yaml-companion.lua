return {
  {
    -- https://github.com/mosheavni/yaml-companion.nvim
    "mosheavni/yaml-companion.nvim",
    ft = { "yaml" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function(_, opts)
      local cfg = require("yaml-companion").setup(opts)
      vim.lsp.config("yamlls", cfg)
      vim.lsp.enable("yamlls")
    end,
  },
}
