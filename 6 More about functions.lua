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

