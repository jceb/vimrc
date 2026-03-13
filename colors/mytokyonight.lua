package.loaded["tokyonight.colors"] = nil
require("tokyonight").load({
  transparent = not vim.g.neovide, -- Enable this to disable setting the background color
  style = vim.g.tokyonight_style or (vim.o.background == "light" and "day") or nil,
  styles = {
    sidebars = vim.o.background, -- style for sidebars, see below
    floats = vim.o.background, -- style for floating windows
  },
  day_brightness = 0.4,
})
