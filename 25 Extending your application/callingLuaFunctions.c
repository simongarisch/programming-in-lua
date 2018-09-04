#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

// call a function 'f' defined in Lua
double f(lua_State *L, double x, double y); // our forward declarations
void error (lua_State *L, const char *fmt, ...);

int main(){
  lua_State *L = luaL_newstate(); /* opens Lua */
  luaL_openlibs(L);               /* opens the standard libraries */
  
  // run the lua file containing the Lua definition for 'f'
  const char *fname = "callingLuaFunctions.lua";
  if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0)){
    error(L, "Cannot run get_rgb.lua file!");
	return -1;
  }
  
  double result = f(L, 2.5, 7.5);
  printf("result = %f", result);
  
  lua_close(L);
  return 0;	
}

void error (lua_State *L, const char *fmt, ...) {
  va_list argp;
  va_start(argp, fmt);
  vfprintf(stderr, fmt, argp);
  va_end(argp);
  lua_close(L);
  exit(EXIT_FAILURE);
}

double f(lua_State *L, double x, double y){
  double z;
  
  // push functions and arguments
  lua_getglobal(L, "f"); // function to be called
  lua_pushnumber(L, x);  // push 1st argument
  lua_pushnumber(L, y);  // push second argument
  
  // do the call: 2 arguments, 1 result
  if(lua_pcall(L,2,1,0) != 0){
    error(L, "error running function 'f': %s",
			 lua_tostring(L,-1));
  }
  z = lua_tonumber(L, -1);
  lua_pop(L, 1); // pop returned value
  return z;
}