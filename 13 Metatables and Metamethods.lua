-- Metatables allow us to change the behavior of a value when confronted with an undefined operation.
-- each value in Lua may have a metatable

t = {}
print(getmetatable(t)) -- nil

t1 = {}
setmetatable(t, t1)
assert(getmetatable(t) == t1)
print(getmetatable(t)) -- table: 00000000232CCC90

-- From Lua we can set the metatables only of tables;
-- to manipulate the metatables of values or other types
-- we must use C code

-- as per chap 20, the string library sets the metatable 
-- for strings
print(getmetatable("Hi!")) -- table: 000000001E5FC830
print(getmetatable(10))    -- nil
print(string.rep("*", 30))

-- an aside for tables and functions
tbl = {}
function tbl.func1() 
  print("This is func1!")
end

function tbl.func2()
  print("This is func2!")
end

for k,v in pairs(tbl) do
  print(k,v)
end
-- func2 function: 000000002322D080
-- func1 function: 000000002322D020

-- So the function names are stored as keys in the table
-- and the functions themselves as values

-- arithmetic metamethods
Set = {}

local mt = {} -- metatable for sets

-- create a new set with the values of the given list
function Set.new(l)
  local set = {}
  setmetatable(set, mt) -- setting the metatable
  for _, v in ipairs(l) do set[v] = true end
  return set
end

function Set.union(a, b)
  local res = Set.new{}
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = true end
  return res
end

function Set.intersection(a, b)
  local res = Set.new{}
  for k in pairs(a) do
    res[k] = b[k]
  end
  return res
end

function Set.tostring(set)
  local l = {} -- list to put all elements from the set
  for e in pairs(set) do
    l[#l+1] = e
  end
  return "{" .. table.concat(l, ", ") .. "}"
end

function Set.print(a)
  print(Set.tostring(a))
end

s1 = Set.new{10, 20, 30}
s2 = Set.new{30, 1}
print(getmetatable(s1)) -- table: 000000002358D000
print(getmetatable(s2)) -- table: 000000002358D000
-- in other words, both s1 and s2 have the same metatable (mt)

mt.__add = Set.union -- define how we add sets
s3 = s1 + s2
print(getmetatable(s3)) -- same as s1 and s2
Set.print(s3) -- {30, 10, 20, 1}

-- besides __add and __mul, there are __sub for subtraction
-- __div for divide, __unm for negation, __mod for modulo
-- and __pow for exponentiation. We may also define the field
-- __concat to describe the behavior of the concatenation operator.

-- 13.2 relational metamethods
-- there is also __eq (equal to), __lt (less than), 
-- __le (less than or equal to).

mt.__le = function(a, b)
  for k in pairs(a) do
    if not b[k] then return false end
  end
  return true
end

mt.__lt = function(a, b)
  return a <= b and not (b <= a)
end

mt.__eq = function(a, b)
  return a <= b and b <= a
end

-- now we are ready to use these
s1 = Set.new{2, 4}
s2 = Set.new{4, 10, 2}
print(s1 <= s2) -- true
print(s1 < s2)  -- true
print(s1 >= s1) -- true
print(s1 > s1)  -- false

-- when formatting any value, tostring first checks whether the
-- value has a __tostring metamethod.
mt.__tostring = Set.tostring
s1 = Set.new{10, 4, 5}
print(s1) -- {5, 10, 4}

-- table access metamethods
-- define behavior for otherwise erroneous situations
-- when we try to access an absent value from a table nil is returned
-- first the interpreter looks for an __index metamethod; if there is
-- no such method then the access results in nil.

-- here is a window example
Window = {}

-- create the prototype with default values
Window.prototype = {x=0, y=0, width=100, height=100}
Window.mt = {} -- create a metatable

-- declare the constructor function
function Window.new(o)
  setmetatable(o, Window.mt)
  return o
end

Window.mt.__index = function(table, key)
  return Window.prototype[key]
end

w = Window.new{x=10, y=20}
print(w.width) -- 100
print(string.rep("*", 30))
--[[
The use of the __index metamethod for inheritance is so common that Lua
provides a shortcut. Despite the name, the __index metamethod does not need
to be a function: it can be a table, instead. When it is a function, Lua calls it with
the table and the absent key as its arguments, as we have just seen. When it is
a table, Lua redoes the access in this table.
]]

function setDefault(t, d)
  local mt = {__index = function () return d end}
  setmetatable(t, mt)
end

tab = {x=10, y=20}
print(tab.x, tab.y) -- 10, nil
setDefault(tab, 0)
print(tab.x, tab.z)

-- read only tables
-- raise an error whenever we track any attempt to update the table
function readOnly(t)
  local proxy = {}
  local mt = {
    __index = t,
    __newindex = function(t, k, v)
      error("attempt to update a read-only table", 2)
    end
  }
  setmetatable(proxy, mt)
  return proxy
end

local tbl = readOnly{"a", "b", "c"}
print(tbl[1]) -- a
tbl[1] = "Not going to fly" -- error: attempt to update a read-only table
