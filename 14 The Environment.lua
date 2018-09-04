-- Lua keeps all its global variables in a regular table, 
-- called the environment
-- Lua stores the environment itself in a global variable _G.

for k,v in pairs(_G) do
  print(k, v)
end
print(type(_G)) -- table
print(string.rep("*", 30))
print("")

-- because the environment is a regular table, you can
-- simply index it by the desired key (the variable name)
print(_G._VERSION)  -- Lua 5.1
_G.myVarName = 42
print(_G.myVarName) -- 42

-- because Lua keeps its global variables in a regular table
-- we can use metatables to change its behavior when accessing
-- global variables
setmetatable(_G, {
  __newindex = function(_, n)
    error("attempt to write to undeclared variable " .. n, 2)
  end,
  __index = function(_, n)
    error("attempt to read undeclared variable " .. n, 2)
  end
})

local success, result = pcall(
  function()
    return 3
  end
)
print(success, result) -- true 3

-- now any attempt to write to _G will raise an error
local success, result = pcall(
  function ()
    _G.someVar = 42
  end
)
print(success, result) 
-- false, attempt to write to undeclared variable someVar

success, result = pcall(
  function()
    return _G.someVar
  end
)
print(success, result)
-- false, attempt to read undeclared variable someVar

-- non global environments
local declaredNames = {}
setmetatable(_G, {
  __newindex = function(t, n, v)
    if not declaredNames[n] then
      local w = debug.getinfo(2, "S").what
      if w ~= "main" and w ~= "C" then
        error("attempt to write to undeclared variable " ..n, 2)
      end
      declaredNames[n] = true
    end
    rawset(t, n, v) -- do the actual set
  end,
  
  __index = function(_, n)
    if not declaredNames[n] then
      error("attempt to read undeclared variable " ..n, 2)
    else
      return nil
    end
  end,
})

-- You can change the environment of a function with 
-- the setfenv function
print(string.rep("*", 30))
print(_G.setfenv)
a = 1
setfenv(1, {g = _G})
g.print(a)
g.print(g.a)

setfenv(1, {_G = _G})
_G.print(a)    -- nil
_G.print(_G.a) -- 1
