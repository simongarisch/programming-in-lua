/*
http://www.troubleshooters.com/codecorn/lua/lua_c_calls_lua.htm
You'll need to install cygwin and the lua dependencies lua-devel
http://cygwin.com/cygwin-ug-net/cygcheck.html

For a list of what we need from Cygwin
https://www.safaribooksonline.com/library/view/creating-solid-apis/9781491986301/ch01.html
Package name	Category		Description
gcc-core		Devel			C compiler
gcc-g++			Devel			C++ compiler
git				Devel			The git version control system
lua				Interpreters	The Lua interpreter
lua-devel		Interpreters	Lua’s C header files and library file
make			Devel			A tool to help build binaries from source code

Add to Path environment variable C:\cygwin64\bin
We can then compile with...
C:\\cygwin64\\bin\\gcc -o basic basic.c -llua
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

int main (void) {
  char buff[256];
  int error;
  lua_State *L = luaL_newstate(); /* opens Lua */
  luaL_openlibs(L); /* opens the standard libraries */
  while (fgets(buff, sizeof(buff), stdin) != NULL) {
    error = luaL_loadbuffer(L, buff, strlen(buff), "line") ||
    lua_pcall(L, 0, 0, 0);
    if (error) {
      fprintf(stderr, "%s", lua_tostring(L, -1));
      lua_pop(L, 1); /* pop error message from the stack */
    }
  }
  lua_close(L);
  return 0;
}