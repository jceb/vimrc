return {
  -- https://github.com/Houl/repmo-vim
  "Houl/repmo-vim",
  name = "repmo",
  init = function()
    local opts = { noremap = true, expr = true }
    -- map a motion and its reverse motion:
    vim.keymap.set("", "h", 'repmo#SelfKey("h", "l")', opts)
    vim.keymap.del("s", "h")
    vim.keymap.set("", "l", 'repmo#SelfKey("l", "h")', opts)
    vim.keymap.del("s", "l")
    vim.keymap.set("", "<C-E>", 'repmo#SelfKey("<C-E>", "<C-Y>")', opts)
    vim.keymap.del("s", "<C-E>")
    vim.keymap.set("", "<C-Y>", 'repmo#SelfKey("<C-Y>", "<C-E>")', opts)
    vim.keymap.del("s", "<C-Y>")
    vim.keymap.set("", "<C-D>", 'repmo#SelfKey("<C-D>", "<C-U>")', opts)
    vim.keymap.del("s", "<C-D>")
    vim.keymap.set("", "<C-U>", 'repmo#SelfKey("<C-U>", "<C-D>")', opts)
    vim.keymap.del("s", "<C-U>")
    vim.keymap.set("", "<C-F>", 'repmo#SelfKey("<C-F>", "<C-B>")', opts)
    vim.keymap.del("s", "<C-F>")
    vim.keymap.set("", "<C-B>", 'repmo#SelfKey("<C-B>", "<C-F>")', opts)
    vim.keymap.del("s", "<C-B>")
    vim.keymap.set("", "e", 'repmo#SelfKey("e", "ge")', opts)
    vim.keymap.del("s", "e")
    vim.keymap.set("", "ge", 'repmo#SelfKey("ge", "e")', opts)
    vim.keymap.del("s", "ge")
    vim.keymap.set("", "b", 'repmo#SelfKey("b", "w")', opts)
    vim.keymap.del("s", "b")
    vim.keymap.set("", "w", 'repmo#SelfKey("w", "b")', opts)
    vim.keymap.del("s", "w")
    vim.keymap.set("", "B", 'repmo#SelfKey("B", "W")', opts)
    vim.keymap.del("s", "B")
    vim.keymap.set("", "W", 'repmo#SelfKey("W", "B")', opts)
    vim.keymap.del("s", "W")
    -- repeat the last [count]motion or the last zap-key:
    vim.keymap.set("", ";", 'repmo#LastKey(";")', opts)
    vim.keymap.del("s", ";")
    vim.keymap.set("", ",", 'repmo#LastRevKey(",")', opts)
    vim.keymap.del("s", ",")
    -- add these mappings when repeating with `;' or `,':
    vim.keymap.set("", "f", 'repmo#ZapKey("f", 1)', opts)
    vim.keymap.del("s", "f")
    vim.keymap.set("", "F", 'repmo#ZapKey("F", 1)', opts)
    vim.keymap.del("s", "F")
    vim.keymap.set("", "t", 'repmo#ZapKey("t", 1)', opts)
    vim.keymap.del("s", "t")
    vim.keymap.set("", "T", 'repmo#ZapKey("T", 1)', opts)
    vim.keymap.del("s", "T")
  end,
}
