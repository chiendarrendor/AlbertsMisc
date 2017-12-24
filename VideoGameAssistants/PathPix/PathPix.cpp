#include "Board.hpp"
#include <iostream>


int main(int argc,char **argv)
{
  if (argc != 2)
  {
    std::cout << "Need file name on command line" << std::endl;
    exit(1);
  }

  Board b(argv[1]);

  b.PrintBoard();
  SolveState ss = b.Solve();
  std::cout << "-----" << ss << std::endl;
  b.PrintBoard();
}
