#!/usr/bin/env lua5.4
local toml = require'toml'

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

function table.extend(a, b)
  if a == nil or b == nil then
    error('Got nil table')
  end
  for k, v in pairs(b) do
    local curval = a[k]
    if type(curval) == 'table' then
      if type(v) == 'table' then
        table.extend(curval, v)
      else
        table.insert(curval, v)
      end
    elseif curval == nil then
      a[k] = v
    end
  end

  for _, v in ipairs(b) do
    table.insert(a, v)
  end

  return a

end

local function inlined(obj)
return setmetatable(obj, {inline = true})
end

local exclude_dirs = inlined {".git", ".hg", ".svn", "node_modules", "bower_components", ".npm", ".yarn", "site-packages", "__pycache__", ".venv", "venv", ".tox", ".pytest_cache", ".eggs", "dist", "build", "out", "bin", "obj", "target", "vendor", ".gradle", ".m2", "bundle", ".cache", ".parcel-cache", ".next", ".nuxt", ".serverless", "Library", ".Trash-1000", ".postgresql", ".postgres", ".mysql", ".mongodb", ".redis", "pgdata", "pg_data", "go", ".cargo", ".pyenv", ".rbenv", ".nvm", ".rustup", ".composer", ".gem", ".idea", ".vscode"}

local function path(obj)
  local default = {
    max_depth = 6,
    exclude_hidden = true,
    exclude_dirs = exclude_dirs,
    extract_exif = true,
    extract_xattr_tags = false
  }
  return inlined(table.extend(obj, default))
end

local config = {
  index_path = "/home/diegovsky/.cache/danksearch/index",
  listen_addr = "127.0.0.1:43654",
  max_file_bytes = 2097152,
  worker_count = 6,
  text_extensions = inlined {".txt", ".md", ".go", ".py", ".js", ".ts", ".jsx", ".tsx", ".json", ".yaml", ".yml", ".toml", ".html", ".css", ".rs", ".c", ".cpp", ".h", ".java", ".rb", ".php", ".sh", ".typ"},
  index_all_files = true,
  index_xattr_tags = true,
  max_depth = 0,
  index_paths = {
    path({path = '/home/diegovsky/'}),
    path({
      path = '/home/diegovsky/.local',
      max_depth=4,
      exclude_dirs={
        'Steam'
    }}),
    path({
      path = '/home/diegovsky/.config',
      max_depth=2,
      exclude_dirs={
        'Steam'
    }})
  }
}


toml.encodeToFile(snake_to_kebab(config),
  {
    file = 'config.toml',
    overwrite=true
  },
  { indentation = false,  }
)
