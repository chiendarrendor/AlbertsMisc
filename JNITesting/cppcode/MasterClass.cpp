#include "MasterClass.hpp"
#include <fstream>
#include <iostream>

MasterClass::MasterClass(const std::string &fileName) :
	curline(0)
{
	std::ifstream readfile(fileName.c_str());
	if (!readfile) return;
	std::string line;
	while(std::getline(readfile,line)) {
		lines.push_back(line);
	}
}

MasterClass::~MasterClass() {}

HolderClass *MasterClass::getNextHolder() {
	if (lines.size() == 0) return NULL;
	if (curline == lines.size()) curline = 0;
	return new HolderClass(lines[curline++]);
}
