return {
  -- https://github.com/uga-rosa/ccc.nvim
  "uga-rosa/ccc.nvim",
  keys = { { "<leader>cc", "<cmd>CccPick<cr>" }, { "<C-S-c>", "<Plug>(ccc-insert)", mode = "i" } },
  config = function()
    -- local opts = { noremap = false, silent = true }
    -- vim.keymap.set("n", "<leader>cc", "<cmd>CccPick<cr>", opts)
    -- vim.keymap.set("i", "<C-S-c>", "<Plug>(ccc-insert)", opts)

    local ccc = require("ccc")
    -- local mapping = ccc.mapping
    ccc.setup({
      -- Your favorite settings
      highlighter = {
        auto_enable = true,
        filetypes = { "css" },
      },
      mappings = {
        -- Disable only 'q' (|ccc-action-quit|)
        -- q = mapping.none,
      },
    })
    -- vim.cmd([[hi FloatBorder guibg=NONE]])
  end,
}
