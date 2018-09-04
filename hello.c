#include <stdio.h>

void say_hello();

int main(void)
{
  say_hello();
  return 0;
}

void say_hello(void)
{
    puts("Hello from C!");
}