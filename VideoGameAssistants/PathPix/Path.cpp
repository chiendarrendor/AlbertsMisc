#include "Path.hpp"
#include <iostream>
#include "Board.hpp"


Path::Path(char i_color,int i_length,int i_x,int i_y) :
  m_Color(i_color),
  m_Length(i_length),
  m_IsValid(true),
  m_IsDone(i_length == 1),
  m_NumWiggles(0),
  m_PathList()
{
  m_PathList.push_back(std::pair<int,int>(i_x,i_y));
  m_OriginalCell = m_PathList[0];
}

Path::Path(const Path &i_right) :
  m_Color(i_right.m_Color),
  m_Length(i_right.m_Length),
  m_IsValid(i_right.m_IsValid),
  m_IsDone(i_right.m_IsDone),
  m_NumWiggles(i_right.m_NumWiggles),
  m_PathList(i_right.m_PathList),
  m_OriginalCell(i_right.m_OriginalCell)
{
}

const std::pair<int,int> &Path::GetOriginalCell() const
{
  return m_OriginalCell;
}

int Path::GetNumWiggles() const
{
  return m_NumWiggles;
}

  

char Path::GetColor() const
{
  return m_Color;
}

size_t Path::GetLength() const
{
  return m_Length;
}

bool Path::IsValid() const
{
  return m_IsValid;
}

bool Path::IsDone() const
{
  return m_IsDone;
}

const std::vector<std::pair<int,int> > &Path::GetPathList() const
{
  return m_PathList;
}

Direction Path::GetDirectionAt(int i_x,int i_y) const
{
  size_t i;

  for (i = 0 ; i < m_PathList.size() ; ++i)
  {
    if (m_PathList[i].first != i_x ||
        m_PathList[i].second != i_y) continue;

    // if we get here, we're looking at the path step we want
    if (i == m_PathList.size() - 1) return NONE;
    // if we get here, there is a next path step
    int dx = m_PathList[i].first - m_PathList[i+1].first;
    int dy = m_PathList[i].second - m_PathList[i+1].second;

    if (dx == 0 && dy == -1) return DOWN;
    if (dx == 0 && dy == 1) return UP;
    if (dx == -1 && dy == 0) return RIGHT;
    if (dx == 1 && dy == 0) return LEFT;
    std::cout << "non-orthogonal relationship!" << std::endl;
    exit(1);
  }


  
  std::cout << "Can't find that cell in path!" << std::endl;
  exit(1);
}

// given that the path end is at the tail of m_PathList
// if pathlist.size is already m_Length, return
// try all four directions
// in each direction
//   if direction is not legal (i.e. off the board or through wall) go to next direction
//   if space in that direction is empty
//      add space to PathList
//      add self to board in that location
//      WiggleIter(i_board,o_legalpaths)
//      remove this space from PathList
//      remove self from board in that location
//   else
//      if Path in that space:
//        has different color, go to next direction
//        has different length, go to next direction
//        is done, go to next direction
//        's tail isn't that space (last space of m_PathList) go to next direction
//        if sum of m_PathList.size() + other.m_PathList.size() != m_Length go to next direction
//      // if we get here, our path and theirs is connectable
//      for each space in other.m_Pathlist from tail back to head, 
//        add it to m_PathList (at this point m_PathList.size == m_Length
//        o_legalpaths.push_back(Path(*this));
//      remove from tail of m_PathList other.m_PathList.size entries

int dx[] = { 0,0,-1,1 };
int dy[] = { -1,1,0,0 };


void Path::WiggleIter(Board &i_board,std::vector<Path> &o_legalpaths)
{
  if (m_PathList.size() == m_Length) return;
  int dir;
  int curx = m_PathList.back().first;
  int cury = m_PathList.back().second;

  for (dir = UP ; dir <= RIGHT ; ++dir)
  {
/*
    for (size_t i = 0 ; i < m_PathList.size() ; ++i) std::cout << "    ";
    std::cout << "cur: " << curx << "," << cury << "," ;
    if (dir == UP) std::cout << "UP";
    if (dir == LEFT) std::cout << "LEFT";
    if (dir == RIGHT) std::cout << "RIGHT";
    if (dir == DOWN) std::cout << "DOWN";
    std::cout << " (" << m_PathList.size() << ")";
    std::cout << " ... ";
*/
    if (i_board.DividerInDirection(curx,cury,(Direction)dir)) 
    {
//    std::cout << "divider" << std::endl;
      continue;
    }
    int nx = curx + dx[dir];
    int ny = cury + dy[dir];
    if (nx < 0 || ny < 0 || nx >= i_board.GetWidth() || ny >= i_board.GetHeight()) 
    {
//    std::cout << "Off Board" << std::endl;
      continue;
    }

    // if we get here, we have an unobstructed path to a valid space in this direction
    Path *pOPath = i_board.GetCellPath(nx,ny);
    if (pOPath == NULL)
    {
//    std::cout << "empty space! iterating" << std::endl;
      m_PathList.push_back(std::pair<int,int>(nx,ny));
      i_board.SetCellPath(*this,nx,ny);
      WiggleIter(i_board,o_legalpaths);
      i_board.ClearCellPath(nx,ny);
      m_PathList.pop_back();
    }
    else
    {
      if (this == pOPath) 
      {
//      std::cout << "self" << std::endl;
        continue;
      }
      if (pOPath->GetColor() != this->GetColor()) 
      {
//      std::cout << "color mismatch" << std::endl;
        continue;
      }
      if (pOPath->GetLength() != this->GetLength())
      {
//      std::cout << "length mismatch" << std::endl;
        continue;
      }
      if (pOPath->GetPathList().back().first != nx ||
          pOPath->GetPathList().back().second != ny)
      {
//      std::cout << "Other path terminal end not here" << std::endl;
        continue;
      }
      if (pOPath->GetPathList().size() + m_PathList.size() != this->GetLength()) 
      {
//      std::cout << "Length sum mismatch" << std::endl;
        continue;
      }

//    std::cout << "Path Found!" << std::endl;
      int i;

      // if we get here, this other path and ours is connectable
      for (i = (int)pOPath->GetPathList().size()-1 ; i >= 0  ; --i)
      {
//      std::cout << "Copy other i: " << i << std::endl;

        m_PathList.push_back(pOPath->GetPathList()[i]);
      }
      o_legalpaths.push_back(Path(*this));
      for (i = (int)pOPath->GetPathList().size()-1 ; i >= 0  ; --i)
      {
        m_PathList.pop_back();
      }
    }
  }
}


WiggleResult Path::Wiggle(Board &i_board,int i_wiggleidx)
{
  std::vector<Path> legalpaths;

  //  std::cout << "Wiggling " << GetColor() << GetLength() << " at " << 
  //    m_PathList[0].first << "," << m_PathList[0].second << std::endl;

  WiggleIter(i_board,legalpaths);
  
  m_NumWiggles = legalpaths.size();
  if (legalpaths.size() == 0) return ILLEGAL;

  size_t oldsize = m_PathList.size();

  if (legalpaths.size() == 1 || i_wiggleidx != -1)
  {
    // legalpaths is of size 1
    // set m_PathList to legalpaths[0].m_PathList
    // set IsDone to true
    // for each entry in m_PathList
    //    if cell on board is not null and not this, path->Invalidate()
    //    set board cell to this
    // extension...if we have a non -1 wiggleidx, use that one.
    size_t widx = (i_wiggleidx != -1) ? i_wiggleidx : 0;

    m_PathList = legalpaths[widx].GetPathList();
    m_IsDone = true;
    size_t i;
    for (i = 0 ; i < m_PathList.size() ; ++i)
    {
      Path *pPath = i_board.GetCellPath(m_PathList[i].first,m_PathList[i].second);
      if (pPath != NULL && pPath != this)
      {
        pPath->Invalidate();
      }
      i_board.SetCellPath(*this,m_PathList[i].first,m_PathList[i].second);
    }
  }
  else
  {
    // find the largest common left-subset of all paths, and set
    // m_PathList to that subset, and alter i_board spaces appropriately.
    m_PathList.clear();
    size_t i,j;
    for (i = 0 ; i < GetLength() ; ++i)
    {
      for (j = 1 ; j < legalpaths.size() ; ++j)
      {
        if (legalpaths[j].GetPathList()[i] != legalpaths[0].GetPathList()[i])
        {
          goto SUBSETEND;
        }
      }
      // if we get here, all cells match for this step of the path
      m_PathList.push_back(legalpaths[0].GetPathList()[i]);
      i_board.SetCellPath(*this,
                          legalpaths[0].GetPathList()[i].first,
                          legalpaths[0].GetPathList()[i].second);
    }
  SUBSETEND: ;

    // to do...calculate set of all cells not in common left-subset
    // common to all paths
  }

  if (m_PathList.size() == oldsize)
  {
    return UNCHANGED;
  }
  else
  {
    return CHANGED;
  }
}

void Path::Invalidate()
{
  m_IsValid = false;
  m_PathList.clear();
}

  
