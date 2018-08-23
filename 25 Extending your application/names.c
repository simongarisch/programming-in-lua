#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

int main (void) {
  lua_State *L = luaL_newstate(); /* opens Lua */
  luaL_openlibs(L);               /* opens the standard libraries */
 

  //const char *fname = "config.lua";
  lua_close(L);
  puts("TESTING 123...")
  return 0;
}