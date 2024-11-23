map = vim.keymap.set
unmap = vim.keymap.del

return {
  -- https://github.com/Houl/repmo-vim
  "Houl/repmo-vim",
  name = "repmo",
  init = function()
    local opts = { noremap = true, expr = true }
    -- map a motion and its reverse motion:
    map("", "h", 'repmo#SelfKey("h", "l")', opts)
    unmap("s", "h")
    map("", "l", 'repmo#SelfKey("l", "h")', opts)
    unmap("s", "l")
    map("", "<C-E>", 'repmo#SelfKey("<C-E>", "<C-Y>")', opts)
    unmap("s", "<C-E>")
    map("", "<C-Y>", 'repmo#SelfKey("<C-Y>", "<C-E>")', opts)
    unmap("s", "<C-Y>")
    map("", "<C-D>", 'repmo#SelfKey("<C-D>", "<C-U>")', opts)
    unmap("s", "<C-D>")
    map("", "<C-U>", 'repmo#SelfKey("<C-U>", "<C-D>")', opts)
    unmap("s", "<C-U>")
    map("", "<C-F>", 'repmo#SelfKey("<C-F>", "<C-B>")', opts)
    unmap("s", "<C-F>")
    map("", "<C-B>", 'repmo#SelfKey("<C-B>", "<C-F>")', opts)
    unmap("s", "<C-B>")
    map("", "e", 'repmo#SelfKey("e", "ge")', opts)
    unmap("s", "e")
    map("", "ge", 'repmo#SelfKey("ge", "e")', opts)
    unmap("s", "ge")
    map("", "b", 'repmo#SelfKey("b", "w")', opts)
    unmap("s", "b")
    map("", "w", 'repmo#SelfKey("w", "b")', opts)
    unmap("s", "w")
    map("", "B", 'repmo#SelfKey("B", "W")', opts)
    unmap("s", "B")
    map("", "W", 'repmo#SelfKey("W", "B")', opts)
    unmap("s", "W")
    -- repeat the last [count]motion or the last zap-key:
    map("", ";", 'repmo#LastKey(";")', opts)
    unmap("s", ";")
    map("", ",", 'repmo#LastRevKey(",")', opts)
    unmap("s", ",")
    -- add these mappings when repeating with `;' or `,':
    map("", "f", 'repmo#ZapKey("f", 1)', opts)
    unmap("s", "f")
    map("", "F", 'repmo#ZapKey("F", 1)', opts)
    unmap("s", "F")
    map("", "t", 'repmo#ZapKey("t", 1)', opts)
    unmap("s", "t")
    map("", "T", 'repmo#ZapKey("T", 1)', opts)
    unmap("s", "T")
  end,
}
