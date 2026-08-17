return {
  -- https://github.com/olimorris/codecompanion.nvim
  -- and https://codecompanion.olimorris.dev/
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<Leader>A", "<cmd>CodeCompanionActions<cr>", { mode = { "n", "v" }, noremap = true, silent = true } },
    { "<Leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { mode = { "n", "v" }, noremap = true, silent = true } },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", { mode = "v", noremap = true, silent = true } },
  },
  cmd = {
    "CodeCompanionActions",
    "CodeCompanionChat",
  },
  config = function()
    -- Setup Gemini:
    -- 1. Visit https://aistudio.google.com/app/api-keys
    -- 2. Import an existing project
    -- 3. Create a new key
    -- overview: https://ai.google.dev/gemini-api/docs/models
    -- see ../../../lazy/codecompanion.nvim/lua/codecompanion/adapters/http/gemini.lua
    local default_adapter = "gemini"
    -- local default_model = "gemini-3.1-pro-preview"
    -- local default_model = "gemini-3.5-flash"
    local default_model = "gemini-3.7-flash"
    require("codecompanion").setup({
      display = { chat = { window = { pertab = true }, show_settings = true } },
      interactions = {
        chat = {
          adapter = { name = default_adapter, model = default_model },
          keymaps = {
            completion = false,
            close = false,
            clear = false,
            codeblock = false,
            yank_code = false,
            buffer_sync_all = false,
            buffer_sync_diff = false,
            regenerate = {
              modes = { n = "gR" },
            },
            fold_code = {
              modes = { n = "gF" },
              -- index = 15,
              -- callback = "keymaps.fold_code",
              -- description = "Fold all codeblocks",
            },
            goto_file_under_cursor = {
              modes = { n = "gf" },
              -- index = 21,
              -- callback = "keymaps.goto_file_under_cursor",
              -- description = "Open the file path under the cursor",
            },
          },
        },
        inline = {
          adapter = { name = default_adapter, model = default_model },
        },
        background = {
          adapter = { name = default_adapter, model = default_model },
        },
        cmd = {
          adapter = { name = default_adapter, model = default_model },
        },
        cli = {
          -- adapter = default_adapter,
          adapter = { name = "gemini_cli", model = default_model }, -- see https://github.com/google-gemini/gemini-cli
        },
      },
      adapters = {
        http = {
          opts = {
            show_presets = false,
          },
        },
      },
    })
    -- vim.keymap.set({ "n", "v" }, "<Leader>A", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    -- vim.keymap.set({ "n", "v" }, "<Leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    -- vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd([[cab cc CodeCompanion]])
  end,
}
