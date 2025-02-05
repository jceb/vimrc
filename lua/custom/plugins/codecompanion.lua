return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          -- adapter = "anthropic",
          adapter = "gemini",
        },
        inline = {
          -- adapter = "anthropic",
          adapter = "gemini",
        },
      },
    })
    vim.keymap.set({ "n", "v" }, "<Leader>A", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<Leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd([[cab cc CodeCompanion]])
  end,
}
