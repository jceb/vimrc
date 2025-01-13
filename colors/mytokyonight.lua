package.loaded["tokyonight.colors"] = nil
require("tokyonight").load({
  transparent = not vim.g.neovide, -- Enable this to disable setting the background color
  style = vim.g.tokyonight_style or (vim.o.background == "light" and "day") or nil,
  day_brightness = 0.5,
})
