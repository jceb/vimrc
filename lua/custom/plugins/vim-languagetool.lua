return {
  -- https://github.com/dpelle/vim-LanguageTool
  "dpelle/vim-LanguageTool",
  cmd = { "LanguageToolCheck" },
  build = { vim.fn.stdpath("config") .. "/download_LanguageTool.sh" },
  config = function()
    vim.g.languagetool_jar = vim.fn.stdpath("config") .. "/opt/LanguageTool/languagetool-commandline.jar"
  end,
}
