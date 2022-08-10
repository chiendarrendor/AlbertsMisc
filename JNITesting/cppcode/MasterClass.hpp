#ifndef MASTERCLASS
#define MASTERCLASS

#include <string>
#include <vector>

#include "HolderClass.hpp"

class MasterClass {
	public:
		MasterClass(const std::string &fileName);
		virtual ~MasterClass();
		
		HolderClass *getNextHolder();
	private:
		std::vector<std::string> lines;
		int curline;
};

#endif

