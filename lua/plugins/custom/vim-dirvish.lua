return {
  -- https://github.com/justinmk/vim-dirvish
  "justinmk/vim-dirvish",
  dependencies = {
    -- -- https://github.com/bounceme/remote-viewer
    -- "bounceme/remote-viewer",
    -- https://github.com/roginfarrer/vim-dirvish-dovish
    "roginfarrer/vim-dirvish-dovish",
  },
  -- cmd = { "Dirvish" },
  -- event = { "FilterReadPre" },
  -- keys = { { "-", "<Plug>(dirvish_up)" }, "<Plug>(dirvish_up)" },
  init = function()
    vim.g.dirvish_mode = [[ :sort ,^.*[\/], ]]
    vim.g.netrw_browsex_viewer = "xdg-open-background"
  end,
  config = function()
    -- local opts = { noremap = true, silent = true }
    -- vim.keymap.set("n", "<Plug>NetrwBrowseX", ':call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : "<cfile>")),netrw#CheckIfRemote())<CR>', opts)
    -- vim.keymap.set("n", "gX", "<Plug>NetrwBrowseX", {})
    -- vim.keymap.set("v", "<Plug>NetrwBrowseXVis", ":<c-u>call netrw#BrowseXVis()<CR>", opts)
    -- vim.keymap.set("v", "gX", "<Plug>NetrwBrowseXVis", {})
    -- vim.keymap.set("n", "i", "<Plug>(dovish_create_file)", {})
    -- vim.keymap.set("n", "I", "<Plug>(dovish_create_directory)", {})
    -- vim.keymap.set("n", "dd", "<Plug>(dovish_delete)", {})
    -- vim.keymap.set("n", "r", "<Plug>(dovish_rename)", {})
    -- vim.keymap.set("n", "yy", "<Plug>(dovish_yank)", {})
    -- vim.keymap.set("x", "yy", "<Plug>(dovish_yank)", {})
    -- vim.keymap.set("n", "p", "<Plug>(dovish_copy)", {})
    -- vim.keymap.set("n", "P", "<Plug>(dovish_move)", {})

    -- vim.cmd("command! -nargs=? -complete=dir Explore Dirvish <args>")
    -- vim.cmd("command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>")
    -- vim.cmd("command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>")
    vim.cmd([[
        augroup my_dirvish_events
        autocmd!
        " Map t to "open in new tab".
        autocmd FileType dirvish  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>|xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
        " Enable :Gstatus and friends.
        " autocmd FileType dirvish call fugitive#detect(@%)

        " Map `gh` to hide dot-prefixed files.
        " To "toggle" this, just press `R` to reload.
        autocmd FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>
        " autocmd FileType dirvish nnoremap <buffer> <leader>e :e %/
        autocmd FileType dirvish nnoremap <buffer> <leader>ck :e %/kustomization.yaml
        autocmd FileType dirvish nnoremap <buffer> <leader>cR :e %/README.md
        autocmd FileType dirvish nnoremap <buffer> % :e %/
        augroup END
      ]])
  end,
}
