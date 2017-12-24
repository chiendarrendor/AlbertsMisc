#include <ext/hash_map>
#include <ext/hash_set>
#include <vector>
#include "PathPix.hpp"


namespace __gnu_cxx
{

  template<>
  struct hash<std::pair<int,int> >
  {
    size_t operator()( const std::pair<int,int> &i_pair) const
    {
      return i_pair.first + i_pair.second;
    }
  };
};




class Path;

enum SolveState { SOLVED,STUCK,BROKEN };


class Board
{
public:

  Board(int i_width,int i_height);
  Board(const std::string &i_filename);
  Board(const Board &i_right);
  Board &operator=(const Board &i_right);
  
  void SetCellPath(Path &i_path,int i_x,int i_y);
  void ClearCellPath(int i_x,int i_y);
  void SetVerticalDivider(int i_x,int i_y); // divider is at right edge of cell
  void SetHorizontalDivider(int i_x,int i_y); // divider is at down edge of cell

  Path *GetCellPath(int i_x,int i_y);
  const Path *GetCellPath(int i_x,int i_y) const;

  bool DividerInDirection(int i_x,int i_y,Direction i_dir) const;
  int GetWidth() const;
  int GetHeight() const;

  void PrintBoard() const;

  SolveState Solve();

private:
  int m_width;
  int m_height;

  void SetWidth(int i_width);
  void SetHeight(int i_height);
  void Guess(size_t i_PathIdx,int i_WiggleIdx);
  
  __gnu_cxx::hash_map<std::pair<int,int>,Path *> m_Cells;
  std::vector<Path*> m_Paths;
  __gnu_cxx::hash_set<std::pair<int,int> > m_VDivs;
  __gnu_cxx::hash_set<std::pair<int,int> > m_HDivs;
};


  
  
    
