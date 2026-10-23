-- Open dir.lua from any buffer
vim.keymap.set("n", "-", "<Plug>(nvim-dir-up)")

-- Source: help: dir-decorate
local ns = vim.api.nvim_create_namespace("my.dir.classify")

local glyph = {
  fifo = "|",
  socket = "=",
  char = "%",
  block = "#",
}

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, _, buf)
    return vim.bo[buf].filetype == "directory"
  end,
  on_range = function(_, _, buf, row)
    local dir = vim.api.nvim_buf_get_name(buf)
    local name = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1]
    local path = vim.fs.joinpath(dir, (name:gsub("/$", "")))
    local stat = vim.uv.fs_lstat(path) or {}
    local exe = stat.type == "file" and bit.band(stat.mode, tonumber("111", 8)) ~= 0
    local char = glyph[stat.type] or (exe and "*")
    if char then
      vim.api.nvim_buf_set_extmark(buf, ns, row, #name, {
        virt_text = { { char, "Dimmed" } },
        virt_text_pos = "overlay",
        ephemeral = true,
      })
    end
    if stat.type == "link" then
      local target = vim.uv.fs_readlink(path) or "?"
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
        virt_text = { { "-> " .. target, "Dimmed" } },
        virt_text_pos = "eol",
        ephemeral = true,
      })
    end
    return row + 1
  end,
})

-- Source: dir-config
vim.api.nvim_create_autocmd("FileType", {
  pattern = "directory",
  callback = function()
    vim.opt_local.bufhidden = "delete"
  end,
})
