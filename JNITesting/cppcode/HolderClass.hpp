#ifndef HOLDERCLASS
#define HOLDERCLASS

#include <string>

class HolderClass {
	public:
		HolderClass(const std::string &holdthis);
		virtual ~HolderClass();
		const std::string &getString();
	private:
		std::string holding;
};

#endif

