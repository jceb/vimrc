return {
  -- https://github.com/jceb/jiejie.git
  "jceb/jiejie.nvim",
  -- ft = {
  --   "jiejie",
  -- },
  -- cmd = {
  --   "J",
  --   "Jj",
  --   "Jedit",
  -- },
  -- keys = {
  --   "<leader>yy",
  --   "<leader>ye",
  --   "<leader>yt",
  -- },
  opts = {
    excluded_revset = 'bookmarks(glob:"renovate/*") | tracked_remote_bookmarks(glob:"renovate/*") | untracked_remote_bookmarks(glob:"renovate/*")',
    default_view = 1,
    -- dynamic_views = { {
    --   revset = "@",
    -- } },
    log_revisions = 10,
  },
  init = function()
    vim.keymap.set("n", "<leader>yy", "<cmd>vertical Jj<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>ye", "<cmd>Jedit<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>yt", "<cmd>Jj tug<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>yr", "<cmd>Jj rm<CR>", { noremap = true })
  end,
}
