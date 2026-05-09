return {
  -- https://github.com/ggandor/lightspeed.nvim
  "ggandor/lightspeed.nvim",
  init = function()
    vim.keymap.set("n", "<leader>/", "/", { noremap = true })
    vim.keymap.set("n", "<leader>?", "?", { noremap = true })
    vim.keymap.set("n", "/", "<Plug>Lightspeed_s", {})
    vim.keymap.set("n", "?", "<Plug>Lightspeed_S", {})
    vim.keymap.set("x", "/", "<Plug>Lightspeed_x", {})
    vim.keymap.set("x", "?", "<Plug>Lightspeed_X", {})
  end,
}
