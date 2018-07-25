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
