-- https://github.com/bjut-hz/E-Books/blob/master/program%20language/Programming%20in%20Lua%20third%20edition.pdf
print("Hello World!") -- in keeping with tradition

-- defines a factorial function
function fact(n)
  if n == 0 then
    return 1
  else
    return n * fact(n-1)
  end
end

print("Using our fact function...")
print(fact(3))
print(string.rep("*", 30))

--[[ a chunk is simply a sequence of commands or statements
     Lua needs no separator between consecutive statements,
     though you can use a semicolon if you wish ]]

a = 1
b = a * 2

a = 1;
b = a * 2;

a = 1; b = a * 2;

a = 1 b = a * 2 -- ugly, but valid

print(a, b)

-- another way to run chunks is with the dofile function (executes a file)
dofile("lib1.lua")     -- defines functions norm and twice
print(norm(3.4, 1.0))  -- 3.54
print(twice(4))        -- 8

print(z) -- nil as z is not defined

-- EXE 
-- 1.1 run the factorial example...
-- What happens with a -ve number: Exception stack overflow
-- factorial is defined only for non-negative integer numbers
function fact(n)
  if n < 0 then
    return nil
  elseif n == 0 then
    return 1
  else
    return n * fact(n-1)
  end
end

print(fact(3))  -- 6
print(fact(-1)) -- nil / undefined

-- 1.2 twice example
-- with dofile
dofile("lib1.lua")
print(twice(5)) -- 10
-- and for the l option run in the command line 'lua -llib1 -e "print(twice(5))"'
-- we can also use require
local l2 = require("lib2")
print(l2.twice(5)) -- 10

-- 1.3 other languages that use -- for comments
-- Ada, SQL

-- 1.4 which of the following are valid identifiers (don't use bad naming...)

-- 1.5 script that prints its own name
local info = debug.getinfo(1,'S')
print(info.source)