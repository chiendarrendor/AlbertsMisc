#include "Board.hpp"
#include <boost/tokenizer.hpp>
#include <string>
#include <fstream>


Board::Board(const char *i_filename)  : m_outersecondary(ColorInfo::WHITE),m_numpipes(0)
{
  int i;

  std::ifstream istr(i_filename);

  if (!istr)
  {
    std::cout << "Can't open " << i_filename << " for read." << std::endl;
    exit(1);
  }

  int curline = 0;
  std::string linebuf;
  while(std::getline(istr,linebuf))
  {
    curline++;

    if (curline > 12)
    {
      std::cout << "Too many lines in file." << std::endl;
      exit(1);
    }

    boost::tokenizer<> linetok(linebuf);
    boost::tokenizer<>::iterator tokit = linetok.begin();

    // the last line gets special processing.
    if (curline == 12)
    {
      if (std::distance(linetok.begin(),linetok.end()) != 5)
      {
        std::cout << "Bad # of entries on line 12" << std::endl;
        exit(1);
      }
      
      for (i = 1 ; i <= 9 ; i += 2)
      {
        m_hexgrid[i][curline-1].AssignContentCode(*tokit++,BoardCell::BOTTLE);
        m_numpipes += 1;
      }
    }
    else if (std::distance(linetok.begin(),linetok.end()) != 11)
    {
      std::cout << "Bad # of entries on line " << curline << std::endl;
      exit(1);
    }
    else
    {
      for (i = 0 ; i < 11 ; ++i)
      {
        BoardCell::CellType ct = BoardCell::NORMAL;
        if (curline == 11 && (i%2 == 0))
        {
          ct = BoardCell::BOTTLE;
        }
        else if (curline == 1)
        {
          ct = BoardCell::SOURCE;
        }

        m_hexgrid[i][curline-1].AssignContentCode(*tokit++,ct);

        m_numpipes += m_hexgrid[i][curline-1].GetNumPipes();

        if (curline == 1 && i != 4 && i != 5 && i != 6 && 
            GetCell(i,curline-1).GetColor() != ColorInfo::QUICKSILVER)
        {
          m_outersecondary = ColorInfo::Mix(m_outersecondary,GetCell(i,curline-1).GetColor());
        }
      }
    }
  }
}


const BoardCell &Board::GetCell(int i_x,int i_y) const
{
  return m_hexgrid[i_x][i_y];
}

ColorInfo::Color Board::GetOuterSecondary() const
{
  return m_outersecondary;
}

int Board::GetNumPipes() const
{
  return m_numpipes;
}

  

