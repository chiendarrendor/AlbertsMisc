#include <vector>
#include <boost/array.hpp>

#include "BoardCell.hpp"

class Board
{
public:
  Board(const char *i_filename);
  const BoardCell &GetCell(int i_x,int i_y) const;

  ColorInfo::Color GetOuterSecondary() const;
  int GetNumPipes() const;

private:
  boost::array<boost::array<BoardCell,12>,11> m_hexgrid;
  ColorInfo::Color m_outersecondary;
  int m_numpipes;
};

    
