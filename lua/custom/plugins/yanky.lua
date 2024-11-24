return {
  -- https://github.com/gbprod/yanky.nvim
  "gbprod/yanky.nvim",
  opts = function()
    return {
      ring = {
        history_length = 100,
        storage = "shada",
        storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db", -- Only for sqlite storage
        sync_with_numbered_registers = true,
        cancel_event = "update",
        ignore_registers = { "_" },
        update_register_on_cycle = false,
      },
      picker = {
        select = {
          action = nil, -- nil to use default put action
        },
        telescope = {
          use_default_mappings = true, -- if default mappings should be used
          mappings = nil, -- nil to use default mappings or no mappings (see `use_default_mappings`)
        },
      },
      system_clipboard = {
        sync_with_ring = false,
      },
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 200,
      },
      preserve_cursor_position = {
        enabled = false,
      },
      textobj = {
        enabled = true,
      },
    }
  end,
  init = function()
    -- vim.api.nvim_set_hl(0, "YankyPut", { link = "MatchParen" })
    -- vim.api.nvim_set_hl(0, "YankyYanked", { link = "MatchParen" })
    -- Workaround for Tokyonight's Yanky integration that can't be overridden
    vim.cmd([[
        au ColorScheme  * hi link YankyPut MatchParen | hi link YankyYanked MatchParen
      ]])
    -- vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
    -- vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
    -- vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
    -- vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
    -- vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
    -- vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
    -- vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
    -- vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
  end,
  keys = {
    {
      -- fix Y
      "Y",
      "y$",
      { noremap = true, mode = { "n" } },
    },
    {
      "y",
      "<Plug>(YankyYank)",
      desc = "Yank",
      mode = { "n", "x" },
    },
    {
      "p",
      "<Plug>(YankyPutAfter)",
      desc = "Put after",
      mode = { "n", "x" },
    },
    {
      "P",
      "<Plug>(YankyPutBefore)",
      desc = "Put before",
      mode = { "n", "x" },
    },
    {
      "gp",
      "<Plug>(YankyGPutAfter)",
      desc = "gPut after",
      mode = { "n", "x" },
    },
    {
      "gP",
      "<Plug>(YankyGPutBefore)",
      desc = "gPut before",
      mode = { "n", "x" },
    },
    {
      "<M-u>",
      "<Plug>(YankyPreviousEntry)",
      desc = "Previous yank",
      mode = "n",
    },
    {
      "<M-y>",
      "<Plug>(YankyNextEntry)",
      desc = "Next yank",
      mode = "n",
    },
    {
      "]p",
      "<Plug>(YankyPutIndentAfterLinewise)",
      desc = "Put indent after linewise",
      mode = "n",
    },
    {
      "[p",
      "<Plug>(YankyPutIndentBeforeLinewise)",
      desc = "Put indent before linewise",
      mode = "n",
    },
    {
      ">p",
      "<Plug>(YankyPutIndentAfterShiftRight)",
      desc = "Put indent after shift right",
      mode = "n",
    },
    {
      "<p",
      "<Plug>(YankyPutIndentAfterShiftLeft)",
      desc = "Put indent after shift left",
      mode = "n",
    },
    {
      "=p",
      "<Plug>(YankyPutAfterFilter)",
      desc = "Put after filter",
      mode = "n",
    },
    {
      "=P",
      "<Plug>(YankyPutBeforeFilter)",
      desc = "Put before filter",
      mode = "n",
    },
    -- { "<leader>fy", "<CMD>Telescope yank_history<CR>",       desc = "Yank history" }, -- telescope integration in telescope config
  },
}
