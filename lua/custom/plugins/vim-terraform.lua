return {
  -- https://github.com/hashivim/vim-terraform
  "hashivim/vim-terraform",
  ft = { "terraform" },
  init = function()
    vim.g.terraform_fmt_on_save = 1
    vim.g.terraform_fold_sections = 1
  end,
}
