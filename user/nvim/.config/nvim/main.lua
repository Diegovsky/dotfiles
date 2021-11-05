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

require'projection'.init{enable_sorting=true}

-- Icon theme
local wdi = require'nvim-web-devicons'
wdi.setup {
	override = { };
	default = true;
}
-- treesitter
require'nvim-treesitter.configs'.setup {
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

-- Run all lua files on run/
local luapath = path:new(vim.g.nvim_config_folder, 'run')
scandir.scan_dir(tostring(luapath), {on_insert = dofile})

require'private.lspcfg'.init()
