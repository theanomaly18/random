#include <iostream>

int main( )
{
for (int i = 31; i <= 37; i++)
{
std::cout << "\033[0;" << i << "mHello!\033[0m" << std::endl;
std::cout << "\033[1;" << i << "mHello!\033[0m" << std::endl;
}
return 0;
}
