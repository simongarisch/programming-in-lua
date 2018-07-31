-- when we write a file we have full control over what is going on
-- When we read a file, on the other hand, we don't know what to expect
-- a robust program should handle bad files gracefully

-- if we are going to create the file for our own use, we can use Lua
-- constructors as out format

-- instead of
-- Donald E. Knuth,Literate Programming,CSLI,1992
-- Jon Bentley,More Programming Pearls,Addison-Wesley,1990

-- we can write, remember Entry{code} is the same as Entry({code})
--[[
Entry{"Donald E. Knuth",
      "Literate Programming",
      "CSLI",
      1992}
      
Entry{"Jon Bentley",
      "More Programming Pearls",
      "Addison-Wesley",
      1990}
]]

-- we have put these entries into file data (in local direcctory)
local authors = {}
function Entry(b) authors[b[1]] = true end
dofile("data")
for name in pairs(authors) do print(name) end
-- prints
-- Donald E. Knuth
-- Jon Bentley
print(string.rep("*", 30))

-- 12.2 serialization
function serialize(o)
  if type(o) == "number" then
    io.write(o)
  elseif type(o) == "string" then
    io.write(string.format("%q", o))
  elseif type(o) == "table" then
    io.write("{\n")
    for k,v in pairs(o) do
      io.write(" ", k, " = ")
      serialize(v)
      io.write",\n"
    end
    io.write("}\n")
  else
    error("cannot serialize a " .. type(o))
  end
end

serialize{"this", "is", "a", "table"}

