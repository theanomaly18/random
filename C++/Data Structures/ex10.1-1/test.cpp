#include <iostream>
#include "Stack.h"

using namespace std;

int main()
{
  //main
  Stack<int> t(10);
  t.Push(4);
  t.printstack();
  t.Push(1);
  t.printstack();
  t.Push(3);
  t.printstack();
  t.Pop();
  t.printstack();
  t.Push(8);
  t.printstack();
  t.Pop();
  t.printstack();
  return 0;
}
