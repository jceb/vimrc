return { -- Useful plugin to show you pending keybinds.
  "folke/which-key.nvim",
  event = "VimEnter", -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require("which-key").setup()

    -- Document existing key chains
    require("which-key").add({
      { "<leader>c", group = "[C]ode", hidden = true },
      { "<leader>d", group = "[D]ocument", hidden = true },
      { "<leader>r", group = "[R]ename", hidden = true },
      { "<leader>s", group = "[S]earch", hidden = true },
      { "<leader>w", group = "[W]orkspace", hidden = true },
    })
  end,
}
