/*Stack.h*/
#ifndef __StackClassH__
#define __StackClassH__

#include <iostream>
#include <assert.h>    // For error-checking purposes

using namespace std;
//-------------------------------------------------
// Main structure of Stack Class:
//-------------------------------------------------
//
template <class Elem>
class Stack
{
  public:
      Stack(int MaxSize=500);
      Stack(const Stack<Elem> &OtherStack);
      ~Stack(void);

      inline void Push(const Elem &Item); // Adds Item to the top
      inline Elem Pop(void);              // Returns Item from the top
      inline void printstack();

  protected:
      Elem     *Data;           // The actual Data array
      int       CurrElemNum;    // The current number of elements
      const int MAX_NUM;        // Maximum number of elements
};

//-------------------------------------------------
// Implementation of Stack Class:
//-------------------------------------------------

// Stack Constructor function
template <class Elem>
Stack<Elem>::Stack(int MaxSize) :
MAX_NUM( MaxSize )    // Initialize the constant
{
  Data = new Elem[MAX_NUM];
  CurrElemNum = 0;
}

// Stack Destructor function
template <class Elem>
Stack<Elem>::~Stack(void)
{
  delete[] Data;
}

// Push() function
template <class Elem>
inline void Stack<Elem>::Push(const Elem &Item)
{
  assert(CurrElemNum < MAX_NUM);
                             
  Data[CurrElemNum++] = Item;
}

// Pop() function
template <class Elem>
inline Elem Stack<Elem>::Pop(void)
{
  assert(CurrElemNum > 0);

  return Data[--CurrElemNum];
}

template <class Elem>
inline void Stack<Elem>::printstack()
{
  cout << "Top of Stack on Left Side:";
  for( int i = 0; i < CurrElemNum; i++ )
    cout << " " << Data[CurrElemNum - i - 1];
  cout <<endl;
}

#endif
