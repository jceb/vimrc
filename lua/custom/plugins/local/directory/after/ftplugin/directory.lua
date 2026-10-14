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

--- Get the selected file names
--- @param opts? {visual_mode?: boolean}
--- @return string[]
local function get_file_names(opts)
  local lopts = opts or {}
  if lopts.visual_mode then
    local vend = vim.fn.getpos("v")
    local pos = vim.fn.getpos(".")
    local _start = math.min(vend[2], pos[2])
    local _end = math.max(vend[2], pos[2])
    return vim.api.nvim_buf_get_lines(0, _start - 1, _end, false)
  end
  return { vim.api.nvim_get_current_line() }
end

--- Detects visual mode
--- @return boolean
local function is_visual_mode()
  local mode = vim.api.nvim_get_mode().mode:lower()
  return vim.startswith(mode, "v") or vim.startswith(mode, "")
end

local function stop_visual_mode()
  local mode = vim.api.nvim_get_mode().mode
  if vim.startswith(mode, "v") or vim.startswith(mode, "") then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(mode, true, false, true), "n", false)
  end
end

vim.keymap.set({ "n", "x" }, ".", function()
  local fnames = get_file_names({ visual_mode = is_visual_mode() })
  if #fnames == 0 or fnames[1] == "" then
    vim.notify("Operation aborted, cursor is not on a file name", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(":<C-u>! " .. table.concat(
      vim.tbl_map(function(fname)
        return vim.fn.fnameescape(fname)
      end, fnames),
      " "
    ) .. "<Home><Right>", true, false, true),
    "n",
    false
  )
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end, { buffer = true, remap = false, nowait = true, desc = "Prefill cmd with file name" })

vim.keymap.set("n", "<leader>ck", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":<C-u>e kustomization.yaml", true, false, true), "n", false)
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end, { buffer = true, remap = false, nowait = true, desc = "Create kustomization.yaml" })

vim.keymap.set("n", "<leader>ce", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":<C-u>e README.md", true, false, true), "n", false)
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end, { buffer = true, remap = false, nowait = true, desc = "Create README.md" })

vim.keymap.set("n", "<leader>.", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":<C-u>!mkdir -p ", true, false, true), "n", false)
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end, { buffer = true, remap = false, nowait = true, desc = "Create directory" })

vim.keymap.set("n", { "a", "i" }, function()
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

vim.keymap.set({ "n", "x" }, "r", function()
  local vmode = is_visual_mode()
  local fnames = get_file_names({ visual_mode = vmode })
  if #fnames == 0 or fnames[1] == "" then
    vim.notify("Operation aborted, cursor is not on a file name", vim.log.levels.WARN)
    return
  end
  for _, fname in ipairs(fnames) do
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
  end
  if vmode then
    stop_visual_mode()
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end, { buffer = true, remap = false, nowait = true, desc = "Rename" })

local function delete_files()
  local vmode = is_visual_mode()
  local fnames = get_file_names({ visual_mode = vmode })
  if #fnames == 0 or fnames[1] == "" then
    vim.notify("Operation aborted, cursor is not on a file name", vim.log.levels.WARN)
    return
  end
  local names = table.concat(
    vim.tbl_map(function(fname)
      return vim.fn.fnameescape(fname)
    end, fnames),
    ", "
  )
  local ok, confirm = pcall(vim.fn.input, { prompt = "Delete " .. names .. "? [Y/n] ", cancelreturn = "n" })
  if not ok or not (confirm:lower() == "y" or confirm == "") then
    return
  end
  for _, fname in ipairs(fnames) do
    local full_path = vim.fs.joinpath(vim.uv.cwd(), fname)
    local res = run_on_buf(function(bufnr)
      if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
        vim.api.nvim_buf_delete(bufnr)
      end
    end, { directory = vim.fn.isdirectory(full_path) == 1 }, full_path)
    if not res then
      vim.notify("Failed to unload open buffer(s) for '" .. fname .. "'", vim.log.levels.ERROR)
    end
    vim.fs.rm(fname, { recursive = true })
  end
  if vmode then
    stop_visual_mode()
  end
  vim.schedule(function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
  end)
end
vim.keymap.set({ "n" }, "dd", delete_files, { buffer = true, remap = false, nowait = true, desc = "Delete file or directory" })
vim.keymap.set({ "x" }, "d", delete_files, { buffer = true, remap = false, nowait = true, desc = "Delete selected files or directories" })

vim.keymap.set({ "n", "x" }, "yc", function()
  local vmode = is_visual_mode()
  local fnames = get_file_names({ visual_mode = vmode })
  if #fnames == 0 or fnames[1] == "" then
    vim.notify("Operation aborted, cursor is not on a file name", vim.log.levels.WARN)
    return
  end
  local full_paths = vim.tbl_map(function(fname)
    return vim.fs.joinpath(vim.uv.cwd(), fname)
  end, fnames)
  if vmode then
    stop_visual_mode()
  end
  vim.fn.setreg(vim.v.register, full_paths)
end, { buffer = true, remap = false, nowait = true, desc = "Copy full path" })

vim.keymap.set("n", "gh", function()
  vim.w.directory_hide_dotfiles = not vim.w.directory_hide_dotfiles
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end, { buffer = true, remap = false, nowait = true, desc = "Hide / show dotfiles" })

local function hide_dotfiles()
  if not vim.w.directory_hide_dotfiles or vim.w.directory_hide_dotfiles == false then
    return
  end
  vim.cmd("keeppatterns g/^\\./d _")
end

vim.api.nvim_create_autocmd("User", {
  pattern = "DirReadPost",
  callback = hide_dotfiles,
  desc = "Hide / show dotfiles",
})

--- Copy or move files:
--- @param opts? {move: boolean} Options
local function copy_files(opts)
  local lopts = opts or {}
  local action = lopts.move and "Moving" or "Copying"
  local files = vim.split(vim.fn.getreg(vim.v.register), "\n")
  local cwd = vim.uv.cwd()
  -- vim.notify("files: " .. vim.inspect(files), vim.log.levels.DEBUG)
  if #files > 0 then
    for _, src in ipairs(files) do
      local src_stat = vim.uv.fs_stat(src)
      if src_stat then
        src = vim.fs.normalize(vim.fs.abspath(src))
        -- vim.notify("src: " .. vim.inspect(src), vim.log.levels.DEBUG)
        -- vim.notify("src_stat: " .. vim.inspect(src_stat), vim.log.levels.DEBUG)
        local dst = vim.fs.basename(src)
        -- vim.notify("dst: " .. vim.inspect(dst), vim.log.levels.DEBUG)
        if vim.uv.fs_stat(dst) then
          vim.ui.input({ prompt = "Target file exists, new name or overwrite it? ", default = dst }, function(input)
            if input == nil or input == "" then
              vim.notify(action .. " aborted for file" .. dst, vim.log.levels.ERROR)
              return
            end
            local dst_name = vim.fs.basename(input)
            local dst_fn = vim.fs.normalize(vim.fs.abspath(dst_name, { cwd = cwd }))
            if dst_fn == src then
              vim.notify(action .. " aborted source and destation are the same file: " .. dst, vim.log.levels.ERROR)
              return
            end
            if input == dst or vim.uv.fs_stat(dst_fn) then
              vim.fs.rm(dst, { recursive = true })
            end
            local res, err
            if src_stat.type == "directory" then
              -- INFO: there's apparently not native lua method for copying directories
              local out = vim.system({ "cp", "-r", src, dst_fn }):wait()
              res = out.code == 0
              err = out.stdout .. "\n" .. out.stderr
            else
              res, err = vim.uv.fs_copyfile(src, dst_fn, { excl = true })
            end
            if res ~= true then
              vim.notify(action .. " of file failed `" .. src .. "` failed with error: " .. err, vim.log.levels.ERROR)
              return
            end
            if lopts.move then
              vim.fs.rm(src, { recursive = true })
            end
            vim.notify(action .. " succeeded: `" .. src .. "` to `" .. dst_fn .. "`", vim.log.levels.INFO)
          end)
        else
          local dst_fn = vim.fs.normalize(vim.fs.abspath(dst, { cwd = cwd }))
          local res, err
          if src_stat.type == "directory" then
            -- INFO: there's apparently not native lua method for copying directories
            local out = vim.system({ "cp", "-r", src, dst_fn }):wait()
            res = out.code == 0
            err = out.stdout .. "\n" .. out.stderr
          else
            res, err = vim.uv.fs_copyfile(src, dst_fn, { excl = true })
          end
          if res ~= true then
            vim.notify(action .. " of file failed `" .. src .. "` failed with error: " .. err, vim.log.levels.ERROR)
            return
          end
          if lopts.move then
            vim.fs.rm(src, { recursive = true })
          end
          vim.notify(action .. " succeeded: `" .. src .. "` to `" .. dst_fn .. "`", vim.log.levels.INFO)
        end
      else
        vim.notify(action .. " failed, source file doesn't exist: " .. src, vim.log.levels.ERROR)
      end
    end
  else
    vim.notify("No file names found in register, nothing to copy", vim.log.levels.INFO)
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end

vim.keymap.set("n", "p", function()
  copy_files()
end, { buffer = true, remap = false, nowait = true, desc = "Copy yanked files" })

vim.keymap.set("n", "P", function()
  copy_files({ move = true })
end, { buffer = true, remap = false, nowait = true, desc = "Move yanked files" })
