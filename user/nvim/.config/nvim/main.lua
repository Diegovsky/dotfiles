-- Initializes math.random
_ = math.randomseed(0xab2093)


-- treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
          enable = true;
  };
  incremental_selection = {
    enable = true
  };
  indent = {
    enable = true;
    disable = {"python", "rust"}
  };
  yati = { enable = true };
  autopairs = {enable = true};
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
local luapath = path:new(NVIM_CONFIG_FOLDER, 'run')
scandir.scan_dir(tostring(luapath), {on_insert = function(file)
  local _, err = pcall(function() dofile(file) end)
  if err ~= nil then
    print(('An error occoured while parsing a file: "%s"'):format(err))
  end
end
})

require'private.lspcfg'.init()
