map = vim.keymap.set
unmap = vim.keymap.set

return {
  ----------------------
  -- commands
  ----------------------
  {
    -- https://github.com/tpope/vim-eunuch
    "tpope/vim-eunuch",
    lazy = true,
    cmd = {
      "Remove",
      "Unlink",
      "Move",
      "Rename",
      "Delete",
      "Chmod",
      "SudoEdit",
      "SudoWrite",
      "Mkdir",
    },
    config = function()
      map("n", "<leader>se", ":<C-u>SudoEdit", { noremap = true })
      map("n", "<leader>sw", "<cmd>SudoWrite<CR>", { noremap = true })
    end,
  },
  {
    -- https://github.com/mhinz/vim-grepper
    "mhinz/vim-grepper",
    lazy = true,
    cmd = { "Grepper" },
    keys = { { "gs" }, { "gs", mode = "x" } },
    config = function()
      map("n", "gs", "<plug>(GrepperOperator)", {})
      map("x", "gs", "<plug>(GrepperOperator)", {})
      vim.cmd("runtime plugin/grepper.vim")
      vim.g.grepper.tools = { "rg", "grep", "git" }
      vim.g.grepper.prompt = 1
      vim.g.grepper.highlight = 0
      vim.g.grepper.open = 1
      vim.g.grepper.switch = 1
      vim.g.grepper.dir = "repo,cwd,file"
      vim.g.grepper.jump = 0
    end,
  },
  {
    -- https://github.com/neomake/neomake
    "neomake/neomake",
    lazy = true,
    cmd = { "Neomake" },
    keys = {
      "<leader>M",
      "<leader>m",
    },
    config = function()
      map("n", "<leader>M", ":<C-u>Neomake ", { noremap = true })
      map("n", "<leader>m", "<cmd>Neomake<CR>", { noremap = true })
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
  },
  {
    -- https://github.com/jceb/vim-helpwrapper
    "jceb/vim-helpwrapper",
    lazy = true,
    cmd = {
      "Help",
      "HelpXlst2",
      "HelpDocbk",
      "HelpMarkdown",
      "HelpTerraform",
    },
  },
  -- {
  --     -- https://github.com/danymat/neogen
  --     "danymat/neogen",
  --    dependencies = {
  --        -- https://github.com/nvim-treesitter/nvim-treesitter
  --        "nvim-treesitter/nvim-treesitter"},
  --     lazy = true,
  --     cmd = { "Neogen" },
  --     config = function()
  --         require("neogen").setup({})
  --     end,
  -- },
}
