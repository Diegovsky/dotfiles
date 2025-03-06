
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
  _ = 'goto_first_nonwhitespace',
  G = 'goto_last_line',
  s = 'change_selection',
  S = 'select_regex',
  A_s = 'split_selection',
  g = {
    u = 'switch_to_lowercase',
    U = 'switch_to_uppercase',
    c = 'toggle_comments',
  },
  minus = 'trim_selections',
  A_p = 'expand_selection',
  A_9 = 'select_prev_sibling',
  A_0 = 'select_next_sibling',
  C_j = 'copy_selection_on_next_line',
  C_k = 'copy_selection_on_prev_line',
  C_l = 'keep_primary_selection',
  [';'] = 'repeat_last_motion',
  ['!'] = 'shell_pipe',
  ['&'] = 'shell_pipe_to',
}

---
---@param ... string
---@return string[]
local function select_mode(...)
  return {'select_mode', ..., 'exit_select_mode'}
end

---
---@param ... string
---@return string[]
local function select_end(...)
  return {'select_mode', 'goto_line_end', ..., 'exit_select_mode'}
end

local normal = {
  A_o = 'hsplit',
  A_i = 'vsplit',
  x = 'extend_to_line_bounds',
  esc = 'collapse_selection',
  C_space = 'buffer_picker',
  K = 'hover',
  C_r = 'redo',
  g = {
    t = 'goto_type_definition',
  },
  ['$'] = select_mode'goto_line_end',
  ['|'] = select_mode'goto_line_start',
  V = {'select_mode', 'extend_to_line_bounds'},
  Y = select_end'yank',
  D = select_end'delete_selection',
  C = select_end'change_selection',
  space = {
    space = 'file_picker_in_current_directory',
  }
}
table.extend(normal, common)
table.extend(normal, win_moves)

local select = {
  ['$'] = 'goto_line_end',
  ['|'] = 'goto_line_start',
  C_v = {'extend_to_line_bounds', 'split_selection_on_newline', 'flip_selections'}
}
table.extend(select, common)


local insert = {
  C_space = 'completion'
}

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
    end_of_line_diagnostics = "hint",
    inline_diagnostics = {
      cursor_line = 'hint',
      other_lines = 'disable',
    },
    lsp = {
      display_messages = true,
      display_inlay_hints = false,
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
