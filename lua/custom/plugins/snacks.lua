return {
  -- https://github.com/folke/snacks.nvim
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true }, -- Seems useful
    scope = { enabled = true }, -- Great for navigation and deletion of objects in scope

    bufdelete = { enabled = false }, -- Sayonara seems better to me
    dashboard = { enabled = false },
    dim = { enabled = false }, -- Too invasive for my taste
    explorer = { enabled = false },
    git = { enabled = false }, -- Not really useful, just git blame
    gitbrowse = { enabled = false }, -- Huburl does the same for me currently
    image = { enabled = false },
    indent = { enabled = false }, -- Not sure if I like the extra lines
    input = { enabled = false },
    picker = { enabled = false },
    profiler = { enabled = false },
    notifier = { enabled = false },
    scratch = { enabled = false }, -- Looks a bit to fancy for my liking
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    terminal = { enabled = false }, -- I like that env can be set easily. Is there a way to specify whether the window shall be created in floating/non floating mode?
    toggle = { enabled = false },
    win = { enabled = false },
    words = { enabled = false },
    zen = { enabled = false }, -- Not sure whether it's better than zen-mode for my purposes
  },
}
