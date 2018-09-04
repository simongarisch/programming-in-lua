#include <stdarg.h>
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

// error function defined in 24.1
void error (lua_State *L, const char *fmt, ...) {
  va_list argp;
  va_start(argp, fmt);
  vfprintf(stderr, fmt, argp);
  va_end(argp);
  lua_close(L);
  exit(EXIT_FAILURE);
}

// Lua 5.1 also offers a specialized version of lua_settable
// for string keys, called lua_setfield p.g. 233
void setfield (lua_State *L, const char *index, int value) {
  lua_pushnumber(L, (double)value/MAX_COLOR);
  lua_setfield(L, -2, index);
}

// defines a single color
void setcolor (lua_State *L, struct ColorTable *ct) {
  lua_newtable(L); /* creates a table */
  // create index and value lua table pairs with setfield  
  setfield(L, "r", ct->red);   /* table.r = ct->r */
  setfield(L, "g", ct->green); /* table.g = ct->g */
  setfield(L, "b", ct->blue);  /* table.b = ct->b */
  lua_setglobal(L, ct->name);  /* ’name’ = table */
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

int main (void) {
  lua_State *L = luaL_newstate(); /* opens Lua */
  luaL_openlibs(L);               /* opens the standard libraries */
 
  // register the different colors with Lua
  int i = 0;
  while(colortable[i].name != NULL){
    setcolor(L, &colortable[i++]);	  
  }
  
  // run the configuration file
  const char *fname = "get_background.lua";
  if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0)){
    puts("Cannot run get_rgb.lua file!");
	return -1;
  }
  
  //=============================================
  unsigned char red, green, blue;
  lua_getglobal(L, "background");
  if (lua_isstring(L, -1)) { /* value is a string? */
    const char *colorname = lua_tostring(L, -1); /* get string */
    int i; /* search the color table */
	for (i = 0; colortable[i].name != NULL; i++) {
	  if (strcmp(colorname, colortable[i].name) == 0){
	    break;
	  }
	}
	
	if (colortable[i].name == NULL){ /* string not found? */
	  error(L, "invalid color name (%s)", colorname);
	}else { /* use colortable[i] */
	  red = colortable[i].red;
	  green = colortable[i].green;
	  blue = colortable[i].blue;
	  printf("%d,%d,%d", red, green, blue);
	}
  } else if (lua_istable(L, -1)) {
    red = getfield(L, "r");
	green = getfield(L, "g");
	blue = getfield(L, "b");
  } else{
	  error(L, "invalid value for 'background'");
  }
  //=============================================

  lua_close(L);
  return 0;
}