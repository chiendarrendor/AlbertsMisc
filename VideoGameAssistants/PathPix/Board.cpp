#include "Board.hpp"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <boost/tokenizer.hpp>
#include <boost/lexical_cast.hpp>
#include <vector>
#include "Path.hpp"

Board::Board(int i_width,int i_height) :
  m_width(i_width),
  m_height(i_height)
{
}

Board::Board(const Board &i_right) :
  m_Cells(),
  m_Paths()
{
  *this = i_right;
}

Board &Board::operator=(const Board &i_right)
{
  if (&i_right != this)
  {
    m_width = i_right.m_width;
    m_height = i_right.m_height;
    m_VDivs = i_right.m_VDivs;
    m_HDivs = i_right.m_HDivs;

    m_Cells.clear();
    size_t i;
    for (i = 0 ; i < m_Paths.size() ; ++i)
    {
      delete m_Paths[i];
    }
    m_Paths.clear();

    for(i = 0 ; i < i_right.m_Paths.size() ; ++i)
    {
      const Path *pPath = i_right.m_Paths[i];
      Path *pNewPath = new Path(*pPath);
      size_t j;
      for (j = 0 ; j < pNewPath->GetPathList().size() ; ++j)
      {
        SetCellPath(*pNewPath,
                    pNewPath->GetPathList()[j].first,
                    pNewPath->GetPathList()[j].second
                    );
      }
      m_Paths.push_back(pNewPath);
    }
  }
  return *this;
}



namespace
{
  void ParseLine(const std::string &i_ref,std::vector<std::string> &io_tokens)
  {
    boost::tokenizer<> tok(i_ref);
    boost::tokenizer<>::iterator tb;
    io_tokens.clear();
    for (tb = tok.begin() ; tb != tok.end() ; ++tb)
    {
      io_tokens.push_back(*tb);
    }
  }
}

#define IFDIE(exp,errstream) \
{ \
  if (exp) \
  { \
    std::cout << errstream << std::endl; \
    exit(1); \
  } \
}


Board::Board(const std::string &i_filename)
{
  std::ifstream ifs(i_filename.c_str());
  IFDIE(!ifs,"Can't read filename " << i_filename); 

  std::string buf;
  std::vector<std::string> tokens;
  IFDIE(!std::getline(ifs,buf) || buf.size() == 0,"Empty file");

  ParseLine(buf,tokens);
  IFDIE(tokens.size() != 2,"Bad size descriptor line");

  m_width = boost::lexical_cast<int>(tokens[0]);
  m_height = boost::lexical_cast<int>(tokens[1]);
  IFDIE(m_width <= 0 || m_height <= 0,"Illegal width or height");

  bool inDividers = false;

  while(std::getline(ifs,buf))
  {
    ParseLine(buf,tokens);
    if (tokens.size() == 4 && inDividers == false)
    {
      char col = boost::lexical_cast<char>(tokens[0]);
      int num = boost::lexical_cast<int>(tokens[1]);
      int x = boost::lexical_cast<int>(tokens[2]);
      int y = boost::lexical_cast<int>(tokens[3]);
      Path *pNewPath = new Path(col,num,x,y);
      SetCellPath(*pNewPath,x,y);
      m_Paths.push_back(pNewPath);
    }
    else if (tokens.size() == 3 && inDividers == true)
    {
      char dir = boost::lexical_cast<char>(tokens[0]);
      int x = boost::lexical_cast<int>(tokens[1]);
      int y = boost::lexical_cast<int>(tokens[2]);
      if (dir == 'V')
      {
        SetVerticalDivider(x,y);
      }
      else if (dir == 'H')
      {
        SetHorizontalDivider(x,y);
      }
      else
      {
        IFDIE(true,"Bad Divider Type: " << buf);
      }
    }
    else if (buf == "--")
    {
      inDividers = true;
    }
    else
    {
      IFDIE(true,"Bad Line: " << buf);
    }
  }
  ifs.close();
}

void Board::PrintBoard() const
{
  int i,j;

  for (i = 0 ; i < GetHeight() ; ++i)
  {

    if (i == 0)
    {
      for (j = 0 ; j < GetWidth() ; ++j )
      {
        std::cout << "+===";
      }
      std::cout << "+";
      std::cout << std::endl;
    }

    for (j = 0 ; j < GetWidth() ; ++j)
    {
      if (j == 0) std::cout << "#";

      const Path *pPath = GetCellPath(j,i);
      if (pPath && pPath->IsValid())
      {
        std::cout << pPath->GetColor();
        std::cout << std::setw(2) << pPath->GetLength();
      }
      else
      {
        std::cout << "   ";
      }

      if (j == GetWidth()-1)
      {
        std::cout << "#";
      }
      else
      {
        if (DividerInDirection(j,i,RIGHT)) std::cout << "|";
        else
        {
          const Path *lcell = GetCellPath(j,i);
          const Path *rcell = GetCellPath(j+1,i);
          if (lcell && lcell->IsValid() && lcell->GetDirectionAt(j,i) == RIGHT) std::cout << ">";
          else if (rcell && rcell->IsValid() && rcell->GetDirectionAt(j+1,i) == LEFT) std::cout << "<";
          else std::cout << " ";
        }
      }
    }
    std::cout << std::endl;

    for (j = 0 ; j < GetWidth() ; ++j )
    {
      std::cout << "+";
      if (i == GetHeight() - 1)
      {
        std::cout << "===";
      }
      else
      {
        if (DividerInDirection(j,i,DOWN)) std::cout << "---";
        else
        {
          const Path *uCell = GetCellPath(j,i);
          const Path *dCell = GetCellPath(j,i+1);
          if (uCell && uCell->IsValid() && uCell->GetDirectionAt(j,i) == DOWN) std::cout << " v ";
          else if (dCell && dCell->IsValid() && dCell->GetDirectionAt(j,i+1) == UP) std::cout << " ^ ";
          else std::cout << "   ";
        }
      }
    }
    std::cout << "+";
    std::cout << std::endl;
  }
}

int Board::GetWidth() const
{
  return m_width;
}

int Board::GetHeight() const
{
  return m_height;
}

void Board::SetWidth(int i_width)
{
  m_width = i_width;
}

void Board::SetHeight(int i_height)
{
  m_height = i_height;
}

const Path *Board::GetCellPath(int i_x,int i_y) const
{
  __gnu_cxx::hash_map<std::pair<int,int>,Path *>::const_iterator cit =
    m_Cells.find(std::pair<int,int>(i_x,i_y));

  if (cit == m_Cells.end()) return NULL;

  return cit->second;
}

Path *Board::GetCellPath(int i_x,int i_y)
{
  __gnu_cxx::hash_map<std::pair<int,int>,Path *>::iterator cit =
    m_Cells.find(std::pair<int,int>(i_x,i_y));

  if (cit == m_Cells.end()) return NULL;

  return cit->second;
}

void Board::SetCellPath(Path &i_path,int i_x,int i_y)
{
  if (i_x < 0 || i_x >= m_width ||
      i_y < 0 || i_y >= m_height)
  {
    std::cout << "Bad Call to SetCell" << std::endl;
    exit(1);
  }

  m_Cells[std::pair<int,int>(i_x,i_y)] = &i_path;
}
 
void Board::ClearCellPath(int i_x,int i_y)
{
  if (i_x < 0 || i_x >= m_width ||
      i_y < 0 || i_y >= m_height)
  {
    std::cout << "Bad Call to ClearCell" << std::endl;
    exit(1);
  }


  m_Cells.erase(std::pair<int,int>(i_x,i_y));
}

void Board::SetVerticalDivider(int i_x,int i_y)
{
  if (i_x < 0 || i_x >= m_width-1 ||
      i_y < 0 || i_y >= m_height)
  {
    std::cout << "Bad Call to SetVerticalDivider" << std::endl;
    exit(1);
  }

  m_VDivs.insert(std::pair<int,int>(i_x,i_y));
}

void Board::SetHorizontalDivider(int i_x,int i_y)
{
  if (i_x < 0 || i_x >= m_width ||
      i_y < 0 || i_y >= m_height-1)
  {
    std::cout << "Bad Call to SetHorizontalDivider" << std::endl;
    exit(1);
  }

  m_HDivs.insert(std::pair<int,int>(i_x,i_y));
}


bool Board::DividerInDirection(int i_x,int i_y,Direction i_dir) const
{
  if (i_dir == UP)
  {
    return m_HDivs.find(std::pair<int,int>(i_x,i_y-1)) != m_HDivs.end();
  }

  if (i_dir == DOWN)
  {
    return m_HDivs.find(std::pair<int,int>(i_x,i_y)) != m_HDivs.end();
  }

  if (i_dir == LEFT)
  {
    return m_VDivs.find(std::pair<int,int>(i_x-1,i_y)) != m_HDivs.end();
  }

  if (i_dir == RIGHT)
  {
    return m_VDivs.find(std::pair<int,int>(i_x,i_y)) != m_HDivs.end();
  }
  
  std::cout << "Bad direction!" << std::endl;
  exit(1);
}

struct prioritySorter
{
  bool operator()(const std::pair<int,Path *>& i_left,const std::pair<int,Path *>& i_right)
  {
    const Path* pl = i_left.second;
    const Path* pr = i_right.second;
    // true if first precedes second
    if (pl->IsValid() != pr->IsValid())
    {
      return pl->IsValid();
    }

    if (pl->IsDone() != pr->IsDone())
    {
      return pr->IsDone();
    }

    if (pl->GetNumWiggles() != pr->GetNumWiggles())
    {
      return pl->GetNumWiggles() < pr->GetNumWiggles();
    }

    if (pl->GetLength() != pr->GetLength())
    {
      return pl->GetLength() > pr->GetLength();
    }


    return i_left.first < i_right.first;
  }
};

void Board::Guess(size_t i_PathIdx, int i_wiggleidx)
{
  Path *pPath = m_Paths[i_PathIdx];
  pPath->Wiggle(*this,i_wiggleidx);
}

SolveState Board::Solve()
{

  bool changed = true;
  int iter = 0;
  size_t i;

  std::cout << "Solve Start: " << std::endl;
  PrintBoard();

  while(changed)
  {
    changed = false;

    bool alldone = true;

    for (i = 0 ; i < m_Paths.size() ; ++i)
    {
      Path *pPath = m_Paths[i];

      if (!pPath->IsValid()) continue;
      if (pPath->IsDone()) continue;

      alldone = false;

      WiggleResult wr = pPath->Wiggle(*this);
      if (wr == CHANGED) changed = true;
      if (wr == ILLEGAL)
      {
        std::cout << "broken result!" << std::endl;
        return BROKEN;
      }
    }

    std::cout << "---- iter:" << ++iter << std::endl;

    if (alldone == true) 
    {
      std::cout << "Solved!" << std::endl;
      return SOLVED;
    }
  }

  std::cout << "Stuck here: " << std::endl;
  PrintBoard();

  // if we get here, we got stuck.  let's try guessing.
  std::vector<std::pair<size_t,Path *> >sortVector;
  for (i = 0 ; i < m_Paths.size() ; ++i)
  {
    sortVector.push_back(std::pair<int,Path *>(i,m_Paths[i]));
  }

  std::sort(sortVector.begin(),sortVector.end(),prioritySorter());

  size_t cloneIndex = sortVector[0].first;
  Path *pPath = sortVector[0].second;

  std::cout << "number of options: " << pPath->GetNumWiggles() << std::endl;

  int widx;
  bool solved = false;
  for (widx = 0 ; widx < pPath->GetNumWiggles() ; ++widx)
  {
    std::cout << "Option: " << widx << std::endl;
    Board *pB = new Board(*this);
    pB->Guess(cloneIndex,widx);

    SolveState s = pB->Solve();
    if (s == BROKEN)
    {
      std::cout << "Broken" << std::endl;
      free(pB);
      continue;
    }

    if (s == STUCK)
    {
      std::cout << "How'd that happen?" << std::endl;
      exit(1);
    }

    std::cout << "Sub Solved!" << std::endl;
    *this = *pB;
    free(pB);
    solved = true;
    break;
  }

  if (solved == true) return SOLVED;
  return BROKEN;
}
