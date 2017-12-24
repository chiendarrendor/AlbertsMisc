#include "XYPrint.hpp"
#include <iostream>

int main(int argc,char **argv)
{
  XYPrint xyp(10,10);

  xyp.AddString("RIGHT",6,2);
  xyp.AddString("LEFT",3,9,XYPrint::LEFT);
  xyp.AddString("DOWN",9,1,XYPrint::DOWN);
  xyp.AddString("UP",0,6,XYPrint::UP);
  std::cout << xyp.Show();
}

