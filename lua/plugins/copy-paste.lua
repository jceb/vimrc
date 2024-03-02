map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  ----------------------
  -- copy / paste
  ----------------------
  -- {
  --   -- https://github.com/svermeulen/vim-yoink
  --   "svermeulen/vim-yoink",
  --   lazy = true,
  --   keys = {
  --     { "p" },
  --     { "P" },
  --     { "<M-n>" },
  --     { "<M-p>" },
  --   },
  --   config = function()
  --     vim.g.yoinkAutoFormatPaste = 0       -- this doesn't work properly, so fix it to <F11> manualy
  --     vim.g.yoinkMaxItems = 20
  --
  --     map("n", "<M-n>", "<plug>(YoinkPostPasteSwapBack)", {})
  --     map("n", "<M-p>", "<plug>(YoinkPostPasteSwapForward)", {})
  --     map("n", "p", "<plug>(YoinkPaste_p)", {})
  --     map("n", "P", "<plug>(YoinkPaste_P)", {})
  --   end,
  -- },
  {
    -- https://github.com/gbprod/yanky.nvim
    "gbprod/yanky.nvim",
    opts = function()
      return {
        ring = {
          history_length = 100,
          storage = "shada",
          storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db",           -- Only for sqlite storage
          sync_with_numbered_registers = true,
          cancel_event = "update",
          ignore_registers = { "_" },
          update_register_on_cycle = false,
        },
        picker = {
          select = {
            action = nil,             -- nil to use default put action
          },
          telescope = {
            use_default_mappings = true,             -- if default mappings should be used
            mappings = nil,                          -- nil to use default mappings or no mappings (see `use_default_mappings`)
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
        "<M-p>",
        "<Plug>(YankyPreviousEntry)",
        desc = "Previous yank",
        mode = "n",
      },
      {
        "<M-n>",
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
  },
  {
    -- https://github.com/gbprod/substitute.nvim
    "gbprod/substitute.nvim",
    opts = function()
      return {
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
      }
    end,
    init = function()
      vim.keymap.set("n", "gr", require("substitute").operator, { noremap = true })
      vim.keymap.set("n", "grr", require("substitute").line, { noremap = true })
      vim.keymap.set("n", "gR", require("substitute").eol, { noremap = true })
      vim.keymap.set("x", "gr", require("substitute").visual, { noremap = true })
    end,
  },
  -- {
  --   -- https://github.com/svermeulen/vim-subversive
  --   "svermeulen/vim-subversive",
  --   lazy = true,
  --   keys = {
  --     { "gr" },
  --     { "gR" },
  --     { "grr" },
  --     { "grs" },
  --     { "grs", mode = "x" },
  --     { "grss" },
  --   },
  --   config = function()
  --     map("n", "gR", "<plug>(SubversiveSubstituteToEndOfLine)", {})
  --     map("n", "gr", "<plug>(SubversiveSubstitute)", {})
  --     map("n", "grr", "<plug>(SubversiveSubstituteLine)", {})
  --     map("n", "grs", "<plug>(SubversiveSubstituteRange)", {})
  --     map("x", "grs", "<plug>(SubversiveSubstituteRange)", {})
  --     map("n", "grss", "<plug>(SubversiveSubstituteWordRange)", {})
  --   end,
  -- },
}
