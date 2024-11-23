return {
  -- https://github.com/gbprod/substitute.nvim
  "gbprod/substitute.nvim",
  dependencies = {
    -- https://github.com/gbprod/yanky.nvim
    "gbprod/yanky.nvim",
  },
  keys = {
    "gr",
    "grr",
    "gR",
    "gr",
  },
  config = function()
    vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "MatchParen" })
    vim.api.nvim_set_hl(0, "SubstituteRange", { link = "MatchParen" })
    vim.api.nvim_set_hl(0, "SubstituteExchange", { link = "MatchParen" })
    require("substitute").setup({
      on_substitute = require("yanky.integration").substitute(),
      yank_substituted_text = false,
      preserve_cursor_position = false,
      modifiers = nil,
      highlight_substituted_text = {
        enabled = true,
        timer = 500,
      },
      range = {
        prefix = "s",
        prompt_current_text = false,
        confirm = false,
        complete_word = false,
        subject = nil,
        range = nil,
        suffix = "",
        auto_apply = false,
        cursor_position = "end",
      },
      exchange = {
        motion = false,
        use_esc_to_cancel = true,
        preserve_cursor_position = false,
      },
    })
    vim.keymap.set("n", "gr", require("substitute").operator, { noremap = true })
    vim.keymap.set("n", "grr", require("substitute").line, { noremap = true })
    vim.keymap.set("n", "gR", require("substitute").eol, { noremap = true })
    vim.keymap.set("x", "gr", require("substitute").visual, { noremap = true })
  end,
}
