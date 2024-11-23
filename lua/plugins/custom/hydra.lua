return {
  -- https://github.com/anuvyklack/hydra.nvim
  "anuvyklack/hydra.nvim",
  config = function()
    local Hydra = require("hydra")
    -- local dap = require("dap")

    -- Hydra({
    --     name = "Debug",
    --     mode = { "n", "x" },
    --     body = "<leader>,",
    --     heads = {
    --         -- { "b", dap.toggle_breakpoint, { desc = "toggle breakpoint", silent = true } },
    --         -- { "c", dap.continue, { desc = "continue", silent = true } },
    --         -- { "i", dap.step_into, { desc = "step in", silent = true } },
    --         -- { "o", dap.step_out, { desc = "step out", silent = true } },
    --         -- { "q", dap.close, { desc = "quit hydra", exit = true } },
    --         -- { "r", dap.repl_open, { desc = "repl", silent = true } },
    --         -- { "R", dap.run_last, { desc = "run last" }, silent = true },
    --         -- { "s", dap.step_over, { desc = "step over", silent = true } },
    --         { "b", "<cmd>DapToggleBreakpoint<CR>", { desc = "toggle breakpoint", silent = true } },
    --         { "c", "<cmd>DapContinue<CR>", { desc = "continue", silent = true } },
    --         { "C", "<cmd>DapRerun<CR>", { desc = "run last" }, silent = true },
    --         { "i", "<cmd>DapStepInto<CR>", { desc = "step in", silent = true } },
    --         { "o", "<cmd>DapStepOut<CR>", { desc = "step out", silent = true } },
    --         { "q", "<cmd>DapStop<CR>", { desc = "quit hydra", exit = true } },
    --         { "r", "<cmd>DapToggleRepl<CR>", { desc = "repl", silent = true } },
    --         { "s", "<cmd>DapStepOver<CR>", { desc = "step over", silent = true } },
    --     },
    -- })
    Hydra({
      name = "Window",
      mode = "n",
      body = "<leader>w",
      heads = {
        { "h", "<C-w>h" },
        { "H", "<C-w>H" },
        { "j", "<C-w>j" },
        { "J", "<C-w>J" },
        { "k", "<C-w>k" },
        { "K", "<C-w>K" },
        { "l", "<C-w>l" },
        { "L", "<C-w>L" },
        { "p", "<C-w>p" },
        { "s", "<C-w>s", { desc = "hsplit" } },
        { ",", "gT", { desc = "prev pab" } },
        { ".", "gt", { desc = "next tab" } },
        { "v", "<C-w>v", { desc = "vsplit" } },
      },
    })
  end,
}
