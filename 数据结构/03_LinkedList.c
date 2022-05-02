#include <stdio.h>

struct Node
{
    int element;
    Node *next;
};


struct LinkedList
{
    int size;
    Node *fitst;
};

void clear();
int size();
bool isEmpty();
bool contains(int e);
void add(int e);
int get(int index);
int set(int e);
void add(int index, int e);
void remove(int index);
int indexOf(int e);

int main()
{
    


    return 0;
}