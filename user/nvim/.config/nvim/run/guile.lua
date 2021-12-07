local on_guile = function()
  print('guile!')
  local guilebinds = {
    ['n'] = {
      ["eb"] = ':ConjureEvalBuf';
      ['ee'] = ":.ConjureEval";
    };
    ['v'] = {
      ['ee'] = ":'<,'>ConjureEval";
    }
  }
  local prefix = "<leader>m"
  for mode, binds in pairs(guilebinds) do
    for bind, cmd in pairs(binds) do
      vim.api.nvim_set_keymap(mode, prefix..bind, cmd..'<cr>', {noremap=true})
    end
  end
end

local globfname = "PRIV#GUILE_SET_KEYBINDS"
_G[globfname] = on_guile

vim.cmd(string.format([[
autocmd! FileType scheme lua _G['%s']()
]], globfname))
