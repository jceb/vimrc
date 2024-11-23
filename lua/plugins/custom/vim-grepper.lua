return {
  -- https://github.com/mhinz/vim-grepper
  "mhinz/vim-grepper",
  cmd = { "Grepper" },
  cmd = { "Grep" },
  keys = {
    { "gs", "<plug>(GrepperOperator)" },
    { "gs", "<plug>(GrepperOperator)", mode = "x" },
    { "<leader>gg", "<cmd>Grepper -tool git<CR>" },
    { "<leader>pG", "<cmd>Grepper -dir repo,cwd<CR>" },
  },
  init = function()
    vim.g.grepper = {
      tools = { "rg", "grep", "git" },
      repo = { "git" },
      dir = "filecwd,cwd,repo",
    }
  end,
  config = function()
    vim.cmd([[
        command! Todo Grepper -noprompt -tool git -query -E '(TODO|FIXME|XXX):'
        command! -nargs=1 Grep Grepper -noprompt -query <q-args>
      ]])
  end,
}
