#include "ColorInfo.hpp"
#include <iostream>

// G = Y + B
// V = B + R
// O = Y + R

boost::array<boost::array<char,9>,9> ColorInfo::s_mixes=
  {{
    {{ 'W','Y','B','R','G','V','O','Q','X' }},
    {{ 'Y','Y','G','O','G','X','O','Q','X' }},
    {{ 'B','G','B','V','G','V','X','Q','X' }},
    {{ 'R','O','V','R','X','V','O','Q','X' }},
    {{ 'G','G','G','X','G','X','X','Q','X' }},
    {{ 'V','X','V','V','X','V','X','Q','X' }},
    {{ 'O','O','X','O','X','X','O','Q','X' }},
    {{ 'Q','Q','Q','Q','Q','Q','Q','Q','Q' }},
    {{ 'X','X','X','X','X','X','X','Q','X' }},
  }};


char ColorInfo::GetColorChar(ColorInfo::Color c)
{
  switch (c)
  {
  case WHITE: return 'W';
  case YELLOW: return 'Y';
  case BLUE: return 'B';
  case RED: return 'R';
  case GREEN: return 'G';
  case VIOLET: return 'V';
  case ORANGE: return 'O';
  case QUICKSILVER: return 'Q';
  case BROWN: return 'X';
  default:
    std::cout << "Illegal color code " << c << std::endl;
    exit(1);
  }
}

ColorInfo::Color ColorInfo::GetColorForChar(char c)
{
  switch (c)
  {
  case 'W': return WHITE;
  case 'Y': return YELLOW;
  case 'B': return BLUE;
  case 'R': return RED;
  case 'G': return GREEN;
  case 'V': return VIOLET;
  case 'O': return ORANGE;
  case 'Q': return QUICKSILVER;
  case 'X': return BROWN;
  default:
    std::cout << "Illegal color code " << c << std::endl;
    exit(1);
  }
}


ColorInfo::Color ColorInfo::Mix(ColorInfo::Color c1,ColorInfo::Color c2)
{
  return GetColorForChar(s_mixes[c1][c2]);
}


