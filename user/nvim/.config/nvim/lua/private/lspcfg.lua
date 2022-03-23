local lspconfig = require "lspconfig"
local M = {}
vim.o.completeopt = "menuone,noselect"
local cmp = require "cmp"

local merge = require("private").merge
local runonce = require("private").runonce

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
  lspconfig[name].setup(args)
end

local cmp_comparators = require "cmp.config.compare"
local kind_priority_comparator = function(priority_table)
  local lsp_types = require("cmp.types").lsp
  local default_priority = 3
  return function(entry1, entry2)
    if entry1.source.name ~= "nvim_lsp" then
      if entry2.source.name == "nvim_lsp" then
        return false
      else
        return nil
      end
    end
    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

    local priority1 = priority_table[kind1] or default_priority
    local priority2 = priority_table[kind2] or default_priority
    if priority1 == priority2 then
      return nil
    end
    return priority2 < priority1
  end
end

M.cmp_init = function()
  cmp.setup {
    sorting = {
      comparators = {
        cmp_comparators.offset,
        cmp_comparators.exact,
      },
    },
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

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

      { name = "vsnip" },

      { name = "buffer" },
    },
  }

  -- Prevemt cmp from messing with telescope
  vim.api.nvim_exec(
    [[
    autocmd FileType TelescopePrompt lua require('cmp').setup.buffer{enable=false}
  ]],
    true
  )
end

M.on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  M.cmp_init()

  for _, cb in ipairs(hooks) do
    cb(client, bufnr)
  end

  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<Cmd>Telescope lsp_definitions<CR>", opts)
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
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

local function callonce(f)
  return function()
    runonce("nvim-lsp-init", f)
  end
end

M.init = callonce(function()
  for _, lsp in ipairs(M.servers) do
    if lsp == nil then
      print(_, "nil")
    else
      M.setup_server(lsp)
    end
  end
end)

return M
