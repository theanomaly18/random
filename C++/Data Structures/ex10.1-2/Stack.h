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

      inline void Push1(const Elem &Item); // Adds Item to the top
      inline void Push2(const Elem &Item); // Adds Item to the bottom
      inline Elem Pop1(void);              // Returns Item from the top
      inline Elem Pop2(void);		   // Returns Item from the bot
      inline void printstack();

  protected:
      Elem     *Data;           // The actual Data array
      int       CurrElemNum;    // The current number of elements
      int       CurrBotElem;	// Current Bottom Elem index
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
  CurrBotElem = MAX_NUM-1;
}

// Stack Destructor function
template <class Elem>
Stack<Elem>::~Stack(void)
{
  delete[] Data;
}

// Push1() function
template <class Elem>
inline void Stack<Elem>::Push1(const Elem &Item)
{
  assert(CurrElemNum <= CurrBotElem);
                             
  Data[CurrElemNum++] = Item;
}

// Push2() function
template <class Elem>
inline void Stack<Elem>::Push2(const Elem &Item)
{
  assert(CurrBotElem >= CurrElemNum);
  assert(CurrBotElem < MAX_NUM);                  
  Data[--CurrBotElem] = Item;
}

// Pop1() function
template <class Elem>
inline Elem Stack<Elem>::Pop1(void)
{
  assert(CurrElemNum > 0);

  return Data[--CurrElemNum];
}

// Pop2() function
template <class Elem>
inline Elem Stack<Elem>::Pop2(void)
{
  assert(CurrBotElem < MAX_NUM);

  return Data[CurrBotElem++];
}

template <class Elem>
inline void Stack<Elem>::printstack()
{
  cout << "Top of Stack1 on Left Side, Top of Stack2 on Right Side:";
  for( int i = 0; i < CurrElemNum; i++ )
    cout << " " << Data[CurrElemNum - i - 1];
  for( int i = CurrElemNum; i < CurrBotElem+1; i++ )
    cout << " -";
  if( CurrBotElem != MAX_NUM-1 )
  {
    for( int i = 0; i < MAX_NUM - CurrBotElem - 1; i++ )
      cout << " " << Data[MAX_NUM - 2 - i];
  }
  cout <<endl;
}

#endif
