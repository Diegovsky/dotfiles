local dap_install = require'dap-install'
local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

dap_install.setup()

local askfor = function (t)
  local text = t.text
  local cwd = t.cwd or vim.fn.getcwd() .. '/'
  local typ = t.type or 'file'

  return vim.fn.input(text, cwd, typ)
end

local cached = function(f, ...)
  return setmetatable({
      value = nil;
      f = f;
      args = {...};
    },{
      __call = function(self)
        if self.value == nil then
          self.value = self.f(unpack(self.args))
        end
        return self.value
      end
    })
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
    ['python'] = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch python file',
        program = cached(askfor, {text = 'Path to python file: '}),
      },
      {
        type = 'python';
        cwd = vim.fn.getcwd(),
        args = {'-k build_tree'},
        pythonArgs = {'-m pytest', '--pdb'},
        request = 'launch',
        debugger = 'debugpy',
        name = 'Pyton :: Run pytest';
        program = 'pipenv run python';
      }
    };
    ['ccppr_vsc'] = { {
        name = "Launch file";
        type = 'cpptools';
        MIMode = 'gdb';
        request = 'launch';
        program = cached(askfor, {text = 'Path to exe:'});
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
