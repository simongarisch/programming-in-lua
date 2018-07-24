-- https://github.com/bjut-hz/E-Books/blob/master/program%20language/Programming%20in%20Lua%20third%20edition.pdf
-- Functions in Lua are first class values

a = {p=print}
print(a.p) -- function: 00000000235DA440
a.p("Hello World!") -- Hello World!

network = {
  {name = "grauna", IP = "210.26.30.34"},
  {name = "arraial", IP = "210.26.30.23"},
  {name = "lua", IP = "210.26.23.12"},
  {name = "derian", IP = "210.26.23.20"}
}
print(#network) -- 4

-- we can pass an ananomous function to table.sort
table.sort(network, function (a, b) return (a.name > b.name) end)
for i=1, #network do
  print(network[i].name)
end
-- lua, grauna, derian, arraial

-- closures (6.1)
-- when we write a function enclosed by another function, 
-- it has full access to local variables from the enclosing function;
-- we call this feature lexical scoping

names = {"Peter", "Paul", "Mary"}
grades = {Mary = 10, Paul = 7, Peter = 8}

function sortbygrade(names, grades)
  table.sort(names, function(n1, n2)
    return (grades[n1] > grades[n2])
  end)
end
for i = 1, #names do
  print(names[i])
end
-- the point is that the anonomous function given to
-- sort accesses the parameter grades, which is local
-- to the enclosing function

function newCounter() -- consider this function
  local i = 0
  return function()
           i = i + 1
           return i
         end
end

c1 = newCounter()
print(c1()) -- 1
print(c1()) -- 2

-- Put simply, a closure is a function plus all it needs to access
-- non-local variables correctly
c2 = newCounter()
print(c2()) -- 1
print(c1()) -- 3
print(c2()) -- 2
print(string.rep("*", 30))
print("")

-- non global functions
-- we can store functions in table fields and in local variables
Lib = {}
Lib.foo = function(x, y) return x + y end
Lib.goo = function(x, y) return x - y end

-- we could also do the same thing like...
Lib = {
  foo = function(x, y) return x + y end,
  goo = function(x, y) return x - y end
}

-- but there is a third syntax that Lua provides
Lib = {}
--function Lib.foo = function(x, y) return x + y end
--function Lib.goo = function(x, y) return x - y end

-- there is a subtle point that arises in the definition of recursive
-- local functions. Better to write as
local fact
fact = function(n)
  if n == 0 then 
    return 1
  else
    return n*fact(n-1)
  end
end
print(fact(3)) -- 6

-- proper tail calls
-- a tail call is a goto dressed as a call.
-- a tail call happens when a function calls another 
-- as its last action, so it has nothing else to do.
