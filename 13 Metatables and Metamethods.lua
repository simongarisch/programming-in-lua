-- Metatables allow us to change the behavior of a value when confronted with an undefined operation.
-- each value in Lua may have a metatable

t = {}
print(getmetatable(t)) -- nil