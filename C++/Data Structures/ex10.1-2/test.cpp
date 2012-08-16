#include <iostream>
#include "Stack.h"

using namespace std;

int main( )
{
  //main
  Stack<int> t(10);
  t.Push1(4);
  t.printstack();
  t.Push2(1);
  t.printstack();
  t.Push1(3);
  t.printstack();
  t.Push2(5);
  t.printstack();
  t.Pop1();
  t.printstack();
  t.Push2(8);
  t.printstack();
  t.Pop2();
  t.printstack();
  return 0;
}
