return {
  -- https://github.com/itchyny/lightline.vim
  "itchyny/lightline.vim",
  -- lazy = true,
  name = "lightline",
  init = function()
    vim.cmd([[
          function! LightLineFilename(n)
          let buflist = tabpagebuflist(a:n)
          let winnr = tabpagewinnr(a:n)
          let _ = expand('#'.buflist[winnr - 1].':p')
          let stripped_ = substitute(_, '^'.fnamemodify(getcwd(tabpagewinnr(a:n), a:n), ':h').'/', '', '')
          return _ !=# '' ? (stripped_ !=# '' ? stripped_ : _) :  '[No Name]'
          endfunction
          ]])
    vim.g.lightline = {
      colorscheme = "PaperColor_light",
      component = {
        bomb = '%{&bomb?"💣":""}',
        diff = '%{&diff?"◑":""}',
        lineinfo = " %3l:%-2v",
        modified = '%{&modified?"±":""}',
        noeol = '%{&endofline?"":"!↵"}',
        readonly = '%{&readonly?"":""}',
        scrollbind = '%{&scrollbind?"∞":""}',
      },
      component_visible_condition = {
        bomb = "&bomb==1",
        diff = "&diff==1",
        modified = "&modified==1",
        noeol = "&endofline==0",
        scrollbind = "&scrollbind==1",
      },
      -- FIXME somehow lightline doesn't accept an empty list
      -- here
      component_function = {
        test = "fake",
      },
      tab_component_function = {
        tabfilename = "LightLineFilename",
      },
      separator = { left = "", right = "" },
      subseparator = { left = "", right = "" },
      tab = {
        active = { "tabnum", "tabfilename", "modified" },
        inactive = { "tabnum", "tabfilename", "modified" },
      },
      active = {
        left = {
          { "winnr", "mode", "paste" },
          {
            "bomb",
            "diff",
            "scrollbind",
            "noeol",
            "readonly",
            "filename",
            "modified",
          },
        },
        right = {
          { "lineinfo" },
          { "percent" },
          { "fileformat", "fileencoding", "filetype" },
        },
      },
      inactive = {
        left = {
          {
            "winnr",
            "diff",
            "scrollbind",
            "filename",
            "modified",
          },
        },
        right = { { "lineinfo" }, { "percent" } },
      },
    }
  end,
}
