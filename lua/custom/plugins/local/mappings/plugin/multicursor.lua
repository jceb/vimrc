-- Source: https://www.reddit.com/r/neovim/comments/1w63ltg/just_migrated_to_multicursor/
-- Useful multicursor mappings

vim.keymap.set("n", "<A-i>", function()
  local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")
  vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
end, { noremap = true, desc = "Clear multicursors" })

vim.keymap.set("n", "<A-j>", "Qj", { noremap = true, desc = "Set a cursor" })
vim.keymap.set("n", "<A-k>", "Qk", { noremap = true, desc = "Set a cursor" })

vim.keymap.set("n", "<A-a>", function()
  vim.api.nvim_feedkeys("wb", "n", false) -- move to the beginning of the word and place a cursor
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.fn.setreg("/", "\\V\\<" .. vim.fn.expand("<cword>") .. "\\>") -- set search pattern to the current word
  vim.api.nvim_feedkeys("Val1Q", "n", false)
  vim.schedule(function()
    vim.api.nvim_win_set_cursor(0, pos)
  end)
  vim.notify("pos: " .. vim.inspect(pos), vim.log.levels.DEBUG)
end, { noremap = true, desc = "Place cursor at all occurances of the word under the cursor" })

vim.keymap.set("x", "<A-a>", function()
  local selection = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
  vim.fn.setreg("/", "\\V" .. table.concat(selection, "\\n"))
  vim.api.nvim_feedkeys("v`<", "n", false)
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_feedkeys("Val1Q", "n", false)
  vim.schedule(function()
    vim.api.nvim_win_set_cursor(0, pos)
  end)
  vim.notify("pos: " .. vim.inspect(pos), vim.log.levels.DEBUG)
end, { noremap = true, desc = "Place cursor at all occurances of the word under the cursor" })

vim.keymap.set("n", "<A-n>", function()
  local ns = vim.api.nvim_create_namespace("nvim.multicursor")
  local marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1)
  if #marks ~= 0 then
    vim.api.nvim_feedkeys("Qn", "n", false) -- place a cursor and jump to the next match
    return
  end
  vim.api.nvim_feedkeys("wbQ", "n", false) -- move to the beginning of the word and place a cursor
  vim.fn.setreg("/", "\\V\\<" .. vim.fn.expand("<cword>") .. "\\>") -- set search pattern to the current word
  vim.api.nvim_feedkeys("n", "n", false)
end, { noremap = true, desc = "Place cursor and search for word under the cursor" })

vim.keymap.set("x", "<A-n>", function()
  local ns = vim.api.nvim_create_namespace("nvim.multicursor")
  local marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1)
  if #marks ~= 0 then
    vim.api.nvim_feedkeys("Qn", "n", false) -- place a cursor and jump to the next match
    return
  end
  local selection = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
  vim.fn.setreg("/", "\\V" .. table.concat(selection, "\\n"))
  vim.api.nvim_feedkeys("v`<Qn", "n", false)
end, { noremap = true, desc = "Place cursor and search for word under the cursor" })

vim.keymap.set("x", "<A-C-n>", function()
  local selection = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
  vim.fn.setreg("/", "\\V" .. table.concat(selection, "\\n"))
  vim.api.nvim_feedkeys("v`<Qn", "n", false)
end, { noremap = true, desc = "Place cursor and search for word under the cursor" })

vim.keymap.set("n", "<A-C-n>", function()
  vim.api.nvim_feedkeys("wbQ", "n", false) -- move to the beginning of the word and place a cursor
  vim.fn.setreg("/", "\\V\\<" .. vim.fn.expand("<cword>")("\\>")) -- set search pattern to the current word
  vim.api.nvim_feedkeys("n", "n", false)
end, { noremap = true, desc = "Place cursor and search for word under the cursor" })

vim.keymap.set("n", "<A-=>", "q=", { noremap = true, desc = "Toggle multicursor follow mode" })

vim.keymap.set("n", "<A-m>", "[CQ", { noremap = true, desc = "Delete the current cursor and move back to the pervious cursor" })
-- vim.keymap.set("n", "<A-m>", function()
--   vim.api.nvim_feedkeys("[C", "n", false)
--   local ns = vim.api.nvim_create_namespace("nvim.multicursor")
--   local marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1)
--   if #marks == 0 then
--     return
--   end
--   vim.print("m", vim.inspect(marks))
--   table.sort(marks, function(a, b)
--     return a[1] > b[1]
--   end)
--   vim.print("sm", vim.inspect(marks))
--   vim.api.nvim_buf_del_extmark(0, ns, marks[1][1])
-- end, { noremap = true, desc = "Delete the current cursor and move back to the pervious cursor" })
