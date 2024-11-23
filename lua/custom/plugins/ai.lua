return {
  -- https://github.com/gera2ld/ai.nvim
  "gera2ld/ai.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  keys = {
    { "<leader>ai", "<cmd>AIImprove<CR>", mode = "x" },
    { "<leader>ai", ":AIImprove ", mode = "n" },
    { "<leader>aa", "<cmd>AIAsk<CR>", mode = "x" },
    { "<leader>aa", ":AIAsk ", mode = "n" },
    { "<leader>ad", "<cmd>AIDefine<CR>", mode = "x" },
    { "<leader>ad", ":AIDefine ", mode = "n" },
    { "<leader>at", "<cmd>AITranslate<CR>", mode = "x" },
    { "<leader>at", ":AITranslate ", mode = "n" },
  },
  opts = {
    ---- AI's answer is displayed in a popup buffer
    ---- Default behaviour is not to give it the focus because it is seen as a kind of tooltip
    ---- But if you prefer it to get the focus, set to true.
    result_popup_gets_focus = true,
    ---- Override default prompts here, see below for more details
    -- prompts = {},
    ---- Default models for each prompt, can be overridden in the prompt definition
    models = {
      -- {
      --   provider = 'gemini',
      --   model = 'gemini-1.5-flash',
      --   result_tpl = '## Gemini\n\n{{output}}',
      -- },
      {
        provider = "gemini",
        -- model = 'gemini-pro',
        model = "gemini-1.5-flash",
        result_tpl = "## Gemini\n\n{{output}}",
      },
      -- {
      --   provider = 'openai',
      --   model = 'gpt-3.5-turbo',
      --   result_tpl = '## GPT-3.5\n\n{{output}}',
      -- },
    },

    --- API keys and relavant config
    gemini = {
      -- api_key = 'YOUR_GEMINI_API_KEY',
      -- model = 'gemini-pro',
      model = "gemini-1.5-flash",
      -- proxy = '',
    },
    -- openai = {
    --   api_key = 'YOUR_OPENAI_API_KEY',
    --   -- base_url = 'https://api.openai.com/v1',
    --   -- model = 'gpt-4',
    --   -- proxy = '',
    -- },
  },
  config = function()
    local ai = require("ai")
    ai.setup({ gemini = { api_key = os.getenv("GEMINI_API_KEY") } })
  end,
  event = "VeryLazy",
}
