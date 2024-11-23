return {
  -- https://github.com/Ron89/thesaurus_query.vim
  "Ron89/thesaurus_query.vim",
  ft = {
    "mail",
    "help",
    "debchangelog",
    "tex",
    "plaintex",
    "txt",
    "asciidoc",
    "markdown",
    "org",
  },
  setup = function()
    vim.g.tq_map_keys = 1
    vim.g.tq_use_vim_autocomplete = 0
    vim.g.tq_language = { "en", "de" }
  end,
}
