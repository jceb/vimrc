return {
  -- https://github.com/troydm/easybuffer.vim
  "troydm/easybuffer.vim",
  cmd = { "EasyBufferBotRight" },
  init = function()
    vim.g.easybuffer_chars = {
      "a",
      "s",
      "f",
      "i",
      "w",
      "e",
      "z",
      "c",
      "v",
    }
  end,
}
