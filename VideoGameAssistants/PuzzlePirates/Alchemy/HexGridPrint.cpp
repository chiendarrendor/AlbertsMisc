#include <iostream>
#include "HexGridPrint.hpp"
#include <boost/lexical_cast.hpp>

HexGridPrint::HexGridPrint(int i_width,int i_height,
                           bool i_ULStart,bool i_LowShort):
  m_width(i_width),
  m_height(i_height),
  m_ULStart(i_ULStart),
  m_LowShort(i_LowShort),
  m_grid(2+5*i_width,1+4*i_height+(i_LowShort ? 0 : 2))
{
  int i,j;
  for (i = 0 ; i < i_width ; ++i)
  {
    int h = i_height;
    if (i_LowShort)
    {
      if (i % 2 == 0 && !i_ULStart) h--;
      if (i % 2 == 1 && i_ULStart) h--;
    }
    for (j = 0 ; j < h ; ++j)
    {
      DrawHex(i,j);
    }
  }
}

//       ___    +
//      /   \   |
//  ___/     \  |
// / 3 \     /  |
//*2   4\___/   |
//\1   5/   \   |
// \_0_/     \  |
//     \     /  |
//      \___/   +

int HexGridPrint::GetHexX(int i_x,int i_y)
{
  return i_x * 5;
}

int HexGridPrint::GetHexY(int i_x,int i_y)
{
  bool evencolumn = (i_x % 2 == 0);
  return 2 + 4 * i_y + ((evencolumn != m_ULStart) ? 2 : 0);
}

void HexGridPrint::DrawHex(int i_x,int i_y)
{
  int bx = GetHexX(i_x,i_y);
  int by = GetHexY(i_x,i_y);
  //  std::cout << "Drawing Hex (" << i_x << "," << i_y << ") at (";
  //  std::cout << bx << "," << by << ")" << std::endl;
  m_grid.AddString( "___",bx+2,by-2);
  m_grid.AddString("/   \\",bx+1,by-1);
  m_grid.AddString("/     \\",bx,by);
  m_grid.AddString("\\     /",bx,by+1);
  m_grid.AddString("\\___/",bx+1,by+2);



}


void HexGridPrint::AddItem(int i_x,int i_y,HexLoc i_loc,char i_datum)
{
  int bx = GetHexX(i_x,i_y);
  int by = GetHexY(i_x,i_y);
  int dx;
  int dy;

  switch (i_loc)
  {
  case DIR0:  dx = 3 ; dy =  2; break;
  case DIR1:  dx = 1 ; dy =  1; break;
  case DIR2:  dx = 1 ; dy =  0; break;
  case DIR3:  dx = 3 ; dy = -1; break;
  case DIR4:  dx = 5 ; dy =  0; break;
  case DIR5:  dx = 5 ; dy =  1; break;
  case STAT1: dx = 3 ; dy =  0; break;
  case STAT2: dx = 3 ; dy =  1; break;
  }

  m_grid.AddString(boost::lexical_cast<std::string>(i_datum),bx+dx,by+dy);
}

const std::string &HexGridPrint::Show() const
{
  return m_grid.Show();
}

                   



