return {
  -- https://github.com/romgrk/barbar.nvim
  "romgrk/barbar.nvim",
  dependencies = {
    -- https://github.com/nvim-tree/nvim-web-devicons
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- check out https://github.com/akinsho/nvim-bufferline.lua if not satisfied
    -- with barbar
    vim.g.bufferline = {
      icon_pinned = "車",
      exclude_ft = { "dirvish" },
    }

    local opts = { noremap = true, silent = true }

    -- Tab movement
    vim.keymap.set("n", "<M-h>", "gT", opts)
    vim.keymap.set("n", "<M-S-h>", "<cmd>tabmove -<CR>", opts)
    vim.keymap.set("n", "<M-l>", "gt", opts)
    vim.keymap.set("n", "<M-S-l>", "<cmd>tabmove +<CR>", opts)
    vim.keymap.set("n", "<M-C-1>", "1gt", opts)
    vim.keymap.set("n", "<M-C-2>", "2gt", opts)
    vim.keymap.set("n", "<M-C-3>", "3gt", opts)
    vim.keymap.set("n", "<M-C-4>", "4gt", opts)
    vim.keymap.set("n", "<M-C-5>", "5gt", opts)
    vim.keymap.set("n", "<M-C-6>", "6gt", opts)
    vim.keymap.set("n", "<M-C-7>", "7gt", opts)
    vim.keymap.set("n", "<M-C-8>", "8gt", opts)
    vim.keymap.set("n", "<M-C-9>", "9gt", opts)

    -- Move to previous/next
    vim.keymap.set("n", "<A-,>", ":BufferPrevious<CR>", opts)
    vim.keymap.set("n", "<A-.>", ":BufferNext<CR>", opts)
    -- Re-order to previous/next
    vim.keymap.set("n", "<A-<>", ":BufferMovePrevious<CR>", opts)
    vim.keymap.set("n", "<A->>", " :BufferMoveNext<CR>", opts)
    -- Goto buffer in position...
    vim.keymap.set("n", "<A-1>", ":BufferGoto 1<CR>", opts)
    vim.keymap.set("n", "<A-2>", ":BufferGoto 2<CR>", opts)
    vim.keymap.set("n", "<A-3>", ":BufferGoto 3<CR>", opts)
    vim.keymap.set("n", "<A-4>", ":BufferGoto 4<CR>", opts)
    vim.keymap.set("n", "<A-5>", ":BufferGoto 5<CR>", opts)
    vim.keymap.set("n", "<A-6>", ":BufferGoto 6<CR>", opts)
    vim.keymap.set("n", "<A-7>", ":BufferGoto 7<CR>", opts)
    vim.keymap.set("n", "<A-8>", ":BufferGoto 8<CR>", opts)
    vim.keymap.set("n", "<A-9>", ":BufferGoto 9<CR>", opts)
    vim.keymap.set("n", "<A-0>", ":BufferLast<CR>", opts)
    -- Pin/unpin buffer
    vim.keymap.set("n", "<A-b>", ":BufferPin<CR>", opts)
    -- Close buffer
    vim.keymap.set("n", "<A-c>", ":BufferClose<CR>", opts)
    -- Wipeout buffer
    --                 :BufferWipeout<CR>
    -- Close commands
    --                 :BufferCloseAllButCurrent<CR>
    --                 :BufferCloseBuffersLeft<CR>
    --                 :BufferCloseBuffersRight<CR>
    -- Magic buffer-picking mode
    vim.keymap.set("n", "<C-s>", ":BufferPick<CR>", opts)
  end,
}
