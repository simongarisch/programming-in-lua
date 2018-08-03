-- Lua keeps all its global variables in a regular table, 
-- called the environment
-- Lua stores the environment itself in a global variable _G.

for k,v in pairs(_G) do
  print(k, v)
end

-- for example
version = _G[_VERSION]
print(version) -- 