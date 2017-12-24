#include "XYPrint.hpp"


XYPrint::XYPrint(int i_width,int i_height) : 
  m_width(i_width),m_height(i_height)
{
  std::string line;
  int i;
  
  for (i = 0 ; i < i_width ; ++i)
  {
    line += " ";
  }
  line += "\n";

  for (i = 0 ; i < i_height ; ++i)
  {
    m_grid += line;
  }
};

void XYPrint::SetChar(int i_x,int i_y,char i_c)
{
  if (i_x < 0 || i_y < 0 || i_x >= m_width || i_y >= m_height)
  {
    return;
  }

  m_grid[i_y * (m_width+1) + i_x] = i_c;
}

void XYPrint::AddString(const std::string &i_string,int i_x,int i_y,Dir i_d)
{
  int dx;
  int dy;
  
  switch(i_d)
  {
  case LEFT:
    dx = -1;
    dy = 0;
    break;
  case RIGHT:
    dx = 1;
    dy = 0;
    break;
  case UP:
    dx = 0;
    dy = -1;
    break;
  case DOWN:
    dx = 0;
    dy = 1;
    break;
  }

  size_t i;
  for (i = 0 ; i < i_string.size() ; ++i)
  {
    SetChar(i_x+dx * i,i_y+dy * i,i_string[i]);
  }
}

const std::string &XYPrint::Show() const
{
  return m_grid;
}



    
