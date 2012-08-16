#include<iostream> 
#include"queue.h"

using namespace std;

int main()
{
  queue<int> t;
  t.enqueue(4);
  t.printqueue();
  t.enqueue(1);
  t.printqueue();
  t.enqueue(3);
  t.printqueue();
  t.dequeue();
  t.printqueue();
  t.enqueue(8);
  t.printqueue();
  t.dequeue();
  t.printqueue();

  return 0;
}
