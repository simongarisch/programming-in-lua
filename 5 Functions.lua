
-- If the function has one single argument and that argument is either a literal
-- string or a table constructor, then the parenthesis is optional e.g.
print("a")
print "a"

-- a Lua program can use functions defined in Lua and in C
-- when calling functions there is no difference between functions
-- defined in Lua and functions defined in C

function foo()
  return 1, 2
end

local a, b = foo()
print(a, b) -- 1  2

local a, b, c = foo()
print(a, b, c) -- 1 2 nil

-- for the examples
function foo0() end
function foo1() return "a" end
function foo2() return "a", "b" end -- returns two results

x, y = foo2() -- x = 'a', y = 'b'
x = foo2()    -- x = 'a', 'b' is discarded
x, y, z = 10, foo2() -- x = 10, y = 'a', z = 'b'
print(x, y, z)

-- If we write f(g()) and f has a fixed number of args
-- Lua adjusts the results of g to the number of params in f
function f(x, y)
  return x + y
end

function g()
  return 1, 2, 3
end

print(f(g())) -- 3

-- Variadic functions: can receive a number of arguments
function add(...)
  local s = 0
  for i, v in ipairs{...} do
    s = s + v
  end
  return s
end

print(add(1, 2, 3, 4)) -- 10

function foo(...)
  a, b = ...
  print(a, b)
end
foo()        -- nil  nil
foo(1)       -- 1 nil
foo(1, 2)    -- 1  2
foo(1, 2, 3) -- 1  2

function foo(...)
  return ...
end
print(foo(1, 2, 3)) -- 1  2  3

-- Named arguments
function rename(arg)
  print(string.format("Renaming from %s to %s ...", arg.old, arg.new))
end
rename{old="old_name.lua", new="new_name.lua"}
-- Renaming from old_name.lua to new_name.lua ...

-- a more complete example
function window(options)
  -- check mandatory options
  if type(options.title) ~= "string" then
    error("no title")
  elseif type(options.width) ~= "number" then
    error("no width")
  elseif type(options.height) ~= "number" then
    error("no height")
  end
  
  -- everything else is optional
  print(options.title,
        options.x or 0,
        options.y or 0,
        options.width, options.height,
        options.background or "white",
        options.border  
  )
  
end

window{width=300, height=200,
       title="Lua", background="blue",
       border=true}
