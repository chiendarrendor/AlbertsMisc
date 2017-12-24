#include "XYPrint.hpp"

class HexGridPrint
{
public:
  HexGridPrint(int i_width,int i_height,bool i_ULStart,bool i_LowShort);

  enum HexLoc { DIR0,DIR1,DIR2,DIR3,DIR4,DIR5,STAT1,STAT2 };

  void AddItem(int i_x,int i_y,HexLoc i_loc,char i_datum);

  const std::string &Show() const;
private:
  int m_width;
  int m_height;
  bool m_ULStart;
  bool m_LowShort;
  XYPrint m_grid;

  void DrawHex(int i_x,int i_y);
  int GetHexX(int i_x,int i_y);
  int GetHexY(int i_x,int i_y);
};



