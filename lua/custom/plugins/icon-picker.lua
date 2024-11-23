return {
  -- https://github.com/ziontee113/icon-picker.nvim
  "ziontee113/icon-picker.nvim",
  dependencies = {
    "stevearc/dressing.nvim",
  },
  config = function()
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>ci", "<cmd>PickIcons<cr>", opts)
    vim.keymap.set("n", "<leader>cs", "<cmd>PickAltFontAndSymbols<cr>", opts)
    -- vim.keymap.set("i", "<C-i>", "<cmd>PickIconsInsert<cr>", opts)
    -- vim.keymap.set("i", "<C-S-i>", "<cmd>PickAltFontAndSymbolsInsert<cr>", opts)
    vim.keymap.set("i", "<A-i>", "<cmd>PickIconsInsert<cr>", opts)
    vim.keymap.set("i", "<M-s>", "<cmd>PickAltFontAndSymbolsInsert<cr>", opts)

    require("icon-picker")
  end,
}
