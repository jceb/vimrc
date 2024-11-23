return {
  -- https://github.com/tpope/vim-unimpaired
  "tpope/vim-unimpaired",
  cmd = {
    "SopsDump",
    "SopsDecrypt",
    "SopsEncrypt",
  },
  keys = {
    { "yoc" },
    { "yoC" },
    { "yod" },
    { "yoh" },
    { "yoi" },
    { "yol" },
    { "yon" },
    { "yor" },
    { "yos" },
    { "you" },
    { "yow" },
    { "yox" },
    { "yoe" },
    { "yog" },
    { "yo#" },
    { "yoq" },
    { "yoD" },
    { "yok" },
    { "yoW" },
    { "yoH" },
    { "yofh" },
    { "yofw" },
    { "yofx" },
    { "yoI" },
    { "yoz" },
    { "yoZ" },
    { "[a" },
    { "]a" },
    { "[A" },
    { "]A" },
    { "[b" },
    { "]b" },
    { "[B" },
    { "]B" },
    { "[e" },
    { "]e" },
    { "[E" },
    { "]E" },
    { "[f" },
    { "]f" },
    { "[l" },
    { "]l" },
    { "[L" },
    { "]L" },
    { "[n" },
    { "]n" },
    { "[q" },
    { "]q" },
    { "[Q" },
    { "]Q" },
    { "[t" },
    { "]t" },
    { "[T" },
    { "]T" },
    { "[u" },
    { "]u" },
    { "[x" },
    { "]x" },
    { "[y" },
    { "]y" },
    { "[Y" },
    { "]Y" },
    { "[<leader>" },
    { "]<leader>" },
  },
  config = function()
    -- disable legacy mappings
    map("n", "co", "<Nop>", {})
    map("n", "=o", "<Nop>", {})

    vim.cmd([[
        command! -nargs=0 SopsDump :!sops --decrypt %
        command! -nargs=0 SopsDecrypt :!sops --decrypt --in-place %
        command! -nargs=0 SopsEncrypt :!sops --encrypt --in-place %

        function! Base64_encode(str) abort

          return luaeval('require("base64").enc(_A)', a:str)
        endfunction

        function! Base64_decode(str) abort
          return luaeval('require("base64").dec(_A)', a:str)
        endfunction

        function! Base64url_encode(str) abort
          return luaeval('require("base64").encurl(_A)', a:str)
        endfunction

        function! Base64url_decode(str) abort
          return luaeval('require("base64").decurl(_A)', a:str)
        endfunction

        call UnimpairedMapTransform('Base64_encode','[Y')
        call UnimpairedMapTransform('Base64_decode',']Y')
        call UnimpairedMapTransform('Base64url_encode','[U')
        call UnimpairedMapTransform('Base64url_decode',']U')
      ]])
    -- change configuration settings quickly
    vim.cmd([[
        function! Toggle_op2(op, op2, value)
            return a:value == eval('&'.a:op2) && eval('&'.a:op) ? 'no'.a:op : a:op
        endfunction

        function! Toggle_sequence(op, value)
            return strridx(eval('&'.a:op), a:value) == -1 ? a:op.'+='.a:value : a:op.'-='.a:value
        endfunction

        function! Toggle_value(op, value, default)
            return eval('&'.a:op) == a:default ? a:value : a:default
        endfunction

        " taken from unimpaired plugin
        function! Statusbump() abort
            let &l:readonly = &l:readonly
            return ''
        endfunction

        function! Toggle(op) abort
            call Statusbump()
            return eval('&'.a:op) ? 'no'.a:op : a:op
        endfunction

        function! Option_map(letter, option) abort
            exe 'nnoremap [o'.a:letter ':set '.a:option.'<C-R>=Statusbump()<CR><CR>'
            exe 'nnoremap ]o'.a:letter ':set no'.a:option.'<C-R>=Statusbump()<CR><CR>'
            exe 'nnoremap co'.a:letter ':set <C-R>=Toggle("'.a:option.'")<CR><CR>'
            exe 'nnoremap yo'.a:letter ':set <C-R>=Toggle("'.a:option.'")<CR><CR>'
        endfunction

        call Option_map('t', 'expandtab')
      ]])
    map("n", "[E", ":SopsEncrypt<CR>", { noremap = true })
    map("n", "]E", ":SopsDecrypt<CR>", { noremap = true })
    map("n", "yo#", ":setlocal <C-R>=Toggle_sequence('fo', 'n')<CR><CR>", { noremap = true })
    map("n", "yoq", ":setlocal <C-R>=Toggle_sequence('fo', 'tc')<CR><CR>", { noremap = true })
    map("n", "yoD", ":setlocal <C-R>=&scrollbind ? 'noscrollbind' : 'scrollbind'<CR><CR>", { noremap = true })
    map("n", "yog", ":setlocal complete-=kspell spelllang=de_de <C-R>=Toggle_op2('spell', 'spelllang', 'de_de')<CR><CR>", { noremap = true })
    map("n", "yoe", ":setlocal complete+=kspell spelllang=en_us <C-R>=Toggle_op2('spell', 'spelllang', 'en_us')<CR><CR>", { noremap = true })
    map("n", "yok", ":setlocal <C-R>=Toggle_sequence('complete',  'kspell')<CR><CR>", { noremap = true })
    map("n", "yoW", ":vertical resize 50<Bar>setlocal winfixwidth<CR>", { noremap = true })
    map("n", "yoH", ":resize 20<Bar>setlocal winfixheight<CR>", { noremap = true })
    map("n", "yofh", ":setlocal <C-R>=&winfixheight ? 'nowinfixheight' : 'winfixheight'<CR><CR>", { noremap = true })
    map("n", "yofw", ":setlocal <C-R>=&winfixwidth ? 'nowinfixwidth' : 'winfixwidth'<CR><CR>", { noremap = true })
    map("n", "yofx", ":setlocal <C-R>=&winfixheight ? 'nowinfixheight nowinfixwidth' : 'winfixheight winfixwidth'<CR><CR>", { noremap = true })
    map("n", "yoC", ":setlocal conceallevel=<C-R>=Toggle_value('conceallevel', 0, " .. vim.o.conceallevel .. ")<CR><CR>", { noremap = true })
    map("n", "yoI", ":setlocal inccommand=<C-R>=Toggle_value('inccommand', '', '" .. vim.o.inccommand .. "')<CR><CR>", { noremap = true })
    map("n", "yoz", ":setlocal scrolloff=<C-R>=Toggle_value('scrolloff', 999, " .. vim.o.scrolloff .. ")<CR><CR>", { noremap = true })
    map("n", "yoZ", ":setlocal sidescrolloff=<C-R>=Toggle_value('sidescrolloff', 999, " .. vim.o.sidescrolloff .. ")<CR><CR>", { noremap = true })
  end,
}
