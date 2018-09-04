--[[
lua does not have a class system out of the box
but its powerful metaprogramming facilities makes defining classic objects straightforward 
]]

-- first by using metatables
-- a table's behavior can be customized by giving it a metatable.
-- if the metatable has an __index function, then any failed attempt to look up something in the table will be passed to __index

Account = {}
Account.__index = Account

function Account:create(balance)
  local acnt = {}             -- our new object
  setmetatable(acnt, Account) -- make Account handle lookup
  acnt.balance = balance      -- initialize our object
  return acnt
end

function Account:withdraw(amount)
  self.balance = self.balance - amount
end

-- now use this
print(Account) -- table: 00000000004ADA80
acc = Account:create(1000)
acc:withdraw(100)
print(acc.balance) -- 900
print(string.rep("*", 30))

-- ###############################################################
-- the self keyword
tbl = {}

function tbl:new()
  print(self)
end

print(tbl) -- table: 000000000026DC60
tbl:new()  -- table: 000000000026DC60, so self is just the table object

-- ###############################################################
-- the use of setmetatable https://www.youtube.com/watch?v=CYxMfVy5W00
local john = {}
print(john.money) -- nil as it's not in the table

local bill = {money = 9999999}
print(bill.money) -- 9999999

local metatable = {__index = bill} -- any table with this as metatable will look to bill
setmetatable(john, metatable)
print(john.money) -- 9999999

John = {}
John.prototype = {speed=5, strength=100}    -- doesn't have to be prototype, can be called whatever we want
John.metatable = {__index = John.prototype}

function John:new()
  local o = {}
  setmetatable(o, John.metatable)
  return o
end

local john = John:new()
print(john.speed)    -- 5
print(john.strength) -- 100

-- ###############################################################
-- the use of __index
tbl = {}
tbl.__index = {"a", "b", "c"}
for k,v in pairs(tbl) do
  -- will just be the one value
  print(k) -- __index
  print(v) -- table: 00000000004BDFD0
  print(type(v)) -- table
  if type(v) == "table" then
    for a, b in pairs(v) do
      print(a, b)
      --[[1 a
          2 b
          3 c]]
    end
  end
end

-- ###############################################################
-- from https://www.tutorialspoint.com/lua/lua_object_oriented.htm
-- Meta class
Rectangle = {area = 0, length = 0, breadth = 0}
Rectangle.__index = Rectangle

-- Derived class method new

function Rectangle:new (o, length, breadth)
   o = o or {}
   setmetatable(o, self)
   --self.__index = self -- we define this by Rectangle instead
   self.length = length or 0
   self.breadth = breadth or 0
   self.area = length*breadth;
   return o
end

-- Derived class method printArea

function Rectangle:printArea ()
   print("The area of Rectangle is ",self.area)
end

r = Rectangle:new(nil, 10, 20)
print(r.area) -- 200
r:printArea() -- The area of Rectangle is   200
