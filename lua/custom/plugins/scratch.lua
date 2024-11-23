return {
  -- https://github.com/cenk1cenk2/scratch.nvim
  "cenk1cenk2/scratch.nvim",
  config = {
    vim.api.nvim_command([[
      command! -nargs=? Scratch :lua require("scratch").create({ filetype = <q-args> })
      ]]),
  },
}
