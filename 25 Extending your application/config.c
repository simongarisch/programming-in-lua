#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

void load (lua_State *L, const char *fname, int *w, int *h);

int main (void) {
  lua_State *L = luaL_newstate(); /* opens Lua */
  luaL_openlibs(L);               /* opens the standard libraries */
  
  int w=500, h=500;   // create width and height
  int *ptr_w, *ptr_h; // and get pointers to these
  ptr_w = &w;
  ptr_h = &h;

  const char *fname = "lua_config.lua";
  load(L, fname, ptr_w, ptr_h);
  lua_close(L);
  printf("width is %d, height is %d\n", w, h);
  return 0;
}

void load (lua_State *L, const char *fname, int *w, int *h) {
  if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0))
    puts("Cannot run config file!");
  lua_getglobal(L, "width");
  lua_getglobal(L, "height");
  if (!lua_isnumber(L, -2)){
    puts("'width' should be a number\n");
	return;
  }
  if (!lua_isnumber(L, -1)){
    puts("'height' should be a number\n");
	return;
  }
  *w = lua_tointeger(L, -2);
  *h = lua_tointeger(L, -1);
}