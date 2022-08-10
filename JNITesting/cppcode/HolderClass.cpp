#include "HolderClass.hpp"

HolderClass::HolderClass(const std::string &holdthis) : holding(holdthis) {}
HolderClass::~HolderClass() {}

const std::string &HolderClass::getString() { return holding; }
