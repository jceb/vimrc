-- Source: https://www.reddit.com/r/neovim/comments/1ujsnsj/custom_keymaps_for_new_dirlua_plugin/

-- display directory path in win bar
vim.opt_local.winbar = "[dir] %f"

--- Run function on buffer
--- @param fn fun(bufnr: number) Function that's executed for every buffer that matches path
--- @param opts {directory: boolean} Options - if directory == true, interpret path as a directory and run function on all buffers that are inside this directory
--- @param path string Path name
local function run_on_buf(fn, opts, path)
  local lopts = opts or {}
  local result = true
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if not lopts.directory and vim.api.nvim_buf_get_name(bufnr) == path or vim.startswith(vim.api.nvim_buf_get_name(bufnr), path) then
      local ok, err = pcall(fn, bufnr)
      if not ok then
        result = ok
        vim.schedule(function()
          vim.notify(err, vim.log.levels.ERROR)
        end)
      end
    end
  end
  return result
end

vim.keymap.set("n", ".", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local fname = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
  if fname == "" then
    return
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":! " .. vim.fn.fnameescape(fname) .. "<Home><Right>", true, false, true), "n", false)
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end, { buffer = true, remap = false, nowait = true, desc = "Prefill cmd with file name" })

vim.keymap.set("n", "a", function()
  local ok, fname_new = pcall(vim.fn.input, "Create file or directory/: ")
  if not ok or fname_new == "" then
    return
  end
  if string.match(fname_new, "/$") ~= nil then
    local err
    ok, err = pcall(vim.fs.mkdir, fname_new, { parents = true })
    if not ok then
      vim.notify(err or ("Failed to create directory" .. fname_new), vim.log.levels.ERROR)
      return
    end
  else
    if string.match(fname_new, "/") ~= nil then
      -- create parent directories
      local err
      local dir_name = vim.fs.dirname(fname_new)
      ok, err = pcall(vim.fs.mkdir, dir_name, { parents = true })
      if not ok then
        vim.notify(err or ("Failed to create directory" .. fname_new), vim.log.levels.ERROR)
        return
      end
    end
    local f = io.open(fname_new, "w")
    if f ~= nil then
      f:close()
    else
      return
    end
  end
  vim.cmd.e(fname_new)
end, { buffer = true, remap = false, nowait = true, desc = "Create file or directory" })

vim.keymap.set("n", "r", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local fname = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
  if fname == "" then
    return
  end
  local ok, fname_new = pcall(vim.fn.input, { prompt = "Rename '" .. fname .. "' to: ", default = fname })
  if not ok or fname_new == "" then
    return
  end
  local full_path = vim.fs.joinpath(vim.uv.cwd(), fname)
  local res = run_on_buf(function(bufnr)
    if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
      vim.api.nvim_buf_delete(bufnr)
    end
  end, { directory = vim.fn.isdirectory(full_path) == 1 }, full_path)
  if not res then
    vim.notify("Failed to unload open buffer(s) for '" .. fname .. "'", vim.log.levels.ERROR)
    return
  end
  os.rename(fname, fname_new)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end, { buffer = true, remap = false, nowait = true, desc = "Rename" })

vim.keymap.set("n", "dd", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local fname = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
  if fname == "" then
    return
  end
  local ok, confirm = pcall(vim.fn.input, { prompt = "Delete '" .. fname .. "'? [Y/n] " })
  if not ok or not (confirm:lower() == "y" or confirm == "") then
    return
  end
  local full_path = vim.fs.joinpath(vim.uv.cwd(), fname)
  local res = run_on_buf(function(bufnr)
    if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
      vim.api.nvim_buf_delete(bufnr)
    end
  end, { directory = vim.fn.isdirectory(full_path) == 1 }, full_path)
  if not res then
    vim.notify("Failed to unload open buffer(s) for '" .. fname .. "'", vim.log.levels.ERROR)
    return
  end
  vim.fs.rm(fname, { recursive = true })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end, { buffer = true, remap = false, nowait = true, desc = "Delete file or directory" })

vim.keymap.set("n", "yc", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local fname = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
  if fname == "" then
    return
  end
  local full_path = vim.fs.joinpath(vim.uv.cwd(), fname)
  vim.fn.setreg(vim.v.register, full_path)
end, { buffer = true, remap = false, nowait = true, desc = "Copy full path" })
