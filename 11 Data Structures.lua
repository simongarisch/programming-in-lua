-- Tables in Lua are not a data structure; they are the data structure
-- Data structures in other languages: arrays, lists, queues, sets
-- can be represented (efficiently) with tables in Lua.

-- Arrays
a = {} -- new array
for i=1, 1000 do
  a[i] = 0
end
print(#a) -- 1000

-- it's customary in Lua to start arrays with index 1, but we don't have to
-- with a single expression
local some_array = {1, 7, 9, 11}
print(some_array) -- table: 00000000003ADAD0
for k,v in pairs(some_array) do
  print(k, v)
end
--[[
1 1
2 7
3 9
4 11
]]
print(string.rep("*", 30))

-- matrices and multi-dimensional arrays

N, M = 3, 4
mt = {} -- create a matrix
for i=1,N do
  mt[i] = {} -- create a new row
  for j=1,M do
    mt[i][j] = 0
  end
end

print(#mt)    -- 3
print(#mt[1]) -- 4

-- linked lists
-- each node is represented by a table
list = nil
list = {next = list, value = "a"}
list = {next = list, value = "b"}
list = {next = list, value = "c"}

-- to traverse the list
local l = list
while l do -- while l is not nil
  print(l.value)
  l = l.next
end
-- c, b, a

-- Queues and double queues
List = {}
function List.new()
  return {first=0, last=-1}
end

function List.pushfirst(list, value)
  local first = list.first - 1
  list.first = first
  list[first] = value
end

function List.pushlast(list, value)
  local last = list.last + 1
  list.last = last
  list[last] = value
end

function List.popfirst(list)
  local first = list.first
  if first > list.last then error("list is empty") end
  local value = list[first]
  list[first] = nil -- to allow garbage collection
  list.first = first + 1
  return value
end

function List.poplast(list)
  local last = list.last
  if list.first > last then error("list is empty") end
  local value = list[last]
  list[last] = nil -- to allow garbage collection
  list.last = last - 1
  return value
end

list = List.new()
print(list, type(list), #list) -- table: 00000000235BD000 table 0
List.pushlast(list, "a")
List.pushlast(list, "b")

for k, v in pairs(list) do
  print(k, v)
end
--[[
0 a
first 0
1 b
last  1
]]

print(List.popfirst(list)) -- a
print(List.popfirst(list)) -- b
for k, v in pairs(list) do
  print(k, v)
end
--[[
first 2
last  1
]]
--print(List.popfirst(list)) -- Exception: list is empty

-- Sets and Bags
-- in Lua, we can put set elements as indices in a table
function Set(list)
  local set = {}
  for _, v in ipairs(list) do set[v] = true end
  return set
end

values = {1, 2, 1, 2, 1, 2, 1, 2, 3}
set = Set(values)
for k, v in pairs(set) do
  print(k) -- key is where the value is stored
end
-- 1
-- 2
-- 3

-- string buffers
-- graphs



