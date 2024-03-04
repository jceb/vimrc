map = vim.keymap.set
unmap = vim.keymap.unset

return {
  ----------------------
  -- buffer management
  ----------------------
  {
    -- https://github.com/mhinz/vim-sayonara
    "mhinz/vim-sayonara",
    lazy = true,
    cmd = { "Sayonara" },
    keys = {
      "<leader>D",
      "<leader>d",
      "<leader>bd",
    },
    config = function()
      map("n", "<leader>D", "<cmd>Sayonara!<CR>", { noremap = true })
      map("n", "<leader>d", "<cmd>Sayonara<CR>", { noremap = true })
      map("n", "<leader>bd", "<cmd>Sayonara!<CR>", { noremap = true })
    end
  },
  -- {
  --     -- replacement for saynara?
  --     -- https://github.com/famiu/bufdelete.nvim
  --     "famiu/bufdelete.nvim",
  --     lazy = true,
  --     cmd = { "Bdelete", "Bwipeout" },
  -- },
  {
    -- https://github.com/troydm/easybuffer.vim
    "troydm/easybuffer.vim",
    lazy = true,
    cmd = { "EasyBufferBotRight" },
    config = function()
      vim.g.easybuffer_chars = {
        "a",
        "s",
        "f",
        "i",
        "w",
        "e",
        "z",
        "c",
        "v",
      }
    end,
  },
  -- {
  --     -- https://github.com/matbme/JABS.nvim
  --     "matbme/JABS.nvim",
  --     lazy = true,
  --     cmd = { "JABSOpen" },
  --     config = function()
  --         require("jabs").setup({
  --             width = 100,
  --             height = 20,
  --         })
  --     end,
  -- },
  -- {
  --     -- https://github.com/tpope/vim-projectionist
  --     "tpope/vim-projectionist",
  --     lazy = true,
  -- },
}
