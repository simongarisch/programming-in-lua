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