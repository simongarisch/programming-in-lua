-- the io library offers two different models for file manipulation

-- the simple model assumes a current input file and a current
-- output file, and its IO operations operate on these files.and

-- the complete model uses explicit file handles

-- 21.1 The simple I/O model
io.write("sin (3) = ", math.sin(3), "\n")
io.write(string.format("sin (3) = %.4f\n", math.sin(3)))
-- sin (3) = 0.14112000805987
-- sin (3) = 0.1411
print(string.rep("*", 30))

-- the io.read function reads strings from the current
-- input file. Its arguments control what is read...
-- "*all" reads the whole file
-- "*line" reads the next line
-- "*number" reads a number
-- num reads a string with up to num characters
-- https://www.tutorialspoint.com/lua/lua_file_io.htm

file = io.open("hello.c", "r") -- open a file in read mode
io.input(file) -- sets this as the default input file
print(io.read("*all")) -- read and print the whole file
print(string.rep("*", 30))

-- 21.2 The complete I/O model
-- for more control over the I/O you can use the complete model.
-- A central concept in this model is the file handle, which is
-- equivalent to streams (FILE*) in C.

-- a typical idiom to check for errors is
local f = assert(io.open("hello.c", r))
print(f) -- file (00000000745B9F70)
local c = f:read("*all")
f:close()
print(c) -- prints like the previous example
print(string.rep("*", 30))


