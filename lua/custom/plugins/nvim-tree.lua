return {
  -- https://github.com/nvim-tree/nvim-tree.lua
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeOpen", "NvimTreeToggle" },
  keys = {
    "\\",
    -- "<leader>A",
    -- "<leader>a",
  },
  dependencies = {
    -- https://github.com/nvim-tree/nvim-web-devicons
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = { max = 60 },
        side = "left",
      },
      disable_netrw = false,
      hijack_netrw = false,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        ignore_list = { ".git", "node_modules", ".cache" },
      },
      actions = {
        open_file = {
          quit_on_open = false,
          -- quit_on_open = true,
          window_picker = {
            enable = false, -- open files in the previous window
          },
        },
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
      },
    })
    local api = require("nvim-tree.api")
    vim.g.nvim_tree_bindings = {
      {
        key = { "<CR>", "o", "<2-LeftMouse>" },
        cb = api.node.open.edit,
      },
      { key = { "<2-RightMouse>", "<C-]>" }, cb = api.tree.change_root_to_node },
      { key = "<C-v>", cb = api.node.open.vertical },
      { key = "<C-x>", cb = api.node.open.horizontal },
      { key = "<C-t>", cb = api.node.open.tab },
      { key = "<", cb = api.node.navigate.sibling.prev },
      { key = ">", cb = api.node.navigate.sibling.next },
      { key = "P", cb = api.node.navigate.parent },
      { key = "<BS>", cb = api.tree.close },
      { key = "<S-CR>", cb = api.tree.close },
      { key = "<Tab>", cb = api.node.open.preview },
      { key = "K", cb = api.node.navigate.sibling.first },
      { key = "J", cb = api.node.navigate.sibling.last },
      { key = "I", cb = api.tree.toggle_gitignore_filter },
      { key = "H", cb = api.tree.toggle_hidden_filter },
      { key = "R", cb = api.tree.reload },
      { key = "a", cb = api.fs.create },
      { key = "d", cb = api.fs.remove },
      { key = "r", cb = api.fs.rename },
      { key = "<C-r>", cb = api.fs.full_rename },
      { key = "x", cb = api.fs.cut },
      { key = "c", cb = api.fs.copy },
      { key = "p", cb = api.fs.paste },
      { key = "y", cb = api.fs.copy.filename },
      { key = "Y", cb = api.fs.copy.relative_path },
      { key = "gy", cb = api.fs.copy.absolute_path },
      { key = "[c", cb = api.node.navigate.git.prev },
      { key = "]c", cb = api.node.navigate.git.next },
      { key = "-", cb = api.tree.change_root_to_parent },
      { key = "q", cb = api.tree.close },
      { key = "gh", cb = api.tree.toggle_help },
    }
    -- vim.keymap.set("n", "<leader>A", ":<C-u>NvimTreeOpen<CR>:doautocmd WinEnter<CR>", { silent = true, noremap = true })
    -- vim.keymap.set("n", "<leader>A", ":<C-u>NvimTreeToggle<CR>:doautocmd WinEnter<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "\\", ":<C-u>NvimTreeToggle<CR>:doautocmd WinEnter<CR>", { silent = true, noremap = true })
  end,
}
