map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
    ----------------------
    -- git
    ----------------------
    {
        -- https://github.com/tpope/vim-dispatch
        "tpope/vim-dispatch",
        lazy = true,
        cmd = { "Dispatch", "Make", "Focus", "Start" },
    },
    {
        -- Give this a try:
        -- use {"TimUntersberger/neogit"}
        -- https://github.com/tpope/vim-fugitive
        "tpope/vim-fugitive",
        lazy = true,
        cmd = {
            "GBrowse",
            "GMove",
            "GSplit",
            "Gclog",
            "Gdiffsplit",
            "Gedit",
            "Git",
            "Gmove",
            "Gremove",
            "Gsplit",
            "Gwrite",
        },
        ft = { "fugitive" },
        config = function()
            vim.cmd("autocmd BufReadPost fugitive://* set bufhidden=delete")
            vim.cmd([[
        function! LightLineFugitive()
        if exists('*fugitive#Head')
          let l:_ = fugitive#Head()
          return strlen(l:_) > 0 ? l:_ . ' ' : ''
          endif
          return ''
          endfunction
          ]])
            vim.cmd([[
          let g:lightline.active.left[1] = [ "bomb", "diff", "scrollbind", "noeol", "readonly", "fugitive", "filename", "modified" ]
          let g:lightline.component_function.fugitive = "LightLineFugitive"
          call lightline#init()
          ]])
        end,
    },
}
