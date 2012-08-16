#include "getip.h"
#include <iostream>

using namespace std;

int main(int argc, char *argv[])
{
	if(argc == 1)
	{
    usage();
    exit(2);
  }  
  
	char *ip;
	const char *host = argv[1];
	
	ip = getip(host);
	cout << ip <<endl;
	
	return 0;
}
