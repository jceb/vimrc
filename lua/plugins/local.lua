map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  ----------------------
  -- local plugins
  ----------------------
  {
    name = "debchangelog",
    dir = vim.fn.stdpath("config") .. "/local-plugins/debchangelog",
    lazy = true,
    ft = { "debchangelog" },
  },
  {
    name = "myconfig",
    dir = vim.fn.stdpath("config") .. "/local-plugins/myconfig",
  },
  {
    name = "pydoc910",
    dir = vim.fn.stdpath("config") .. "/local-plugins/pydoc910",
    lazy = true,
    ft = { "python" },
  },
  {
    name = "rfc",
    dir = vim.fn.stdpath("config") .. "/local-plugins/rfc",
    lazy = true,
    ft = { "rfc" },
  },
  {
    name = "dotenv",
    dir = vim.fn.stdpath("config") .. "/local-plugins/dotenv",
  },
  {
    name = "serif",
    dir = vim.fn.stdpath("config") .. "/local-plugins/serif",
  },
}
