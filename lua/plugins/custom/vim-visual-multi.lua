return {
  -- https://github.com/mg979/vim-visual-multi
  "mg979/vim-visual-multi",
  keys = {
    { "<C-j>" },
    { "<C-k>" },
    { "<C-c>" },
    { "<C-n>" },
    { "<C-n>", mode = "v" },
  },
  init = function()
    vim.g.VM_Mono_hl = "Substitute"
    vim.g.VM_Cursor_hl = "IncSearch"
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      ["Next"] = "n",
      ["Previous"] = "N",
      ["Skip"] = "q",
      ["Add Cursor Down"] = "<C-j>",
      ["Add Cursor Up"] = "<C-k>",
      ["Select l"] = "<S-Left>",
      ["Select r"] = "<S-Right>",
      ["Add Cursor at Position"] = [[\\\]],
      ["Select All"] = "<C-c>",
      ["Visual All"] = "<C-c>",
      -- ["Start Regex Search"] = "<C-/>",
      ["Exit"] = "<Esc>",
      ["Switch Mode"] = "<C-o>",
    }
    -- let g:VM_leader = {'default': '\', 'visual': '\', 'buffer': 'z'}
  end,
}
