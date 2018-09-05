#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

void error (lua_State *L, const char *fmt, ...);
void call_va(lua_State *L, const char *func, const char *sig, ...);

int main (void) {
  lua_State *L = luaL_newstate(); /* opens Lua */
  luaL_openlibs(L);               /* opens the standard libraries */
  
  lua_close(L);
  return 0;
}

// error function defined in 24.1
void error (lua_State *L, const char *fmt, ...) {
  va_list argp;
  va_start(argp, fmt);
  vfprintf(stderr, fmt, argp);
  va_end(argp);
  lua_close(L);
  exit(EXIT_FAILURE);
}

void call_va(lua_State *L, const char *func, const char *sig, ...){
  va_list v1;
  int narg, nres; // number of arguments and results
  
  va_start(v1, sig);
  lua_getglobal(L, func); // push function
  
  // more to add here...
  
  nres = strlen(sig); // number of expected results
  
  // do the call
  if(lua_pcall(L, narg, nres, 0) != 0){
    error(L, "error calling '%s': %s", func, lua_tostring(L, -1));
  }
}