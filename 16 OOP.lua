-- like objects, tables have a state

Account = {balance = 0}
function Account.withdraw(v)
  Account.balance = Account.balance - v
end

-- the use of the a global name Account inside the
-- function is a bad programming practice.

-- a more flexible approach is to operate on the receiver of the operation
function Account.withdraw (self, v)
  self.balance = self.balance - v
end

-- now we can do
a1 = Account
a1.withdraw(a1, 100);
print(a1.balance) -- -100

-- now that we have the self parameter we can use the same method
-- for many objects
a2 = {balance=500, withdraw=Account.withdraw}
a2.withdraw(a2, 100)
print(a2.balance) -- 400

-- the use of the self parameter is a central point in OOP
-- Lua can also hide this parameter using the colon operator
-- (although you can still)  use self or this inside a method).
Account = {balance = 1000}
function Account:withdraw(v)
  self.balance = self.balance - v
end

a = Account
a:withdraw(100)
print(a.balance) -- 900
print(string.rep("*", 30))

-- the effect of the colon is to add an extra hidden parameter
-- in the method definition and an extra argument in a method
-- call
Account = {
  balance = 0;
  withdraw = function (self, v)
               self.balance = self.balance - v
             end
}

function Account:deposit(v)
  self.balance = self.balance + v
end

Account.deposit(Account,200)
Account:withdraw(100)
print(Account.balance) -- 100

-- Classes
-- Lua does not have the concept of a class
-- Nevertheless, its not difficult to emulate classes in Lua
-- following the lead from prototype languages such as Self 
-- and NewtonScript. We can use prototypes in Lua with the
-- setmetatable(a, {__index = b})
-- after that, a looks up in b for any operation it does not
-- have

function Account:new(o)
  o = o or {} -- create a table if the user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

a = Account:new{balance = 1000}
a:deposit(100)
print(a.balance) -- 1100

-- Inheritance
Account = {balance = 0}
function Account:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Account:deposit(v)
  self.balance = self.balance + v
end

function Account:withdraw(v)
  if v > self.balance then error("insufficient funds") end
  self.balance = self.balance - v
end

-- if we want to derive a class that allows the customer to go into overdraft
SpecialAccount = Account:new() -- inherits all operations for the base class

s = SpecialAccount:new{limit = 1000} -- now the self parameter refers to SpecialAccount

function SpecialAccount:withdraw(v)
  if v - self.balance >= self:getLimit() then
    error("insufficient funds")
  end
  self.balance = self.balance - v
end

function SpecialAccount:getLimit()
  return self.limit or 0
end

s:deposit(100)
s:withdraw(400)
print(s.balance) -- -300
print(string.rep("*", 30))

-- multiple inheritance
-- here is an alternative implementation that allows for 
-- multiple inheritance in Lua
Named = {}
function Named:getname()
  return self.name
end

function Named:setname(n)
  self.name = n
end

-- look up for k in list of tables 'plist'
local function search(k, plist)
  for i=1,#plist do
    local v = plist[i][k] -- try i-th superclass
    if v then return v end
  end
end

function createClass(...)
  local c = {}
  local parents = {...}
  
  -- class will search for each method in the list of
  -- its parents
  setmetatable(c, {
    __index = function(t, k)
      return search(k, parents)
    end
  })
  
  -- prepare c to be the metatable of this instance
  c.__index = c
  
  -- define a new constructor for this class
  function c:new(o)
    o = o or {}
    setmetatable(o, c)
    return o
  end
  
  return c -- return the new class
end

-- we can then create a class called NamedAccount that is
-- a subclass of both Account and Named...
NamedAccount = createClass(Account, Named)
account = NamedAccount:new{name="Paul"}
print(account:getname()) -- Paul
print(account.balance)   -- 0
account:deposit(100)
account:withdraw(50)
print(account.balance)   -- 50
print(string.rep("*", 30))
-- there are also ways to make the inherited method lookup
-- faster (by storing lookup results)

-- privacy
-- the basic idea of this alternative design is to represent
-- each object through two tables: one for its state and
-- another for its operations (or interface)
-- representing a bank account with this design
function newAccount(initialBalance)
  local self = {balance = initialBalance}
  local withdraw = function (v)
                     self.balance = self.balance - v
                   end
  local deposit = function (v)
                    self.balance = self.balance + v
                  end
  local getBalance = function () return self.balance end
  return{
    withdraw = withdraw,
    deposit = deposit,
    getBalance = getBalance
  }
end

account = newAccount(100)
account.deposit(100)
account.withdraw(50)
print(account.getBalance()) -- 150
print(string.rep("*", 30))
print("")

-- first the function creates a table to keep the internal
-- object state and stores it in the local variable self
-- then, the function creates methods for this object
-- finally, mapped method names are returned
-- this gives full privacy to everything stored in the 
-- self table.

-- the single method approach
-- use a get and set example... pretty straightforward
