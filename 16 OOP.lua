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





