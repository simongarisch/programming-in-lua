#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#define MAX_COLOR 255

int getfield (lua_State *L, const char *key); // forward declaration

int main (void) {
  lua_State *L = luaL_newstate(); /* opens Lua */
  luaL_openlibs(L);               /* opens the standard libraries */
  
  int r=MAX_COLOR, g=MAX_COLOR, b=MAX_COLOR; // create RGB values
  int *ptr_r = &r;
  int *ptr_g = &g;
  int *ptr_b = &b;

  const char *fname = "get_rgb.lua";
  if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0)){
    puts("Cannot run get_rgb.lua file!");
	return -1;
  }
  
  lua_getglobal(L, "background");
  if (!lua_istable(L, -1)){
    puts("'background' is not a table!");
	return -1;
  }
  
  // you should also check these values against MAX_COLOR
  *ptr_r = getfield(L, "r");
  *ptr_g = getfield(L, "g");
  *ptr_b = getfield(L, "b");
  
  lua_close(L);
  printf("%d, %d, %d\n", r, g, b);
  return 0;
}

/* assume that table is on the stack top */
int getfield (lua_State *L, const char *key) {
  int result;
  lua_pushstring(L, key);
  lua_gettable(L, -2); /* get background[key] */
  if (!lua_isnumber(L, -1)){
    puts("invalid component in background color!");
  }
  result = (int)lua_tonumber(L, -1);
  lua_pop(L, 1); /* remove number */
  return result;
}