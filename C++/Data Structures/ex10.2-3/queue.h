#include<iostream> 

using namespace std;
 
// Creating a NODE Structure
template<class Elem>
struct node
{
   Elem data;
   struct node *next;
};
 
// Creating a class QUEUE
template<class Elem>
class queue
{
   private:
     struct node<Elem> *frnt,*rear;
   public:
      queue(); // constructure
      void enqueue(Elem); // to insert an element
      void dequeue();  // to delete an element
      void printqueue(); // to show the stack
};

// constructure
template<class Elem>
queue<Elem>::queue() 
{
  frnt=rear=NULL;
}

// Insertion
template<class Elem>
void queue<Elem>::enqueue(Elem value)
{
   struct node<Elem> *ptr;
   ptr=new node<Elem>;
   ptr->data=value;
   ptr->next=NULL;
   if(frnt==NULL)
      frnt=ptr;
   else
      rear->next=ptr;
   rear=ptr;
}

// Deletion
template<class Elem>
void queue<Elem>::dequeue()
{
   if(frnt==NULL)
   {
      cout<<"\nQueue is empty!!";
      return;
   }
   struct node<Elem> *temp;
   temp=frnt;
   frnt=frnt->next;
   delete temp;
}
 
// Show Queue
template<class Elem>
void queue<Elem>::printqueue()
{
   struct node<Elem> *ptr1=frnt;
   if(frnt==NULL)
   {
      cout<<"The Queue is empty!!";
      return;
   }
   cout<<"Front of queue on Left Side: ";
   while(ptr1!=NULL)
   {
      cout<<ptr1->data<<" ";
      ptr1=ptr1->next;
   }
   cout<<"\n";
}
