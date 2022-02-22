vim.cmd "let mapleader=' '"

NVIM_CONFIG_FOLDER = vim.fn.stdpath "config" .. "/"
NVIM_INIT_FILE = NVIM_CONFIG_FOLDER .. "/init.lua"

vim.g.nvim_config_folder = NVIM_CONFIG_FOLDER
vim.g.nvim_init_file = NVIM_INIT_FILE
vim.g.asyncrun_open = 12

require("packer").startup(function(use)
  -- Sensible vim defaults
  use {
    "tpope/vim-surround",
  }
  use "tpope/vim-sensible"

  -- dhall support
  use "vmchale/dhall-vim"

  use "neovim/nvim-lspconfig"
  use "onsails/lspkind-nvim"
  use { "ms-jpq/chadtree", branch = "chad", run = "<cmd>CHADdeps" }
  use {
    "kyazdani42/nvim-web-devicons",
    config = function()
      -- Icon theme
      require("nvim-web-devicons").setup {
        override = {},
        default = true,
      }
    end,
  }
  use { "nvim-treesitter/nvim-treesitter", run = "<cmd>TSUpdate" }
  use {
    "b3nj5m1n/kommentary",
    config = function()
      -- Comment plugin settings
      require("kommentary.config").use_default_mappings()
    end,
  }
  use { "nvim-treesitter/playground", cmd = "<Plug>TSPlaygroundToggle" }
  use "unblevable/quick-scope"
  -- use 'glepnir/dashboard-nvim'
  use { "eraserhd/parinfer-rust", rus = "cargo build --release" }
  use {
    "jiangmiao/auto-pairs",
    --[[ config = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "TelescopePrompt", "terminal" },
      }
    end, ]]
  }
  use "Olical/conjure"
  use "tpope/vim-fugitive"
  use { "hrsh7th/nvim-cmp", requires = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/vim-vsnip",
  } }
  use { "j-hui/fidget.nvim", config = function()
      require"fidget".setup{}
    end}
  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      local lspcfg = require "private.lspcfg"
      lspcfg.register_attach_hook(function(cl, bufnr)
        require("lsp_signature").on_attach({
          bind = true,
          always_trigger = false,
          handler_opts = {
            border = "single",
          },
          doc_lines = 5,
          hint_prefix = "parameter: ",
        }, bufnr)
      end)
    end,
  }
  use { "arrufat/vala.vim", ft = "vala" }
  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"
  use "nvim-telescope/telescope.nvim"
  use {
    "jvgrootveld/telescope-zoxide",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "zoxide"
    end,
  }
  use {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup {
        style = "darker",
      }
      require'onedark'.load()
    end,
  }
  use "Pocco81/DAPInstall.nvim"
  use "mfussenegger/nvim-dap"
  use "rcarriga/nvim-dap-ui"
  use "direnv/direnv.vim"
  use { "christoomey/vim-tmux-navigator" }
  use {
    "folke/trouble.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("trouble").setup {}
    end,
  }
  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local null = require "null-ls"
      null.setup {
        log = {
          enable = false;
          level = 'warn';
        };
        sources = {
          null.builtins.formatting.stylua, -- aur: stylua
          null.builtins.formatting.black, -- pacman python-black
          null.builtins.formatting.uncrustify, -- pacman: uncrustify
          -- null.builtins.formatting.rustfmt,
        },
      }
    end,
  }
  use {
    NVIM_CONFIG_FOLDER .. "/plugins/projection.nvim",
    as = "projection-local",
    config = function()
      local _, err = pcall(function()
        require("projection").init { enable_sorting = true }
      end)
      if err ~= nil then
        print(err)
      end
    end,
  }
end)

local scandir = require "plenary.scandir"
scandir.scan_dir(NVIM_CONFIG_FOLDER .. "/scripts", {
  on_insert = function(file)
    local result, msg = pcall(function()
      vim.cmd("source " .. file)
    end)
    if not result then
      print(msg)
    end
  end,
})

dofile(NVIM_CONFIG_FOLDER .. "/main.lua")
