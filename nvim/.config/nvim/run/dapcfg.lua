local dap_install = require'dap-install'
local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

dap_install.setup()

local askfor = function (t)
  local text = t.text
  local cwd = t.cwd or vim.fn.getcwd() .. '/'
  local typ = t.type or 'file'

  return vim.fn.input(text, cwd, typ)
end


local dap = require'dap'
local dapui = require'dapui'
local keybinds = {
  ["b"]  = dap.toggle_breakpoint,
  ["c"]  = dap.continue,
  ["so"] = dap.step_over,
  ["si"] = dap.step_into,
  ["o"]  = dapui.toggle,
}

require('dapui').setup()

-- DAP keybinds
local key_prefix = '<leader>d%s'
for key, func in pairs(keybinds) do
  require'utils'.keymapf {
    combo = key_prefix:format(key);
    run = func
  }
end

-- DAP profiles
local configurations = {
    ['ccppr_vsc'] = { {
        name = "Launch file";
        type = 'cpptools';
        MIMode = 'gdb';
        request = 'launch';
        program = function()
          if DAP_FILE_NAME then
            return DAP_FILE_NAME
          else
            DAP_FILE_NAME = askfor {
              text = 'Path to exe: ',
            }
            return DAP_FILE_NAME
          end
        end;
        cwd = '${workspaceFolder}';
        env = {};
        args = function()
          local args = {}
          local i = 1
          while true do
            local arg = askfor{text="Arg "..i..": ", type=''}
            if #arg == 0 then break end
            table.insert(args, arg)
            i = i + 1
          end
        end;
        stopOnEntry = true;
        }},
}

-- configurations.cpp = configurations.c
for adapter, conf in pairs(configurations) do
  dap_install.config(adapter,{ configurations = conf })
end
