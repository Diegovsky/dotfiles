vim.fn.setenv('NVIM_CMD', "echo 'Failed to connect to nvim.\nQuitting.'; exit")
vim.fn.setenv('NVIM_LISTEN_ADDRESS', vim.v.servername)
vim.fn.setenv('GIT_EDITOR', 'nvr --servername ' .. vim.v.servername .. ' -cc split --remote-wait')

