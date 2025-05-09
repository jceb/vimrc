return {
  -- https://github.com/NvChad/nvim-colorizer.lua
  "NvChad/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      filetypes = { "markdown", "typescript", "typescriptreact", "javascript", "javascriptreact", "html", "css" },
      RGB = true, -- #RGB hex codes
      RGBA = true, -- #RGBA hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      AARRGGBB = false, -- 0xAARRGGBB hex codes
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = true, -- Enable all CSS *features*:
      -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn
      css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      -- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
      tailwind = true, -- Enable tailwind colors
      tailwind_opts = { -- Options for highlighting tailwind names
        update_names = true, -- When using tailwind = 'both', update tailwind names from LSP results.  See tailwind section
      },
    })
  end,
}
