return {
  -- https://github.com/mg979/vim-visual-multi
  "mg979/vim-visual-multi",
  keys = {
    { "<M-j>" },
    { "<M-k>" },
    { "<M-c>" },
    { "<M-n>" },
    { "<M-n>", mode = "v" },
  },
  init = function()
    vim.g.VM_Mono_hl = "Substitute"
    vim.g.VM_Cursor_hl = "IncSearch"
    vim.g.VM_maps = {
      ["Find Under"] = "<M-n>",
      ["Find Subword Under"] = "<M-n>",
      ["Next"] = "n",
      ["Previous"] = "N",
      ["Skip"] = "q",
      ["Add Cursor Down"] = "<M-j>",
      ["Add Cursor Up"] = "<M-k>",
      ["Select l"] = "<S-Left>",
      ["Select r"] = "<S-Right>",
      ["Add Cursor At Pos"] = "<M-\\>",
      ["Select All"] = "<M-c>",
      ["Visual All"] = "<M-c>",
      -- ["Start Regex Search"] = "<C-/>",
      ["Start Regex Search"] = "",
      ["Reselect Last"] = "<M-z>",
      ["Exit"] = "<Esc>",
      ["Switch Mode"] = "<M-x>",
    }
    -- let g:VM_leader = {'default': '\', 'visual': '\', 'buffer': 'z'}
  end,
}
