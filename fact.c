#include <stdio.h>

int fact(int n){
  // implement a factorial func to test
  // speed vs Python and Lua
  if(n == 0){
    return(1);
  }else{
    return(n * fact(n-1))
  }
}

void main(){
  // test this fact function
  puts(fact(3));
  getch();
}