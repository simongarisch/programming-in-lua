-- here we cover how to write iterators for the generic for

local t = {"some", "table", "values"}
function values(t)
  local i = 0
  return function () i = i + 1; return t[i] end
end

for element in values(t) do
  print(element)
end
-- some
-- table
-- values

-- stateless iterator: does not keep any state by itself
for i, v in ipairs(t) do
  print(i, v)
end

-- iterators with complex state: simplest solution is to use closures
function elementIterator (collection)
   local index = 0
   local count = #collection
   -- The closure function is returned
   return function ()
      index = index + 1
      if index <= count
      then
         -- return the current element of the iterator
         return collection[index]
      end
   end
end

for element in elementIterator(t)
do
   print(element)
end
print(string.rep("*", 30))
