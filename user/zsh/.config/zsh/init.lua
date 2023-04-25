
function reload(pkgname)
  package.loaded[pkgname] = nil
  return require(pkgname)
end

function addhook(hookname, fn)
  local idx = zsh.makefn('hookname', fn)
  local cmd = string.format([[
    autoload -U add-zsh-hook;

    add-zsh-hook '%s' '%s'
  ]], hookname, idx)
  print(cmd)
  zsh.eval(cmd)
end
