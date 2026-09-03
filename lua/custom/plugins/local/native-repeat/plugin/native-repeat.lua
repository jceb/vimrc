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
  ["{"] = "}",
  ["}"] = "{",
  ["]["] = "[]",
  ["[]"] = "][",
  ["]]"] = "[[",
  ["[["] = "]]",
  ["("] = ")",
  [")"] = "(",
  ["j"] = "k",
  ["k"] = "j",
  ["gj"] = "gk",
  ["gk"] = "gj",
  [","] = ";",
  [";"] = ",",
  ["<C-E>"] = "<C-Y>",
  ["<C-Y>"] = "<C-E>",
  ["<C-D>"] = "<C-U>",
  ["<C-U>"] = "<C-D>",
  ["<C-F>"] = "<C-B>",
  ["<Left>"] = "<Right>",
  ["<Right>"] = "<Left>",
  ["<Up>"] = "<Down>",
  ["<Down>"] = "<Up>",
  ["<Home>"] = "<End>",
  ["<End>"] = "<Home>",
  ["<PageUp>"] = "<PageDown>",
  ["<PageDown>"] = "<PageUp>",
  ["<BS>"] = "<Space>",
  [" "] = "<BS>",
  ["e"] = "ge",
  ["ge"] = "e",
  ["E"] = "gE",
  ["gE"] = "E",
  ["w"] = "b",
  ["b"] = "w",
  ["W"] = "B",
  ["B"] = "W",
  ["0"] = "$",
  ["$"] = "0",
  ["^"] = "g_",
  ["g_"] = "^",
  ["g0"] = "g$",
  ["g%"] = "g0",
  ["gm"] = "gM",
  ["gM"] = "gm",
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
