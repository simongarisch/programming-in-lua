-- eight basic types in lua: nil, boolean, number, string, 
-- userdata, function, thread, table

print(type(nil))   -- nil
print(type(true))  -- boolean
print(type(22))    -- number
print(type("x"))   -- string
print(type(print)) -- function

-- functions are first class values in lua
-- we can manipulate them like any other value
-- lua uses nil as a kind of non-value

print("one line\nnext line \n\"in quotes\", 'in quotes'")
-- one line
-- next line
-- "in quotes", 'in quotes'

-- for longer strings
long_string = [[
This is on line 1
And this is on line 2...
]]
print(long_string)

-- any numeric operation applied to a string tries to convert it
-- to a number (may throw an error if invalid)
print("10" + 1) -- 11
print(type(tonumber("101"))) -- number

-- working with tables (main data structure in Lua)
-- a table type implements associative arrays
a = {}    -- create a table
k = "x"
a[k] = 10       -- key 'x' and value 10
a[20] = "great" -- key 20 and value 'great'
print(a)     -- table: 000000002834E170 its a table object
print(a[k])  -- 10
print(a[20]) -- 'great'

-- when a program has no more references to a table
-- Lua's garbage collector will eventually delete it
x = {}
y = x -- another reference to table x
x["a"] = 10
x["b"] = 20
x = nil -- only y still refers to the table
print(y["a"], y["b"]) -- 10 20
y = nil -- no more references to the table

-- Lua supports providing a.name as syntactic sugar for a["name"]
a = {}
a.x = 10
a.y = 20
print(a.x, a.y) -- 10 20

-- to represent a conventional array or a list, simply use a 
-- table with integer keys
 a = {}
 for i = 1, 10 do
   a[i] = i * 2
 end
 
 for i = 1, 10 do
   print(a[i])
 end
 
 -- for sequences Lua offers the length operator '#'
 for i = 1, #a do -- for i = 1 -> length of a do
   print(a[i])
 end
 
 print(string.rep("*", 30))
 print("")
 
 -- Lua can call functions written in Lua and functions written in C
 -- more in chap 5 and 27

-- the userdata type allows arbitrary C data to be stored in Lua variables

-- 2.1 type(nil) == nil... type(nil) returns 'nil' as a string, so false
print(type(nil), type(type(nil)))
print(type(nil) == nil)

-- 2.2 https://github.com/xfbs/PiL3/blob/master/02TypesAndValues/numerals.lua
