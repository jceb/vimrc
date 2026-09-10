-- Source: https://neovim.io/doc/user/repeat
-- local lastChange ---@type vim.event.cmdatom.data?
local lastMotion ---@type vim.event.cmdatom.data?

local oppositeMotion = {
  [" "] = "<BS>",
  ["$"] = "0",
  ["''"] = "'\"",
  ["'("] = "')",
  ["')"] = "'(",
  ["'."] = "'^",
  ["'<"] = "'>",
  ["'>"] = "'<",
  ["'["] = "']",
  ["'\""] = "''",
  ["']"] = "'[",
  ["'^"] = "'.",
  ["'{"] = "'}",
  ["'}"] = "'{",
  ["("] = ")",
  [")"] = "(",
  ["0"] = "$",
  ["<BS>"] = "<Space>",
  ["<C-B>"] = "<C-F>",
  ["<C-D>"] = "<C-U>",
  ["<C-E>"] = "<C-Y>",
  ["<C-F>"] = "<C-B>",
  ["<C-I>"] = "<C-O>",
  ["<C-O>"] = "<C-I>",
  ["<C-U>"] = "<C-D>",
  ["<C-Y>"] = "<C-E>",
  ["<Down>"] = "<Up>",
  ["<End>"] = "<Home>",
  ["<Home>"] = "<End>",
  ["<Left>"] = "<Right>",
  ["<PageDown>"] = "<PageUp>", -- INFO: currently not recognized as a motion
  ["<PageUp>"] = "<PageDown>", -- INFO: currently not recognized as a motion
  ["<Right>"] = "<Left>",
  ["<Up>"] = "<Down>",
  ["['"] = "]'",
  ["[<C-D>"] = "]<C-D>",
  ["[<C-I>"] = "]<C-I>",
  ["[<C-L>"] = "]<C-L>",
  ["[<C-Q>"] = "]<C-Q>",
  ["[<C-T>"] = "]<C-T>",
  ["[["] = "]]",
  ["[]"] = "][",
  ["[`"] = "]`",
  ["[d"] = "]d",
  ["[D"] = "]D",
  ["[i"] = "]i",
  ["[I"] = "]I",
  ["[l"] = "]l",
  ["[L"] = "]L",
  ["[q"] = "]q",
  ["[Q"] = "]Q",
  ["[r"] = "]r",
  ["[s"] = "]s",
  ["[S"] = "]S",
  ["[t"] = "]t",
  ["[T"] = "]T",
  ["[z"] = "]z",
  ["]'"] = "['",
  ["]<C-D>"] = "[<C-D>",
  ["]<C-I>"] = "[<C-I>",
  ["]<C-L>"] = "[<C-L>",
  ["]<C-Q>"] = "[<C-Q>",
  ["]<C-T>"] = "[<C-T>",
  ["]["] = "[]",
  ["]]"] = "[[",
  ["]`"] = "[`",
  ["]d"] = "[d",
  ["]D"] = "[D",
  ["]i"] = "[i",
  ["]I"] = "[I",
  ["]l"] = "[l",
  ["]L"] = "[L",
  ["]q"] = "[q",
  ["]Q"] = "[Q",
  ["]r"] = "[r",
  ["]s"] = "[s",
  ["]S"] = "[S",
  ["]t"] = "[t",
  ["]T"] = "[T",
  ["]z"] = "[z",
  ["^"] = "g_",
  ["`'"] = '`"',
  ["`("] = "`)",
  ["`)"] = "`(",
  ["`."] = "`^",
  ["`<"] = "`>",
  ["`>"] = "`<",
  ["`["] = "`]",
  ["`]"] = "`[",
  ["`^"] = "`.",
  ["`{"] = "`}",
  ["`}"] = "`{",
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
  ["zj"] = "zk",
  ["zk"] = "zj",
  ["{"] = "}",
  ["}"] = "{",
  ['`"'] = "`'",
}

vim.keymap.set("n", ",", function()
  -- CmdAtom is deferred; schedule the replay, in case "," follows a motion.
  vim.schedule(function()
    if lastMotion and not vim.list_contains({ "t", "T", "f", "F" }, lastMotion.cmd) then
      -- vim.print("motion", vim.inspect(lastMotion))
      local keys = oppositeMotion[vim.list_contains({ "motion", "scroll" }, lastMotion.type) and lastMotion.cmd or lastMotion.lhs]
      -- vim.notify(
      --   "keys "
      --     .. vim.api.nvim_replace_termcodes((lastMotion.count or ((lastMotion.atoms or {})[1] or {}).count or "") .. (keys or ""), true, false, true)
      --     .. "mode "
      --     .. (vim.list_contains({ "motion", "scroll" }, lastMotion.type) and "n" or "m"),
      --   -- .. " x "
      --   -- .. vim.inspect(lastMotion),
      --   vim.log.levels.INFO
      -- )
      if keys then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes((lastMotion.count or ((lastMotion.atoms or {})[1] or {}).count or "") .. keys, true, false, true),
          vim.list_contains({ "motion", "scroll" }, lastMotion.type) and "n" or "m",
          false
        )
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
    -- vim.notify("keys " .. vim.inspect(lastMotion), vim.log.levels.INFO)
    if lastMotion and not vim.list_contains({ "t", "T", "f", "F" }, lastMotion.cmd) then
      local keys = vim.list_contains({ "motion", "scroll" }, lastMotion.type) and lastMotion.cmd or lastMotion.lhs
      -- vim.notify(
      --   "keys "
      --     .. vim.api.nvim_replace_termcodes((lastMotion.count or ((lastMotion.atoms or {})[1] or {}).count or "") .. (keys or ""), true, false, true)
      --     .. "mode "
      --     .. (vim.list_contains({ "motion", "scroll" }, lastMotion.type) and "n" or "m"),
      --   -- .. " x "
      --   -- .. vim.inspect(lastMotion),
      --   vim.log.levels.INFO
      -- )
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes((lastMotion.count or ((lastMotion.atoms or {})[1] or {}).count or "") .. keys, true, false, true),
        vim.list_contains({ "motion", "scroll" }, lastMotion.type) and "n" or "m",
        false
      )
    else
      vim.api.nvim_feedkeys(";", "n", false)
    end
  end)
end)

vim.api.nvim_create_autocmd("CmdAtom", {
  callback = function(ev)
    local motion = ev.data.moved
    if motion and not ev.data.changed then
      -- vim.notify("m " .. vim.inspect(ev), vim.log.levels.INFO)
      -- Skip edits, and various other mappings.
      if vim.list_contains({ ",", ";" }, ev.data.cmd) then
        -- do nothing
      elseif vim.list_contains({ "t", "T", "f", "F" }, ev.data.cmd) then
        lastMotion = nil
      else
        lastMotion = ev.data
      end
    end
    -- local is_redo_or_undo = ev.data.changed and (ev.data.undoseq or 0) <= (vim.b[ev.buf].maxseq or 0)
    -- vim.b[ev.buf].maxseq = vim.fn.undotree(ev.buf).seq_last
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
