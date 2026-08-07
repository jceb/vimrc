return {
  -- https://github.com/monaqa/dial.nvim
  "monaqa/dial.nvim",
  -- maybe a pluging to replace swapit with
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      default = {
        -- augend.integer.alias.decimal,
        augend.integer.alias.decimal_int,
        augend.integer.alias.octal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%d.%m.%Y"],
        augend.date.alias["%d.%m.%y"],
        augend.date.alias["%m/%d"],
        augend.date.alias["%H:%M"],
        augend.constant.alias.en_weekday,
        augend.constant.alias.en_weekday_full,
        augend.constant.alias.bool,
        augend.constant.alias.Bool,
        augend.constant.new({
          elements = { "and", "or" },
          word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
          cyclic = true, -- "or" is incremented into "and".
        }),
        augend.constant.new({
          elements = { "&&", "||" },
          word = false,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { "True", "False" },
          word = false,
          cyclic = true,
        }),
        -- uppercase hex number (0x1A1A, 0xEEFE, etc.)
        augend.integer.new({
          radix = 16,
          prefix = "0x",
          natural = true,
          case = "upper",
        }),
      },
    })
    vim.keymap.set("n", "<C-a>", function()
      require("dial.map").manipulate("increment", "normal")
    end)
    vim.keymap.set("n", "<C-x>", function()
      require("dial.map").manipulate("decrement", "normal")
    end)
    vim.keymap.set("n", "g<C-a>", function()
      require("dial.map").manipulate("increment", "gnormal")
    end)
    vim.keymap.set("n", "g<C-x>", function()
      require("dial.map").manipulate("decrement", "gnormal")
    end)
    vim.keymap.set("x", "<C-a>", function()
      require("dial.map").manipulate("increment", "visual")
    end)
    vim.keymap.set("x", "<C-x>", function()
      require("dial.map").manipulate("decrement", "visual")
    end)
    vim.keymap.set("x", "g<C-a>", function()
      require("dial.map").manipulate("increment", "gvisual")
    end)
    vim.keymap.set("x", "g<C-x>", function()
      require("dial.map").manipulate("decrement", "gvisual")
    end)
  end,
}
