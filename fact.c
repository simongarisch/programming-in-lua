#include <stdio.h>
#include <stdlib.h>

int fact(int n){
  // implement a factorial func to test
  // speed vs Python and Lua
  if(n == 0){
    return(1);
  }else{
    return(n * fact(n-1));
  }
}

int main(){
  // test this fact function
  printf("%d\n", fact(3));
  getchar();
  return 0;
}