return {
  -- https://github.com/NLKNguyen/papercolor-theme
  "NLKNguyen/papercolor-theme",
  name = "papercolor",
  lazy = true,
  init = function()
    vim.g.PaperColor_Theme_Options = {
      theme = {
        default = {
          light = {
            transparent_background = 1,
            override = {
              color04 = { "#87afd7", "110" },
              color16 = { "#87afd7", "110" },
              statusline_active_fg = { "#444444", "238" },
              statusline_active_bg = { "#eeeeee", "255" },
              visual_bg = { "#005f87", "110" },
              folded_fg = { "#005f87", "31" },
              difftext_fg = { "#87afd7", "110" },
              tabline_inactive_bg = { "#87afd7", "110" },
              buftabline_inactive_bg = { "#87afd7", "110" },
            },
          },
        },
      },
    }
  end,
}
