-- Initializes math.random
(function()
    -- Plenary's python-like context manager import
    local context_manager = require'plenary.context_manager'
    local with = context_manager.with
    local open = context_manager.open
    -- Even if this function fails, the file is always closed.
    with(open('/dev/random'), function(reader)
        -- Start the seed with a 'salt'
        local seed = 0x9823
        for b in reader:read():gmatch('.') do
            seed = seed + string.byte(b)
        end
        math.randomseed(seed)
    end
    )
end)()


local lspconfig = require'lspconfig'
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>pra', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>prr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>pl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "zls", 'vala_ls', 'clangd', 'dartls', 'sumneko_lua'}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local quirks = {
    ['vala_ls'] = {
        cmd = { '/usr/bin/vala-language-server' }
    };
    ['dartls'] = {
        cmd = {'/opt/flutter/bin/dart', '/opt/dart-sdk/bin/snapshots/analysis_server.dart.snapshot', '--protocol=lsp'}
    };
    ['sumneko_lua'] = {
        cmd = {'/usr/bin/lua-language-server'},
        settings = {
            Lua = {
                diagnostics ={globals = {'vim', 'love'}},
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true),
                },
                runtime = { version = 'LuaJIT'},
            }
        }
    }
}

for _, lsp in ipairs(servers) do
  local args = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
  for k, v in pairs(quirks[lsp] or {}) do
      args[k] = v
  end
  lspconfig[lsp].setup(args)
end

-- Icon theme
local wdi = require'nvim-web-devicons'
wdi.setup {
	override = { };
	default = true;
}
-- treesitter
local treesitter = require'nvim-treesitter.configs'
treesitter.setup {
  highlight = {
          enable = true;
  };
  incremental_selection = {
    enable = true
  };
  indent = {
    enable = true
  };
  autopairs = {enable = true};
}
-- Comment plugin settings
local kommentary = require'kommentary.config'
kommentary.use_extended_mappings()

local autopairs = require('nvim-autopairs')
autopairs.setup {
    disable_filetype = {"TelescopePrompt", "terminal"},
    ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]],"%s+", ""),
    fast_wrap = {},
}

-- Telescope Settings

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {'build/'},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    path_display = {},
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}

local scandir = require'plenary.scandir'
local path = require'plenary.path'

-- Run all lua files on lua/
local luapath = path:new(vim.g.nvim_config_folder, 'lua')
scandir.scan_dir(tostring(luapath), {on_insert = dofile})

