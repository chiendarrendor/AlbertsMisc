#include "HexGridPrint.hpp"
#include <iostream>


int main(int argc,char **argv)
{
  HexGridPrint hgp(2,2,true,false);
  std::cout << "ULStart,not LowShort:" << std::endl << hgp.Show();

  HexGridPrint hgp2(2,2,false,false);
  std::cout << "not ULStart,not LowShort:" << std::endl << hgp2.Show();

  HexGridPrint hgp3(2,2,true,true);
  std::cout << "ULStart,LowShort:" << std::endl << hgp3.Show();

  HexGridPrint hgp4(2,2,false,true);
  std::cout << "not ULStart,LowShort:" << std::endl << hgp4.Show();

  HexGridPrint realhgp(11,12,false,true);
  std::cout << "real one:" << std::endl << realhgp.Show();


}

  
