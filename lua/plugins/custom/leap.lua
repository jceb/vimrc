return {
  -- https://github.com/ggandor/leap.nvim
  "ggandor/leap.nvim",
  config = function()
    local leap = require("leap")
    leap.add_default_mappings()
    -- for _, _1_ in ipairs({
    --     { { "n", "x", "o" }, "s", "<Plug>(leap-forward-to)", "Leap forward to" },
    --     { { "n", "x", "o" }, "S", "<Plug>(leap-backward-to)", "Leap backward to" },
    --     -- { { "x", "o" }, "x", "<Plug>(leap-forward-till)", "Leap forward till" },
    --     -- { { "x", "o" }, "X", "<Plug>(leap-backward-till)", "Leap backward till" },
    --     -- { { "n", "x", "o" }, "gs", "<Plug>(leap-from-window)", "Leap from window" },
    --     -- { { "n", "x", "o" }, "gs", "<Plug>(leap-cross-window)", "Leap from window" },
    -- }) do
    --     local _each_2_ = _1_
    --     local modes = _each_2_[1]
    --     local lhs = _each_2_[2]
    --     local rhs = _each_2_[3]
    --     local desc = _each_2_[4]
    --     for _0, mode in ipairs(modes) do
    --         if (vim.fn.mapcheck(lhs, mode) == "") and (vim.fn.hasmapto(rhs, mode) == 0) then
    --             vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
    --         else
    --         end
    --     end
    -- end
    -- for _, _4_ in ipairs({
    --     { "n", "s", "<Plug>(leap-forward)" },
    --     { "n", "S", "<Plug>(leap-backward)" },
    --     -- { "x", "s", "<Plug>(leap-forward)" },
    --     -- { "x", "S", "<Plug>(leap-backward)" },
    --     -- { "o", "z", "<Plug>(leap-forward)" },
    --     -- { "o", "Z", "<Plug>(leap-backward)" },
    --     -- { "o", "x", "<Plug>(leap-forward-x)" },
    --     -- { "o", "X", "<Plug>(leap-backward-x)" },
    --     -- { "n", "gs", "<Plug>(leap-cross-window)" },
    --     -- { "x", "gs", "<Plug>(leap-cross-window)" },
    --     -- { "o", "gs", "<Plug>(leap-cross-window)" },
    -- }) do
    --     local _each_5_ = _4_
    --     local mode = _each_5_[1]
    --     local lhs = _each_5_[2]
    --     local rhs = _each_5_[3]
    --     if (vim.fn.mapcheck(lhs, mode) == "") and (vim.fn.hasmapto(rhs, mode) == 0) then
    --         vim.keymap.set(mode, lhs, rhs, { silent = true })
    --     else
    --     end
    -- end
  end,
}
