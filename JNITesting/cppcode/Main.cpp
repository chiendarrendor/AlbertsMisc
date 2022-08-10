
#include "HolderClass.hpp"
#include "MasterClass.hpp"

#include <iostream>

int main(int argc,char **argv)
{
	MasterClass mc("cppcode/MasterClass.hpp");
	
	for (int i = 0 ; i < 5 ; ++i ) {
		std::cout << "thing: " << mc.getNextHolder()->getString() << std::endl;
	}

	HolderClass hc("foo bar baz");
	std::cout << "Thing: " << hc.getString() << std::endl;

}
