-- std operators: +, -, *, /, ^, %

-- relational operators: < > <= >= == ~=

-- Lua compares tables by reference
-- values are considered equal only if they are the exact same object
a = {}; a.x = 1; a.y = 2;
b = {}; b.x = 1; b.y = 2;
c = a

print(a == c) -- true
print(a == b) -- false
print(a ~= b) -- true

-- logical operators and, or, not
-- all logical operators consider the boolean false and nil as false

-- Lua denotes the string concatenation operator as ..
print("Hello" .. " World!") -- Hello World!
a = "Hello!"
print(#a) -- 6: the length of a is 6
-- this provides us with some common Lua idioms for manipulating sequences
a = {}
a[1] = "a"
a[2] = "b"
a[3] = "c"
print(#a)     -- 3: len is three
print(a[#a])  -- 'c': get the last item in table a
a[#a] = nil   -- remove the last value
print(#a)     -- 2" len is now 2 after we deleted an item
a[#a+1] = "k" -- add an item to the end
print(#a)     -- 3
print(a[#a])  -- 'k'

a = {10, 20, 30, nil, nil}
print(#a) -- 3: len is 3 and not 5

a = {10, 20, nil, 30}
print(#a) -- 3: len is 4
for i = 1, #a do
  print(a[i])
end -- 10, 20, nil, 30

-- what about this
a = {}
a[1] = 1
a[10000] = 1
print(#a) -- 1: len is 1
for i = 1, #a do
  print(a[i]) -- just prints 1
end

-- if you really want to handle lists with holes,
-- you should store the length explicitly somewhere

-- be aware of order precedence

-- table constructors
days = {"Sunday", "Monday", "Tuesday", "Wednesday", -- the simple approach
        "Thursday", "Friday", "Saturday", "Sunday"}
print(#days) -- 8

a = {x=10, y=20} -- a special syntax equivalent to a={}, a.x=10, a.y=20
-- the original expression is faster, however, because Lua creates the table
-- already with the right size
print(string.rep("*", 30))
print("")

w = {x=0, y=0, label="console"}
print(#w) -- 0
w[1] = "another field" -- add key 1 to table w
print(#w) -- 1

-- we can mix these two constructors
polyline = {color = "blue",
            thickness = 2,
            npoints = 4,
            {x=0, y=0},   -- polyline[1]
            {x=-10, y=0}, -- polyline[2]
            {x=-10, y=1}, -- polyline[3]
            {x=0, y=1}    -- polyline[4]
}
print(#polyline) -- 4
p = polyline
print(p[1])      -- table: 0000000001E7E530
print(p[2]["x"]) -- -10
print(p[2].x)    -- -10

for i = 1, #p do
  print(p[i].x) -- 0 -10 -10 0
end
print(string.rep("*", 30))
