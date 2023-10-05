map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
    ----------------------
    -- local plugins
    ----------------------
    {
        name = "debchangelog",
        dir = vim.fn.stdpath("config") .. "/local-plugins/debchangelog",
        lazy = true,
        ft = { "debchangelog" },
    },
    {
        name = "myconfig_1_pre",
        dir = vim.fn.stdpath("config") .. "/local-plugins/myconfig_1_pre",
        -- lazy = true,
    },
    {
        name = "myconfig",
        dir = vim.fn.stdpath("config") .. "/local-plugins/myconfig",
    },
    {
        name = "myconfig_2_post",
        dir = vim.fn.stdpath("config") .. "/local-plugins/myconfig_2_post",
        lazy = true,
    },
    {
        name = "pydoc910",
        dir = vim.fn.stdpath("config") .. "/local-plugins/pydoc910",
        lazy = true,
        ft = { "python" },
    },
    {
        name = "rfc",
        dir = vim.fn.stdpath("config") .. "/local-plugins/rfc",
        lazy = true,
        ft = { "rfc" },
    },
    {
        name = "serif",
        dir = vim.fn.stdpath("config") .. "/local-plugins/serif",
    },
}
