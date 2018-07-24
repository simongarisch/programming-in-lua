-- Lua allows for multiple assignment
a, b = 10, 20
print(a, b) -- 10 20

-- In multiple assignment Lua first evaluates all values and then 
-- only executes the assignments. So we can swap two values
a, b = b, a
print(a, b) -- 20 10

-- When the list of values is less than the list of variables
-- the extra variables receive nil as their values
x, y, z = 1, 2
print(x, y, z) -- 1 2 nil

-- besides global variables, Lua supports local variables
j = 10      -- a global variable
local i = 1 -- global variable

-- local variables have their scope limited to the declared block
x = 10
local i = 1

while i <= x do
  local x = i * 2
  print(x) -- 2, 4, 6, 8, 10, ... 20
  i = i + 1
end
print(string.rep("*", 30))
print("")

i = 22
x = 33
if i > 20 then
  local x      -- local to the 'then' body
  x = 20       
  print(x + 2) -- would print 22
else
  print(x)     -- 10 the global one
end

print(string.rep("*", 30))
print("")

-- These do blocks are useful when you need finer control over scope

a = 10
b, c = 0.5, 0.5 
do
  local a2 = a * 2
  local d = (b^2 - 4*a*c) ^ (1/2)
  x1 = (-b + d) / a2
  x2 = (-b - d) / a2
end -- scope of a2 and d ends here
print(x1, x2)

-- It's good programming style to use local variables whenever possible.
local a, b = 1, 10
if a < b then
  print(a) -- 1
  local a  -- nil is implicit
  print(a) -- nil
end -- ends block 
print(a, b) -- 1  10

-- we can assign a global value to a local variable
foo = 10
do
  local foo = foo
  foo = 5
  print(foo) -- 5, local foo
end
print(foo) -- 10, global foo

-- Control structures
-- if then else
a, b = -5, 10
if a < 0 then a = 0 end

if a < b then
  print("a is less than b...")
end

local a, b = 3, 2 
local r, op = nil, "+"

if op == "+" then
  r = a + b
elseif op == "-" then
  r = a - b
elseif op == "/" then
  r = a / b
else
  error("invalid operation")
end
print(r) -- 5
print(string.rep("*", 30))
print("")

-- while
a = {"these", "are", "some", "table", "values"}
local i = 1
while a[i] do
  print(a[i])
  i = i + 1
end

-- repeat until repeats its body until a condition is true
x = 0
repeat
  x = x + 1
until x >= 10
print(x) -- 10

-- the for statement has two variants: the numeric for and the generic for
-- the numeric for
for i = 10, 0, -2 do print(i) end -- from 10 to 0 in increments of -2
-- 10, 8, 6, 4, 2, 0

-- the generic for traverses all values
t = {a=1, b=2, c=3}
for k, v in pairs(t) do print(k, v) end
-- a  1
-- c  3
-- b  2

-- break, return and goto
-- goto is a new Lua 5.2 feature. Corona is still on 5.1.


