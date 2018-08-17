-- the debug library does not give you a debugger in Lua,
-- but it offers all of the primatives you need for writing
-- your own debugger. 

-- the debug library comprises two kinds of functions:
-- introspective functions and hooks. Introspective functions
-- allow us to inspect several aspects of the running program,
-- such as its stack of active functions, current line of
-- execution, and names / values of local variables. Hooks
-- allow us to trace the execution of a program.

-- a stack level is a number that refers to a particular function
-- that is active at the moment.

-- 23.1 Introspective facilities
-- main introspective function is the debug.getinfo(foo) function.

function foo(a, b)
  result = a + b
  return result
end

info = debug.getinfo(foo) -- returns a table with function data
print(info) -- table: 00000000003AD920
for k,v in pairs(info) do
  print(k,v)
end
--[[
lastlinedefined 21
istailcall  false
currentline -1
short_src U:\git\programming-in-lua\23 The Debug Library.lua
source  @U:\git\programming-in-lua\23 The Debug Library.lua
func  function: 0000000000530330
namewhat  
what  Lua
isvararg  false
nups  1
nparams 2
linedefined 18
]]


