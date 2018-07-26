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
