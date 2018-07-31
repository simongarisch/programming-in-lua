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
print()