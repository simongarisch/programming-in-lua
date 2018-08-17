-- An overview of the C API

-- Lua is an embedded language / extension language
-- The Lua interpreter (the executable lua) is tiny (<400 lines of code)
-- https://github.com/lua/lua/blob/master/lua.c

-- A major component in the communication between Lua and C in an
-- omnipresent virtual stack. Almost all API calls operate on values
-- in this stack.

-- There are two problems when trying to exchange values between Lua and C
-- 1) the mismatch between a dynamic and a static type system
-- 2) mismatch between automatic and manual memory management.

-- The Lua API does not define anything like a lua_Value type.
-- Instead, it uses an abstract stack to exchange values between Lua and C.
-- Each slot in the stack can hold any Lua value.
-- Lua manipulates the stack in a strict LIFO discipline (Last In, First Out)

-- The API has one push function for each C type that can be represented in Lua:
-- lua_pushnil for the constant nil
-- lua_pushnumber for doubles
-- lua_pushinteger for integers
-- ... lua_pushboolean, lua_pushlstring

--[[
void lua_pushnil (lua_State *L);
void lua_pushboolean (lua_State *L, int bool);
void lua_pushnumber (lua_State *L, lua_Number n);
void lua_pushinteger (lua_State *L, lua_Integer n);
void lua_pushlstring (lua_State *L, const char *s, size_t len);
void lua_pushstring (lua_State *L, const char *s)

To refer to elements in the stack, the API uses indices. The first element pushed
on the stack has index 1, the next one has index 2, and so on until the top.

All API functions may throw an error (that is, call longjmp) instead of returning.
Not all API functions throw exceptions. Functions luaL_newstate, lua_load,
lua_pcall, and lua_close are all safe. Moreover, most other functions can
throw an exception only in case of memory-allocation failure.

When Lua faces an error like 'not enough memory', there is not much that it can do.
It calls a panic function and, if that function returns, exits the application.
You can set your own panic function with the lua_atpanic function.

You must strive to ensure that your add-ons are safe to Lua and provide good error handling.
]]



