
function reload(pkgname)
  package.loaded[pkgname] = nil
  return require(pkgname)
end
