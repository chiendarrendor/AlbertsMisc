#include "PathPix.hpp"
#include <vector>

class Board;

enum WiggleResult { CHANGED,UNCHANGED,ILLEGAL };

class Path
{
public:
  Path(char i_color,int i_length,int i_x,int i_y);
  Path(const Path &i_right);

  const std::pair<int,int> &GetOriginalCell() const;

  const std::vector<std::pair<int,int> > &GetPathList() const;

  void Invalidate();

  char GetColor() const;
  size_t GetLength() const;
  Direction GetDirectionAt(int i_x,int i_y) const;
  bool IsValid() const;
  bool IsDone() const;

  WiggleResult Wiggle(Board &i_board,int i_wiggleidx = -1);
  int GetNumWiggles() const;

private:
  void WiggleIter(Board &i_board,std::vector<Path> &o_legalpaths);

  char m_Color;
  size_t m_Length;
  bool m_IsValid;
  bool m_IsDone;
  int m_NumWiggles;
  std::vector<std::pair<int,int> >m_PathList;
  std::pair<int,int> m_OriginalCell;

};
