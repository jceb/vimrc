return {
  -- https://github.com/stevearc/oil.nvim
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Oil" },
  keys = { "-" },
  config = function()
    require("oil").setup({
      view_options = {
        show_hidden = true,
      },
    })
    vim.keymap.set("n", "-", ":Oil<CR>", {})
  end,
}
