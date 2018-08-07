local modname = ...
local M = {}
_G[modname] = M

package.loaded[modname] = M
setfenv(1, M)

-- now when we declare a function add, it goes to ...
function add(a, b)
  return a + b
end

-- now that we are in a new envt we lose access to
-- global variables... the book does mention a few
-- ways to get this back