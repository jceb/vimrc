return {
  "nvim-neo-tree/neo-tree.nvim",
  -- branch = "v3.x",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  cmd = "Neotree",
  keys = {
    { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
  },
  opts = {
    commands = {
      midfinger_open = function(state)
        local node = state.tree:get_node()
        if require("neo-tree.utils").is_expandable(node) then
          state.commands["toggle_node"](state)
        else
          state.commands["open"](state)
          state.commands["close_window"](state)
        end
      end,
      midfinger_vsplit = function(state)
        local node = state.tree:get_node()
        if require("neo-tree.utils").is_expandable(node) then
          state.commands["toggle_node"](state)
        else
          state.commands["open_vsplit"](state)
          state.commands["close_window"](state)
        end
      end,
      midfinger_split = function(state)
        local node = state.tree:get_node()
        if require("neo-tree.utils").is_expandable(node) then
          state.commands["toggle_node"](state)
        else
          state.commands["open_split"](state)
          state.commands["close_window"](state)
        end
      end,
    },
    filesystem = {
      filtered_items = {
        -- visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
      window = {
        mappings = {
          ["-"] = "navigate_up",
          ["\\"] = "close_window",
          ["<CR>"] = "midfinger_open",
          ["s"] = "midfinger_vsplit",
          ["S"] = "midfinger_split",
          ["/"] = "",
        },
      },
    },
  },
}
