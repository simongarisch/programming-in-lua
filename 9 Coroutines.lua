-- a couroutine is similar to a thread
-- a program with threads runs several threads concurrently
-- coroutines, on the other hand, are collaborative

-- Lua packs all of its coroutine related functions in the
-- coroutine table. The create function creates a new coroutine.

co = coroutine.create(function () print "Hi" end)
print(co) -- thread: 000000002307D090

-- coroutines in Lua can have 4 different states:
-- suspended, running, dead, normal
-- coroutines start in the suspended state

print(coroutine.status)     -- function: 00000000236CBB30
print(coroutine.status(co)) -- suspended

coroutine.resume(co) -- prints 'Hi'
print(coroutine.status(co)) -- dead

-- the real power of coroutines stems from the yield function,
-- which allows a running coroutine to suspend its own execution
-- so that it can be resumed later
co = coroutine.create(function ()
  for i=1, 10 do
    print("co", i)
    coroutine.yield()
  end
end)
print(coroutine.status(co)) -- suspended
coroutine.resume(co) -- co  1
print(coroutine.status(co)) -- suspended
coroutine.resume(co) -- co  2
print(coroutine.status(co)) -- suspended

while (coroutine.status(co) == "suspended") do
  coroutine.resume(co)
end
print(coroutine.status(co)) -- dead
print(coroutine.resume(co)) -- false  cannot resume dead coroutine
-- note that resume runs in protected mode

-- a pair resume-yield can exchange data
co = coroutine.create(function(a, b, c)
  print("co", a, b, c)
end)
coroutine.resume(co, 1, 2, 3) -- co 1 2 3

co = coroutine.create(function(a, b)
  coroutine.yield(a+b, a-b)
end)
print(coroutine.resume(co, 20, 10)) -- true 30  10 ... on pg 94

-- Lua offers asymmetric coroutines

-- 9.2 Pipes and Filters: the producer - consumer problem
function receive(prod)
  local status, value = coroutine.resume(prod)
  return value
end

function send(x)
  coroutine.yield(x)
end

function producer()
  return coroutine.create(
    function()
      t = {"a", "b", "c"}
      for i=1, #t do
        send(t[i])
      end
    end
  )
end

function filter(prod)
  return coroutine.create(
    function ()
      local x = receive(prod) -- get new value
      send(x) -- send it to the consumer
    end
  )
end

function consumer(prod)
  local x = receive(prod)
  print(x)
end

-- we can extend the design with filters, which are tasks that
-- sit between the producer and the consumer doing some kind of 
-- transformation in the data
p = producer()
print(p) -- thread: 00000000224ED900
print(coroutine.status(p)) -- suspended
f = filter(p)
consumer(p) -- 'a' so we get the first letter

print(coroutine.status(p)) -- suspended

-- more on Lua coroutines from here... http://lua-users.org/wiki/CoroutinesTutorial
-- Coroutines in Lua are not operating system threads or processes
-- Only one coroutine ever runs at a time, and it runs until it activates another coroutine, or yields (returns to the coroutine that invoked it).
--  Coroutines are a way to express multiple cooperating threads of control in a convenient and natural way,
-- but do not execute in parallel, and thus gain no performance benefit from multiple CPU's.
-- However, since coroutines switch much faster than operating system threads and do not typically require complex and sometimes expensive locking
-- mechanisms, using coroutines is typically faster than the equivalent program using full OS threads.

-- simple usage
function foo()
  print("foo", 1)
  coroutine.yield()
  print("foo", 2)
end

co = coroutine.create(foo)
print(type(co)) -- thread
print(coroutine.status(co)) -- suspended
-- The state suspended means that the thread is alive, and as you would expect, not doing anything.
-- To start the thread we use the coroutine.resume() function.
coroutine.resume(co) -- foo 1
print(coroutine.status(co)) -- suspended
coroutine.resume(co) -- foo 2
print(coroutine.status(co)) -- dead
print(string.rep("*", 30))

-- a more complicated example
function odd(x)
  print("A: odd", x)
  coroutine.yield(x)
  print("B: odd", x)
end

function even(x)
  print("C: even", x)
  if x==2 then return x end
  print("D: even", x)
end

co = coroutine.create(
  function (x)
    for i=1,x do
      if i==3 then coroutine.yield(-1) end
      if i % 2 == 0 then even(i) else odd(i) end
    end
  end
)

count = 1
while coroutine.status(co) ~= "dead" do
  print("---", count); count = count + 1
  errorfree, value = coroutine.resume(co, 5) -- resume / start co passing in x = 5
  print("E: errorfree, value, status", errorfree, value, coroutine.status(co))
end
--[[
--- 1
A: odd  1
E: errorfree, value, status true  1 suspended
--- 2
B: odd  1
C: even 2
E: errorfree, value, status true  -1  suspended
--- 3
A: odd  3
E: errorfree, value, status true  3 suspended
--- 4
B: odd  3
C: even 4
D: even 4
A: odd  5
E: errorfree, value, status true  5 suspended
--- 5
B: odd  5
E: errorfree, value, status true  nil dead
]]