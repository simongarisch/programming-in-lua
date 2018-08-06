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
