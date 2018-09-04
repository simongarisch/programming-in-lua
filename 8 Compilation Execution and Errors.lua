-- although we refer to Lua as an interpreted language,
-- Lua always precompiles to an intermediate form before running

-- Lua provides all the functionality of dynamic linking in a single function,
-- called package.loadlib.
-- I've put a file called hello.c in the local directory
-- https://stackoverflow.com/questions/14884126/build-so-file-from-c-file-using-gcc-command-line
-- gcc -c -fPIC hello.c -o hello.o
-- gcc hello.o -shared -o libhello.so

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
print(file_exists("./libhello.so"))

-- we'll cover more on the C side later
-- whenever an error occurs, Lua ends the current chunk and returns to the application
-- we can explicitly raise with the error function

local raise = false
if raise then
  error("Raising an error here!")
end

-- assert for if then else checking
local x = tonumber("xxx")
print(x) -- nil as the conversion failed
-- assert will raise an error on nil or false

print(_VERSION) -- Lua 5.2 ... there is no goto statement in Lua 5.1
raise = false
if not raise then goto skippy end
assert(tonumber("xxx"), "Failed to do number conversion!")

::skippy::
print(string.rep("*", 30))

-- Lua evaluates its arguments before calling the function, so beware of e.g.
-- assert(tonumber(n), "invalid input: " .. n .. " is not a number")

local file, msg
repeat
  print("Enter a file name:")
  local name = "hello.c" -- they had io.read()
  file = assert(io.open(name, "r"))
until file
print(file) -- file (000007FEFE432B10)

-- if you want to handle errors in Lua you must use the pcall (protected call) function
-- to encapsulate your code
-- if there are no errors then pcall returns true plus any values returned by the call
-- https://stackoverflow.com/questions/38796108/lua-error-handling-pcall
a = {1,2,3,4}

function check()
   return #a[1]
end

print(pcall(check)) -- false ...rogramming-in-lua\8 Compilation Execution and Errors.lua:57: attempt to get length of field '?' (a number value)
local v, message = pcall(check)
print(v)       -- false
print(message) -- ...rogramming-in-lua\8 Compilation Execution and Errors.lua:57: attempt to get length of field '?' (a number value)

function f(v)
   return v + 2
end

a, b = pcall(f, 1)
print(a, b) -- true 3

a, b = pcall(f, "a")
print(a, b) -- false  ...rogramming-in-lua\8 Compilation Execution and Errors.lua:66: attempt to perform arithmetic on local 'v' (a string value)

-- error messages and tracebacks
print(debug.traceback())
--stack traceback:
--  ...rogramming-in-lua\8 Compilation Execution and Errors.lua:76: in main chunk
--  [string "main"]:1: in main chunk