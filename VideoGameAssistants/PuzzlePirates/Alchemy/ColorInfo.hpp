#ifndef COLORMIXERHPP
#define COLORMIXERHPP

#include <boost/array.hpp>

class ColorInfo
{
public:
  enum Color { WHITE,YELLOW,BLUE,RED,GREEN,VIOLET,ORANGE,QUICKSILVER,BROWN };
  static char GetColorChar(Color c);
  static Color GetColorForChar(char c);

  static Color Mix(Color c1,Color c2);
private:
  static boost::array<boost::array<char,9>,9> s_mixes;
};

#endif
