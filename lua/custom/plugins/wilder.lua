return {
  -- https://github.com/gelguy/wilder.nvim
  "gelguy/wilder.nvim",
  config = function()
    vim.call("wilder#enable_cmdline_enter")
    vim.o.wildcharm = 9
    vim.keymap.set("c", "<Tab>", 'wilder#in_context() ? wilder#next() : "<Tab>"', { expr = true })
    vim.keymap.set("c", "<S-Tab>", 'wilder#in_context() ? wilder#previous() : "<S-Tab>"', { expr = true })
    -- only / and ? are enabled by default
    vim.call("wilder#set_option", "modes", { "/", "?", ":" })
  end,
}
