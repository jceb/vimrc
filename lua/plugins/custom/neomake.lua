return {
  -- https://github.com/neomake/neomake
  "neomake/neomake",
  cmd = { "Neomake" },
  keys = {
    "<leader>M",
    "<leader>m",
  },
  config = function()
    vim.keymap.set("n", "<leader>M", ":<C-u>Neomake ", { noremap = true })
    vim.keymap.set("n", "<leader>m", "<cmd>Neomake<CR>", { noremap = true })
    vim.g.neomake_plantuml_default_maker = {
      exe = "plantuml",
      args = {},
      errorformat = [[%EError\ line\ %l\ in\ file:\ %f,%Z%m]],
    }
    vim.g.neomake_plantuml_svg_maker = {
      exe = "plantumlsvg",
      args = {},
      errorformat = [[%EError\ line\ %l\ in\ file:\ %f,%Z%m]],
    }
    vim.g.neomake_plantuml_pdf_maker = {
      exe = "plantumlpdf",
      args = {},
      errorformat = [[%EError\ line\ %l\ in\ file:\ %f,%Z%m]],
    }
    vim.g.neomake_plantuml_enabled_makers = { "default" }
    -- vim.cmd([[
    --   function! LightLineNeomake()
    --   let l:jobs = neomake#GetJobs()
    --   if len(l:jobs) > 0
    --     return len(l:jobs).'⚒'
    --     endif
    --     return ''
    --     endfunction
    --     ]])
    -- vim.cmd([[
    --     let g:lightline.active.left[0] = [ "winnr", "neomake", "mode", "paste" ]
    --     let g:lightline.component_function.neomake = "LightLineNeomake"
    --     call lightline#init()
    --     ]])
  end,
}
