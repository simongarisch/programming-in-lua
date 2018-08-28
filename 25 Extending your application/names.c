#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#define MAX_COLOR 255

struct ColorTable{
  char *name;
  unsigned char red, green, blue;  
}colortable[] = {
  {"WHITE", MAX_COLOR, MAX_COLOR, MAX_COLOR},
  {"RED", MAX_COLOR, 0, 0},
  {"GREEN", 0, MAX_COLOR, 0},
  {"BLUE", 0, 0, MAX_COLOR},
  {NULL, 0, 0, 0} /* sentinel */
};


void setfield (lua_State *L, const char *index, int value) {
  lua_pushnumber(L, (double)value/MAX_COLOR);
  lua_setfield(L, -2, index);
}

/* assume that table is on the stack top */
int getfield (lua_State *L, const char *key) {
  int result;
  lua_pushstring(L, key);
  lua_gettable(L, -2); /* get background[key] */
  if (!lua_isnumber(L, -1))
    puts("invalid component in background color");
  result = (int)lua_tonumber(L, -1) * MAX_COLOR;
  lua_pop(L, 1); /* remove number */
  return result;
}


void setcolor (lua_State *L, struct ColorTable *ct) {
  lua_newtable(L); /* creates a table */
  setfield(L, "r", ct->red); /* table.r = ct->r */
  setfield(L, "g", ct->green); /* table.g = ct->g */
  setfield(L, "b", ct->blue); /* table.b = ct->b */
  lua_setglobal(L, ct->name); /* ’name’ = table */
}

int main (void) {
  lua_State *L = luaL_newstate(); /* opens Lua */
  luaL_openlibs(L);               /* opens the standard libraries */
 
  setcolor(L, colortable);
  
  unsigned char r, g, b;
  int is_table = lua_istable(L,-1);
  printf("Do we have a table? %d\n", is_table);
  
  if(lua_istable(L,-1)){
    r = getfield(L, "r");
	g = getfield(L, "g");
	b = getfield(L, "b");
  }

  //const char *fname = "config.lua";
  lua_close(L);
  return 0;
}