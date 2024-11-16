
local toml = require'toml'

function table.extend(a, b)
  if a == nil or b == nil then
    error('Got nil table')
  end
  for k, v in pairs(b) do
    if type(a[k]) == 'table' then
      if type(v) == 'table' then
        table.extend(a[k], v)
      else
        a[k] = {v, a[k]}
      end
    else
      a[k] = v
    end
  end
  return a
end

local win_moves0 = {
  h = 'jump_view_left',
  k = 'jump_view_up',
  j = 'jump_view_down',
  l = 'jump_view_right',

  H = 'swap_view_left',
  K = 'swap_view_up',
  J = 'swap_view_down',
  L = 'swap_view_right',
}
local win_moves = {}
for k, v in pairs(win_moves0) do
  win_moves[string.format('A-%s', k)] = v
end

local common = {
  q = {q = 'match_brackets'},
  _ = 'goto_line_start',
  ['$'] = 'goto_line_end',
  ['|'] = 'goto_line_start',
  G = 'goto_last_line',
  s = 'change_selection',
  g = {
    u = 'switch_to_lowercase',
    U = 'switch_to_uppercase'
  }
}

local normal = {
  A_o = 'hsplit',
  A_i = 'vsplit',
  x = 'extend_to_line_bounds',
  esc = 'collapse_selection',
  C_space = 'buffer_picker',
  S = 'select_regex',
  K = 'hover',
  C_r = 'redo',
  V = {'select_mode', 'extend_to_line_bounds'},
  Y = {'select_mode', 'goto_line_end', 'yank', 'exit_select_mode', 'collapse_selection'},
  D = {'select_mode', 'goto_line_end', 'delete_selection'},
  C = {'select_mode', 'goto_line_end', 'change_selection'},
  g = {
    c = { c = 'toggle_comments' }
  },
  space = {
    space = 'file_picker_in_current_directory',
    c = {a = 'code_action'}
  }
}
table.extend(normal, common)
table.extend(normal, win_moves)

local insert = {
  C_space = 'completion'
}

local select = { }
table.extend(select, common)

local config = {
  theme = 'onedark',
  editor = {
    line_number = 'relative',
    color_modes = true,
    statusline = {
      right = {'workspace-diagnostics', 'file-type', 'version-control'},
      mode = {
        normal = 'NORMAL',
        insert = 'INSERT',
        select = 'SELECT',
      }
    },
    lsp = {
      display_messages = true,
      display_inlay_hints = true,
    },
    indent_guides = {
      render = true,
    },
    cursor_shape = {
      insert = 'bar',
      normal = 'block',
      select = 'underline',
    }
  },
  keys = {
    insert = insert,
    normal = normal,
    select = select,
  }
}

local function snake_to_kebab(tbl)
  local new = {}
  for k, v in pairs(tbl) do
    local newk = k
    if type(k) == 'string' then
      -- This pattern prevents non-joining '_'s from being translated.
      newk = string.gsub(k, '(.)_(.)', '%1-%2')
    end
    if type(v) == 'table' then
      new[newk] = snake_to_kebab(v)
    else
      new[newk] = v
    end
  end
  return new
end

toml.encodeToFile(snake_to_kebab(config),
  {
    file = 'config.toml',
    overwrite=true
  },
  { indentation = false }
)
