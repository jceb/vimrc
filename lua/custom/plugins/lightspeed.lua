local map = vim.keymap.set
return {
  -- https://github.com/ggandor/lightspeed.nvim
  "ggandor/lightspeed.nvim",
  init = function()
    map("n", "<leader>/", "/", { noremap = true })
    map("n", "<leader>?", "?", { noremap = true })
    map("n", "/", "<Plug>Lightspeed_s", {})
    map("n", "?", "<Plug>Lightspeed_S", {})
    map("x", "/", "<Plug>Lightspeed_x", {})
    map("x", "?", "<Plug>Lightspeed_X", {})
  end,
}
