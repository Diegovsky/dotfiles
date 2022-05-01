local lspconfig = require "lspconfig"
local M = {}
vim.o.completeopt = "menuone,noselect"

local merge = require("private").merge

-- [[
-- !TODO: Make an OOP API
-- !TODO: find a better place to put cmp init
-- ]]

--- @alias OnAttachHook fun(client:string, bufnr:integer)

--- @type OnAttachHook[]
local hooks = {}

M.servers = {
  "pyright",
  "rust_analyzer",
  "zls",
  "vala_ls",
  "clangd",
  "dartls",
  "sumneko_lua",
  "hls",
  "solargraph",
  "teal_ls"
}

--- @param f OnAttachHook
function M.register_attach_hook(f)
  table.insert(hooks, f)
end

--- @param name string
--- @param opt table
function M.setup_server(name, opt)
  local args = {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }
  merge(args, M.quirks[name])
  merge(args, opt)
  table.insert(_G['private#initServers'], name)
  M.cmp_init()
  lspconfig[name].setup(args)
end

M.cmp_init = function()
  local cmp = require'cmp'
  cmp.setup {
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        vim.fn["UltiSnips#Anon"](args.body) -- For `vsnip` user.

        -- For `luasnip` user.
        -- require('luasnip').lsp_expand(args.body)

        -- For `ultisnips` user.
        -- vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        select = true,
        behavior = cmp.ConfirmBehavior.Replace,
      },
      ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
      ["<S-tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
    },
    sources = {
      { name = "nvim_lsp" },

      { name = "ultisnips" },
    },
  }

  -- Prevemt cmp from messing with telescope
  --[[ vim.api.nvim_exec(
    "autocmd FileType TelescopePrompt lua require('cmp').setup.buffer{enable=false}",
    true
  ) ]]
end

M.on_attach = function(client, bufnr)
  if bufnr == nil then
    bufnr = vim.api.nvim_get_current_buf()
  end
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  for _, cb in ipairs(hooks) do
    cb(client, bufnr)
  end

  print('Buf nr', bufnr)

  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<Cmd>Telescope lsp_definitions<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<leader>pra", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<leader>prr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap(
    "n",
    "<leader>pl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    opts
  )
  buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<leader>ca", "<cmd>Telescope lsp_code_actions<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  buf_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}
M.capabilities = require("cmp_nvim_lsp").update_capabilities(M.capabilities)
-- M.capabilities = require'coq'.lsp_ensure_capabilities(M.capabilities)

M.quirks = {
  ["vala_ls"] = {
    cmd = { "/usr/bin/vala-language-server" },
  },
  ["dartls"] = {
    cmd = {
      "/opt/flutter/bin/dart",
      "/opt/dart-sdk/bin/snapshots/analysis_server.dart.snapshot",
      "--protocol=lsp",
    },
  },
  ["sumneko_lua"] = {
    cmd = { "/usr/bin/lua-language-server" },
    Lua = {
      runtime = { version = "Lua54" },
    },
  },
}

M.init = function()
  if not require'private'.try_run('LSP_INIT') then
    return
  end
  print('Lsp init')
  _G['private#initServers'] = {}
  for _, lsp in ipairs(M.servers) do
    if lsp == nil then
      print(_, "nil")
    else
      M.setup_server(lsp)
    end
  end
end

return M
