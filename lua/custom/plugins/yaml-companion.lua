return {
  {
    -- https://github.com/someone-stole-my-name/yaml-companion.nvim
    -- "someone-stole-my-name/yaml-companion.nvim",
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
      require("telescope").load_extension("yaml_schema")
    end,
  },
}
