-- Lua does automatic memory management (through garbage collection)
-- there are no problems with cyclic data structures
-- any object stored in a global variable is not garbage for Lua
-- it is up to you to assign nil to these

-- one issue arises where you need to keep track of objects in
-- some collection (but this prevents them from being destroyed)
-- looks like we are headed in a similar direction as WeakKeyDict
-- in Python.

-- weak tables are a mechanism that you use to tell lua that a
-- reference should not prevent the reclamation of an object.
-- the weak reference is not considered by the garbage collector.

-- the weakness of a table is given by the field __mode of its
-- metatable:
-- if this string contains the letter 'k' then the keys are weak
-- if the character is 'v' then the values are weak.

a = {}
b = {__mode = "k"} -- create a metatable
setmetatable(a, b) -- now 'a' has weak keys
key = {}    -- creates the first key
a[key] = 1
key = {}    -- and a second key
a[key] = 2
collectgarbage() -- forces a garbage collection cycle
for k,v in pairs(a) do
  print(k,v) -- table: 000000000054CD30   2
end

-- not sure that I like that example...
tbl1 = {}
tbl2 = {}
tbl3 = {}

wkt = {}             -- just an ordinary table
setmetatable(wkt, b) -- now it has weak keys
wkt[tbl1] = "the value for tbl1"
wkt[tbl2] = "the value for tbl2"
wkt[tbl3] = "the value for tbl3"

tbl1 = nil
tbl3 = nil
collectgarbage() -- force collection of tbl1 and tbl3
for k,v in pairs(wkt) do
  print(k,v) -- table: 000000002145CAB0 the value for tbl2
end
-- in this case only tbl2 and its value remain in the
-- weak key table as the other table objects have been garbage
-- collected.

-- memoize functions
-- a common programming technique is to trade space for time
local results = {}
setmetatable(results, {__mode = "v"}) -- make results a weak value table
function mem_loadstring(s)
  local res = results[s]
  if res == nil then            -- result not available?
    --res = assert(loadstring(s)) -- compute new result
    res = {}
    results[s] = res            -- save for later reuse
  end
  return res
end
print(string.rep("*", 30))

-- object attributes
-- another use of weak tables is to associate attributes with objects

-- revisiting tables with default values
local defaults = {}
setmetatable(defaults, {__mode = "k"}) -- defaults is not a weak key table
local mt = {__index = function(t) return defaults[t] end}
function setDefault(t, d)
  defaults[t] = d
  setmetatable(t, mt)
end
-- if defaults did not have weak keys, it would anchor all tables with
-- default values into permanent existence.
-- in the case of weak values...
local metas = {}
setmetatable(metas, {__mode = "v"})
function setDefault(t, d)
  local mt = metas[d]
  if mt == nil then
    mt = {__index = function () return d end}
    metas[d] = mt -- memoize
  end
  setmetatable(t, mt)
end