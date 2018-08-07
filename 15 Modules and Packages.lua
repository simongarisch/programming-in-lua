-- a module is a library that can be loaded through
-- require and that defines one single global name
-- containing a table. Everything that the module 
-- exports, including functions and constants, it
-- defines inside this table, which works as a 
-- namespace. A well-behaved module also arranges
-- for require to return this table.and

-- an an example
local lib2 = require "lib2"
print(lib2.twice(2)) -- 4

local lib2 = require "lib2"
local f = lib2.twice
print(f(2)) -- 4

-- if require finds a lua file for the given module
-- it loads it with loadfile. If it finds a C library
-- it loads it with loadlib. These only load some code,
-- but they don't run it.

-- require marks the package.loaded as true and returns
-- if you try to load again. To force require into 
-- loading the same library twice...
package.loaded["lib2"] = nil
local lib2 = require "lib2"

-- the basic approach for writing modules
-- create a table, put all of the functions
-- we want to export inside it, and return this table.
-- lib2 is an example of this basic approach.

-- using environments
-- this assists in not muddying the global envt
-- see the example for libEnv
local libEnv = require "libEnv"
print(libEnv)     -- table: 00000000234ECF10
print(libEnv.add) -- function: 000000002318CE60

for k,v in pairs(libEnv) do
  print(k, v)
end
--[[
table: 000000002375CF10
function: 000000002296CF50
add function: 000000002296CF50

 instead of writing some of the boilerplate code
 as we did in libEnv.lua, there is a new function
 (from Lua 5.1), called module(), that packs this
 functionality.
 By default, however, module does not provide
 external access. You can allow this with
 'package.seeall'
]]

-- a nice tutorial: http://lua-users.org/wiki/ModulesTutorial
-- for an example with module
print(string.rep("*", 20))
local libEnv2 = require "libEnvWithModule"
print(libEnv2)     -- table: 0000000022F1D050
print(libEnv2.add) -- function: 0000000022E1D310
print(libEnv2.sub) -- function: 0000000022E1D340
print(string.rep("*", 20))

for k,v in pairs(libEnv2) do
  print(k, v)
end
--[[
sub function: 0000000021FCD340
_NAME libEnvWithModule
_PACKAGE  
_M  table: 000000000239D050
add function: 0000000021FCD310
]]

-- submodules and packages
-- lua allows module names to be hierarchial, using
-- a dot to separate name levels.

print(string.rep("*", 30))
print("Now with parent and sub packages...")
print(require) -- function: 0000000023129980
-- notice that require is not available automatically in the parent
-- module as it's part of the global scope _G which has not been
-- exposed
local p = require "parent_module"
print(p) -- table: 000000002357CB50

print(string.rep("*", 30))
for k,v in pairs(p) do
  print(k,v)
end
-- notice that sm1 and sm2 are not local
--[[
sm1 table: 0000000018F8CFB0
_NAME parent_module
_PACKAGE  
parent_func2  function: 0000000018F8F280
_M  table: 0000000018F8CD80
parent_func1  function: 0000000018F8F250
sm2 table: 0000000018F8D190
]]

p.sm1.sub_module_1_func1()
-- Hello from sub_module_1_func1!

-- so this works nicely
-- one thing to check is requiring only specific 
-- global functions, not everything from the global table _G
-- some reading: http://lua-users.org/wiki/LuaModuleFunctionCritiqued