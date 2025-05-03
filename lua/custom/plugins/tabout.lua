return {
  -- https://github.com/abecodes/tabout.nvim
  "abecodes/tabout.nvim",
  -- keys = {{'<C-j>', mode = 'i' }},
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "L3MON4D3/LuaSnip",
    -- "hrsh7th/nvim-cmp"
  }, -- or require if not used so far
  opt = true, -- Set this to true if the plugin is optional
  event = "InsertCharPre", -- Set the event to 'InsertCharPre' for better compatibility
  priority = 1000,
  config = function()
    require("tabout").setup({
      tabkey = "", -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = "", -- key to trigger backwards tabout, set to an empty string to disable
      act_as_tab = false, -- shift content if tab out is not possible
      act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
      enable_backwards = true, -- well ...
      completion = false, -- if the tabkey is used in a completion pum
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "<", close = ">" },
      },
      ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
      exclude = {}, -- tabout will ignore these filetypes
    })
  end,
}
