return {
  -- https://github.com/jceb/vim-textobj-uri
  "jceb/vim-textobj-uri",
  dependencies = {
    -- https://github.com/kana/vim-textobj-user
    "kana/vim-textobj-user",
  },
  -- lazy = false,
  -- keys = { { "go" } },
  config = function()
    vim.call("textobj#uri#add_pattern", "", "[bB]ug:\\? #\\?\\([0-9]\\+\\)", ":silent !open-cli 'http://forge.univention.org/bugzilla/show_bug.cgi?id=%s' &")
    vim.call(
      "textobj#uri#add_pattern",
      "",
      "[tT]icket:\\? #\\?\\([0-9]\\+\\)",
      ":silent !open-cli 'https://gorm.knut.univention.de/otrs/index.pl?Action=AgentTicketZoom&TicketNumber=%s' &"
    )
    vim.call("textobj#uri#add_pattern", "", "[iI]ssue:\\? #\\?\\([0-9]\\+\\)", ":silent !open-cli 'https://univention.plan.io/issues/%s' &")
    vim.call("textobj#uri#add_pattern", "", "[tT][gG]-\\([0-9]\\+\\)", ":!open-cli 'https://tree.taiga.io/project/jceb-identinet-development/us/%s' &")
  end,
}
