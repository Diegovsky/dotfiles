local M = {}

function M.set(name)
  io.write(('\27]0;%s\a'):format(name))
end

function M.restore()
  M.set(os.getenv('SHELL'))
end

function M.commandname(cmd)
  return cmd
end

function M.show(cmd)
  M.set(M.commandname())
end

zsh.eval([[
autoload -U add-zsh-hook

add-zsh-hook preexec lua-eval "require'prompt_name'.show()"
add-zsh-hook precmd lua-eval "require'prompt_name'.restore()"
]])

return M
