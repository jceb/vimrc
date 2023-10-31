map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
    ----------------------
    -- session management
    ----------------------
    -- {
    --     -- https://github.com/tpope/vim-obsession
    --     -- Replaced by mini.sessions
    --     "tpope/vim-obsession",
    --     -- lazy = false,
    --     -- cmd = {"Obsession"}
    -- },
    {
        -- https://github.com/jceb/vim-cd
        "jceb/vim-cd",
    },
    -- {
    --     -- https://github.com/folke/todo-comments.nvim
    --     "folke/todo-comments.nvim",
    --    dependencies = {
    --        -- https://github.com/nvim-lua/plenary.nvim
    --        "nvim-lua/plenary.nvim",
    --        -- https://github.com/nvim-lua/popup.nvim
    --        "nvim-lua/popup.nvim" },
    --     lazy = true,
    --     cmd = {
    --         "TodoTelescope",
    --         "TodoQuickFix",
    --         "TodoLocList",
    --         "TodoTrouble",
    --     },
    --     config = function()
    --         require("todo-comments").setup({})
    --     end,
    -- },
    {
        -- https://github.com/jceb/vim-editqf
        "jceb/vim-editqf",
        cmd = { "QFAddNote" },
    },
}
