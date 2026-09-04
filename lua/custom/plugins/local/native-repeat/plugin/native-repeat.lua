-- Source: https://neovim.io/doc/user/repeat
-- local lastChange ---@type vim.event.cmdatom.data?
local lastMotion ---@type vim.event.cmdatom.data?

-- local oppositeMotionCmds = {
--   ["f"] = "F",
--   ["F"] = "f",
--   ["T"] = "t",
--   ["t"] = "T",
-- }

local oppositeMotions = {
  [" "] = "<BS>",
  ["$"] = "0",
  ["("] = ")",
  [")"] = "(",
  [","] = ";",
  ["0"] = "$",
  [";"] = ",",
  ["<BS>"] = "<Space>",
  ["<C-D>"] = "<C-U>",
  ["<C-E>"] = "<C-Y>",
  ["<C-F>"] = "<C-B>",
  ["<C-U>"] = "<C-D>",
  ["<C-Y>"] = "<C-E>",
  ["<Down>"] = "<Up>",
  ["<End>"] = "<Home>",
  ["<Home>"] = "<End>",
  ["<Left>"] = "<Right>",
  ["<PageDown>"] = "<PageUp>",
  ["<PageUp>"] = "<PageDown>",
  ["<Right>"] = "<Left>",
  ["<Up>"] = "<Down>",
  ["[["] = "]]",
  ["[]"] = "][",
  ["]["] = "[]",
  ["]]"] = "[[",
  ["^"] = "g_",
  ["B"] = "W",
  ["b"] = "w",
  ["E"] = "gE",
  ["e"] = "ge",
  ["g%"] = "g0",
  ["g0"] = "g$",
  ["g_"] = "^",
  ["gE"] = "E",
  ["ge"] = "e",
  ["gj"] = "gk",
  ["gk"] = "gj",
  ["gM"] = "gm",
  ["gm"] = "gM",
  ["j"] = "k",
  ["k"] = "j",
  ["N"] = "n",
  ["n"] = "N",
  ["W"] = "B",
  ["w"] = "b",
  ["{"] = "}",
  ["}"] = "{",
}

vim.keymap.set("n", ",", function()
  -- CmdAtom is deferred; schedule the replay, in case "," follows a motion.
  vim.schedule(function()
    if lastMotion and not vim.list_contains({ "t", "T", "f", "F" }, lastMotion.cmd) then
      -- vim.print("motion", vim.inspect(lastMotion))
      local keys
      -- if lastMotion.cmd then
      --   keys = oppositeMotionCmds[lastMotion.cmd]
      --   if keys and lastMotion.cmdarg then
      --     keys = keys .. lastMotion.cmdarg
      --   end
      -- else
      keys = oppositeMotions[lastMotion.lhs]
      -- end
      if keys then
        vim.api.nvim_feedkeys((lastMotion.count or "") .. keys, lastMotion.keys and "n" or "m", false)
      else
        vim.notify("Opposite motion not found, doing nothing: " .. lastMotion.lhs, vim.log.levels.INFO)
      end
    else
      vim.api.nvim_feedkeys(",", "n", false)
    end
  end)
end)

vim.keymap.set("n", ";", function()
  -- CmdAtom is deferred; schedule the replay, in case ";" follows a motion.
  vim.schedule(function()
    if lastMotion and not vim.list_contains({ "t", "T", "f", "F" }, lastMotion.cmd) then
      vim.api.nvim_feedkeys(lastMotion.keys or lastMotion.lhs, lastMotion.keys and "n" or "m", false)
    else
      vim.api.nvim_feedkeys(";", "n", false)
    end
  end)
end)

vim.api.nvim_create_autocmd("CmdAtom", {
  callback = function(ev)
    local motion = ev.data.moved or ev.match == "motion"
    if motion and not ev.data.changed then
      -- Skip edits, and various other mappings.
      if vim.list_contains({ ",", ";", "t", "T", "f", "F" }, ev.data.lhs) then
        lastMotion = nil
      else
        lastMotion = ev.data
      end
    end
    local is_redo_or_undo = ev.data.changed and (ev.data.undoseq or 0) <= (vim.b[ev.buf].maxseq or 0)
    vim.b[ev.buf].maxseq = vim.fn.undotree(ev.buf).seq_last
    -- TODO: enable with the repeat functionality
    -- if ev.data.changed and not is_redo_or_undo and ev.data.lhs ~= "." then
    --   lastChange = ev.data
    -- end
  end,
})

-- FIXME: this function currently interfers with mini.surround and other plugins - sticking to vim-repead for the moment
-- vim.keymap.set("n", ".", function()
--   -- CmdAtom is deferred; schedule the replay, in case "." follows an edit.
--   vim.schedule(function()
--     if lastChange then
--       vim.print("change", vim.inspect(lastChange))
--       vim.api.nvim_feedkeys(lastChange.keys or lastChange.lhs, lastChange.keys and "n" or "m", false)
--     end
--   end)
-- end)
