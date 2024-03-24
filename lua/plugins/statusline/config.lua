local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local M = {
}

M.getColors = function()
  return {
    transparent = "NONE",
    folded_bg = utils.get_highlight("Folded").bg,
    folded_fg = utils.get_highlight("Folded").fg,
    diff_delete = utils.get_highlight("DiffDelete").bg,
    hi_string = utils.get_highlight("String").fg,
    hi_function = utils.get_highlight("Function").fg,
    nontext = utils.get_highlight("NonText").fg,
    constant = utils.get_highlight("Constant").fg,
    statement = utils.get_highlight("Statement").fg,
    special = utils.get_highlight("Special").fg,
    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
    diag_error = utils.get_highlight("DiagnosticError").fg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg,
    diff_removed = utils.get_highlight("diffRemoved").fg,
    diff_added = utils.get_highlight("diffAdded").fg,
    diff_changed = utils.get_highlight("diffChanged").fg,
    type = utils.get_highlight("Type").fg,
    directory = utils.get_highlight("Directory").fg,
    identifier = utils.get_highlight("Identifier").fg,
    tabline_bg = utils.get_highlight("TablineSel").bg,
    tabline_fg = utils.get_highlight("TablineSel").fg,
  }
end

local Tabpage = {
  provider = function(self)
    local buflist = vim.fn.tabpagebuflist(self.tabnr)
    local winnr = vim.fn.tabpagewinnr(self.tabnr)
    local bufname = vim.fn.bufname(buflist[winnr])
    return "%" .. self.tabnr .. "T " .. self.tabpage .. " " .. bufname .. " %T"
  end,
  hl = function(self)
    if not self.is_active then
      return "TabLine"
    else
      return "TabLineSel"
    end
  end,
}

local TabpageClose = {
  provider = "%999X X %X",
  hl = "TabLine",
}

local TabPages = {
  -- only show this component if there's 2 or more tabpages
  -- condition = function()
  --   return #vim.api.nvim_list_tabpages() >= 2
  -- end,
  utils.make_tablist(Tabpage),
  { provider = "%=" },
  TabpageClose,
}
local Tabline = { TabPages }

local ViMode = {
  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  -- Now we define some dictionaries to map the output of mode() to the
  -- corresponding string and color. We can put these into `static` to compute
  -- them at initialisation time.
  static = {
    mode_names = { -- change the strings if you like it vvvvverbose!
      n = "N",
      no = "N",
      nov = "N",
      noV = "N",
      ["no\22"] = "N",
      niI = "N",
      niR = "N",
      niV = "N",
      nt = "N",
      v = "V",
      vs = "Vs",
      V = "_",
      Vs = "Vs",
      ["\22"] = "|",
      ["\22s"] = "|",
      s = "S",
      S = "S_",
      ["\19"] = "^S",
      i = "I",
      ic = "Ic",
      ix = "Ix",
      R = "R",
      Rc = "R",
      Rx = "R",
      Rv = "R",
      Rvc = "R",
      Rvx = "R",
      c = "C",
      cv = "Ex",
      r = "...",
      rm = "M",
      ["r?"] = "?",
      ["!"] = "!",
      t = "T",
    },
    mode_colors = {
      n = "tabline_bg",
      i = "hi_string",
      v = "tabline_bg",
      V = "tabline_bg",
      ["\22"] = "tabline_bg",
      c = "constant",
      s = "statement",
      S = "statement",
      ["\19"] = "statement",
      R = "constant",
      r = "constant",
      ["!"] = "diag_error",
      t = "hi_function",
    }
  },
  -- We can now access the value of mode() that, by now, would have been
  -- computed by `init()` and use it to index our strings dictionary.
  -- note how `static` fields become just regular attributes once the
  -- component is instantiated.
  -- To be extra meticulous, we can also add some vim statusline syntax to
  -- control the padding and make sure our string is always at least 2
  -- characters long. Plus a nice Icon.
  provider = function(self)
    return " " .. self.mode_names[self.mode] .. " "
  end,
  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = "tabline_fg", bg = self.mode_colors[mode], bold = true, }
  end,
  -- Re-evaluate the component only on ModeChanged event!
  -- Also allows the statusline to be re-evaluated when entering operator-pending mode
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}

local WindowNr = {
  provider = function(self)
    return vim.fn.winnr()
  end,
}

local FileNameBlock = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
-- We can now define some children separately and add them later

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension,
      { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end
}

local FileName = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ":t:.")
    if filename == "" then return "[No Name]" end
    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    -- See Flexible Components section below for dynamic truncation
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = { fg = "directory" },
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+]",
    hl = { fg = "hi_string" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "",
    hl = { fg = "constant" },
  },
  {
    condition = function()
      return vim.bo.bomb
    end,
    provider = "💣",
    hl = { fg = "diag_error" },
  },
}

local HelpFileName = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = { fg = "hi_function" },
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = "constant", bold = true, force = true }
    end
  end,
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(FileNameBlock,
  FileIcon,
  utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
  FileFlags,
  { provider = '%<' }                      -- this means that the statusline is cut here when there's not enough space
)

local FileType = {
  provider = function()
    return vim.bo.filetype
  end,
  hl = { fg = "type", bold = true },
}

local FileEncoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= 'utf-8' and enc:upper()
  end
}

local FileFormat = {
  provider = function()
    local fmt = vim.bo.fileformat
    return fmt ~= 'unix' and fmt:upper()
  end
}

-- We're getting minimalists here!
local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  -- provider = "%7(%l/%3L%):%2c %P",
  provider = "%l:%c",
}

-- I take no credits for this! :lion:
local ScrollBar = {
  static = {
    -- sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
    -- Another variant, because the more choice the better.
    sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = { fg = "tabline_bg" },
}

-- -- The easy way.
-- local Navic = {
--   condition = function() return require("nvim-navic").is_available() end,
--   provider = function()
--     return require("nvim-navic").get_location({ highlight = true })
--   end,
--   update = 'CursorMoved'
-- }

-- Full nerd (with icon colors and clickable elements)!
-- works in multi window, but does not support flexible components (yet ...)
local Navic = {
  condition = function() return require("nvim-navic").is_available() end,
  static = {
    -- create a type highlight map
    type_hl = {
      File = "Directory",
      Module = "@include",
      Namespace = "@namespace",
      Package = "@include",
      Class = "@structure",
      Method = "@method",
      Property = "@property",
      Field = "@field",
      Constructor = "@constructor",
      Enum = "@field",
      Interface = "@type",
      Function = "@function",
      Variable = "@variable",
      Constant = "@constant",
      String = "@string",
      Number = "@number",
      Boolean = "@boolean",
      Array = "@field",
      Object = "@type",
      Key = "@keyword",
      Null = "@comment",
      EnumMember = "@field",
      Struct = "@structure",
      Event = "@keyword",
      Operator = "@operator",
      TypeParameter = "@type",
    },
    -- bit operation dark magic, see below...
    enc = function(line, col, winnr)
      return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
    end,
    -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
    dec = function(c)
      local line = bit.rshift(c, 16)
      local col = bit.band(bit.rshift(c, 6), 1023)
      local winnr = bit.band(c, 63)
      return line, col, winnr
    end
  },
  init = function(self)
    local data = require("nvim-navic").get_data() or {}
    local children = {}
    -- create a child for each level
    for i, d in ipairs(data) do
      -- encode line and column numbers into a single integer
      local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
      local child = {
        {
          provider = d.icon,
          hl = self.type_hl[d.type],
        },
        {
          -- escape `%`s (elixir) and buggy default separators
          provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ''),
          -- highlight icon only or location name as well
          -- hl = self.type_hl[d.type],
          on_click = {
            -- pass the encoded position through minwid
            minwid = pos,
            callback = function(_, minwid)
              -- decode
              local line, col, winnr = self.dec(minwid)
              vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
            end,
            name = "heirline_navic",
          },
        },
      }
      -- add a separator only if needed
      if #data > 1 and i < #data then
        table.insert(child, {
          provider = " > ",
          hl = { fg = 'folded_fg' },
        })
      end
      table.insert(children, child)
    end
    -- instantiate the new child, overwriting the previous one
    self.child = self:new(children, 1)
  end,
  -- evaluate the children containing navic components
  provider = function(self)
    return self.child:eval()
  end,
  hl = { fg = "nontext" },
  update = 'CursorMoved'
}
-- Navic = { flexible = 3, Navic, { provider = "" } }

local NavicIndicator = { flexible = 3, Navic, { provider = "" } }

-- local Diagnostics = {
--   condition = conditions.has_diagnostics,
--   static = {
--     error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
--     warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
--     info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
--     hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
--   },
--   init = function(self)
--     self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
--     self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
--     self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
--     self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
--   end,
--   update = { "DiagnosticChanged", "BufEnter" },
--   {
--     provider = "![",
--   },
--   {
--     provider = function(self)
--       -- 0 is just another output, we can decide to print it or not!
--       return self.errors > 0 and (self.error_icon .. self.errors .. " ")
--     end,
--     hl = { fg = "diag_error" },
--   },
--   {
--     provider = function(self)
--       return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
--     end,
--     hl = { fg = "diag_warn" },
--   },
--   {
--     provider = function(self)
--       return self.info > 0 and (self.info_icon .. self.info .. " ")
--     end,
--     hl = { fg = "diag_info" },
--   },
--   {
--     provider = function(self)
--       return self.hints > 0 and (self.hint_icon .. self.hints)
--     end,
--     hl = { fg = "diag_hint" },
--   },
--   {
--     provider = "]",
--   },
-- }

local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
        self.status_dict.changed ~= 0
  end,

  hl = { fg = "identifier" },


  { -- git branch name
    provider = function(self)
      return " " .. self.status_dict.head
    end,
    hl = { bold = true }
  },
  -- You could handle delimiters, icons and counts similar to Diagnostics
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = "("
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("+" .. count)
    end,
    hl = { fg = "diff_added" },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("-" .. count)
    end,
    hl = { fg = "diff_removed" },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("~" .. count)
    end,
    hl = { fg = "diff_changed" },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ")",
  },
}

local DAPMessages = {
  condition = function()
    local session = require("dap").session()
    return session ~= nil
  end,
  provider = function()
    return " " .. require("dap").status()
  end,
  hl = "Debug"
  -- see Click-it! section for clickable actions
}

local Align = { provider = "%=" }
local Space = { provider = " " }

local DefaultStatusline = {
  -- ViMode, Space, WindowNr, Space, FileNameBlock, Space, Git, Space, Diagnostics, Align,
  ViMode, Space, WindowNr, Space, FileNameBlock, Space, Git, Space, Align,
  -- NavicIndicator, DAPMessages, Align,
  NavicIndicator, Align,
  Space, Space, Space, FileType, Space, Ruler, Space, ScrollBar
}

local InactiveStatusline = {
  condition = conditions.is_not_active,
  Space,
  WindowNr,
  Space,
  FileNameBlock,
  -- FileName,
  Align,
  Space,
  FileType,
  Space,
  Ruler,
  Space,
  ScrollBar
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive", "oil", "NvimTree" },
    })
  end,
  Space,
  WindowNr,
  Space,
  FileType,
  Space,
  HelpFileName,
  Align
}

local TerminalStatusline = {
  condition = function()
    return conditions.buffer_matches({ buftype = { "terminal" } })
  end,
  -- hl = { bg = "diff_delete" },
  -- Quickly add a condition to the ViMode to only show it when buffer is active!
  { condition = conditions.is_active, ViMode, Space },
  Space,
  WindowNr,
  Space,
  FileType,
  Space,
  Align,
}

local StatusLines = {
  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,
  -- the first statusline with no condition, or which condition returns true is used.
  -- think of it as a switch case with breaks to stop fallthrough.
  fallthrough = false,
  SpecialStatusline,
  TerminalStatusline,
  InactiveStatusline,
  DefaultStatusline,
}

M.config = {
  statusline = StatusLines,
  tabline = Tabline,
  opts = {
    colors = M.getColors(),
  }
}
return M
