--[[
An important use of Lua is as a configuration language

Suppose you have a C program that produces a window and you
want the user to be able to specify the initial size.
You could use a lua configuration file with something like:
(See the config.lua file...)

--define window size
width = 300
height = 300

Within config.c the width and height start as 500, 500 by default
The lua_config.lua then specifies these each as 300.

See the config.c and get_rgb.c for reading values and tables.
Next we can work on color structs in C and associated Lua tables.

]]