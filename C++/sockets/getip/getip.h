#ifndef GETIP_H_
#define GETIP_H_
#include <stdlib.h>
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <string.h> //for perror
void usage()
{
	fprintf(stderr, "USAGE: ./getip host\n\thost: the website hostname (ex: google.com)\n");

}

char *getip(const char *host)
{
	int tcpsock;
	tcpsock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); //create the socket
	struct hostent *hent; //host information
	if(tcpsock < 0)
	{
		perror("Cannot create TCP socket");
		exit(1);
	}
	
	char *ip = (char *)malloc(16); //allocate mem
	memset(ip, 0, 16); //set mem
	
	if((hent = gethostbyname(host)) == NULL)
  {
    herror("Can't get IP");
    exit(1);
  }
	
	if(inet_ntop(AF_INET, (void *)hent->h_addr_list[0], ip, 16) == NULL)
  {
    perror("Can't resolve host");
    exit(1);
  }
  
  return ip;
}
	
#endif
