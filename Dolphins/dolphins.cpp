#include <vector>
#include <iostream>
#include <cstdlib>

enum DolphinType { BOTTLENOSE,PINK,ORANGE,GREY };
enum DolphinEnd { HEAD,TAIL };

class DolphinUnit
{
public:
  DolphinUnit(DolphinType i_dtype,DolphinEnd i_dend) : m_dtype(i_dtype), m_dend(i_dend) {}
  DolphinType GetDolphinType() const { return m_dtype; }
  DolphinEnd GetDolphinEnd() const { return m_dend; }
  bool Matches(const DolphinUnit &i_right) const
  {
    if (GetDolphinType() != i_right.GetDolphinType()) return false;
    if (GetDolphinEnd() == i_right.GetDolphinEnd()) return false;
    return true;
  }

private:
  DolphinType m_dtype;
  DolphinEnd m_dend;
};

std::ostream &operator<<(std::ostream &o, const DolphinUnit &i_du)
{
  if (i_du.GetDolphinType() == BOTTLENOSE && i_du.GetDolphinEnd() == HEAD) o << 'B';
  else if (i_du.GetDolphinType() == BOTTLENOSE && i_du.GetDolphinEnd() == TAIL) o << 'b';
  else if (i_du.GetDolphinType() == PINK && i_du.GetDolphinEnd() == HEAD) o << 'P';
  else if (i_du.GetDolphinType() == PINK && i_du.GetDolphinEnd() == TAIL) o << 'p';
  else if (i_du.GetDolphinType() == ORANGE && i_du.GetDolphinEnd() == HEAD) o << 'O';
  else if (i_du.GetDolphinType() == ORANGE && i_du.GetDolphinEnd() == TAIL) o << 'o';
  else if (i_du.GetDolphinType() == GREY && i_du.GetDolphinEnd() == HEAD) o << 'G';
  else if (i_du.GetDolphinType() == GREY && i_du.GetDolphinEnd() == TAIL) o << 'g';
  else o << "?";

  return o;
}



class Tile
{
public:
  Tile(DolphinUnit i_top,DolphinUnit i_left,DolphinUnit i_right,DolphinUnit i_bottom) :
    m_top(i_top),m_left(i_left),m_right(i_right),m_bottom(i_bottom) {}
  const DolphinUnit &GetTop() const { return m_top; }
  const DolphinUnit &GetLeft() const { return m_left; }
  const DolphinUnit &GetRight() const { return m_right; }
  const DolphinUnit &GetBottom() const { return m_bottom; }

private:
  DolphinUnit m_top;
  DolphinUnit m_left;
  DolphinUnit m_right;
  DolphinUnit m_bottom;
};
  
class TileVector
{
public:
  TileVector(const Tile &i_initial)
  {
    m_tiles.push_back(i_initial);
    m_tiles.push_back(Tile(i_initial.GetLeft(),i_initial.GetBottom(),i_initial.GetTop(),i_initial.GetRight()));
    m_tiles.push_back(Tile(i_initial.GetBottom(),i_initial.GetRight(),i_initial.GetLeft(),i_initial.GetTop()));
    m_tiles.push_back(Tile(i_initial.GetRight(),i_initial.GetTop(),i_initial.GetBottom(),i_initial.GetLeft()));
  }

  const Tile &GetTile(int i_index) const
  {
    if (i_index < 0 || i_index > 3)
    {
      std::cerr << "Illegal Index in TileVector::GetTile() " << i_index << std::endl;
      exit(1);
    }
    return m_tiles[i_index];
  }

private:
  std::vector<Tile> m_tiles;
};

class TileSet
{
public:
  TileSet()
  {
    // arg order:
    //   0
    // 1   2
    //   3

    m_tilesets.push_back(TileVector(Tile(
                                 DolphinUnit(BOTTLENOSE,TAIL),
                                 DolphinUnit(PINK,TAIL),
                                 DolphinUnit(ORANGE,TAIL),
                                 DolphinUnit(GREY,TAIL))));
    m_tilesets.push_back(TileVector(Tile(
                                 DolphinUnit(PINK,HEAD),
                                 DolphinUnit(GREY,HEAD),
                                 DolphinUnit(ORANGE,HEAD),
                                 DolphinUnit(ORANGE,TAIL))));
    m_tilesets.push_back(TileVector(Tile(
                                 DolphinUnit(GREY,TAIL),
                                 DolphinUnit(ORANGE,TAIL),
                                 DolphinUnit(BOTTLENOSE,HEAD),
                                 DolphinUnit(PINK,HEAD))));
    m_tilesets.push_back(TileVector(Tile(
                                 DolphinUnit(BOTTLENOSE,HEAD),
                                 DolphinUnit(ORANGE,HEAD),
                                 DolphinUnit(BOTTLENOSE,TAIL),
                                 DolphinUnit(GREY,TAIL))));
    m_tilesets.push_back(TileVector(Tile(
                                 DolphinUnit(PINK,HEAD),
                                 DolphinUnit(ORANGE,HEAD),
                                 DolphinUnit(BOTTLENOSE,HEAD),
                                 DolphinUnit(GREY,TAIL))));
    m_tilesets.push_back(TileVector(Tile(
                                 DolphinUnit(PINK,HEAD),
                                 DolphinUnit(BOTTLENOSE,HEAD),
                                 DolphinUnit(ORANGE,HEAD),
                                 DolphinUnit(GREY,TAIL))));
    m_tilesets.push_back(TileVector(Tile(
                                 DolphinUnit(GREY,HEAD),
                                 DolphinUnit(ORANGE,HEAD),
                                 DolphinUnit(BOTTLENOSE,HEAD),
                                 DolphinUnit(PINK,TAIL))));
    m_tilesets.push_back(TileVector(Tile(
                                 DolphinUnit(BOTTLENOSE,TAIL),
                                 DolphinUnit(PINK,TAIL),
                                 DolphinUnit(GREY,HEAD),
                                 DolphinUnit(ORANGE,TAIL))));
    m_tilesets.push_back(TileVector(Tile(
                                 DolphinUnit(GREY,TAIL),
                                 DolphinUnit(PINK,HEAD),
                                 DolphinUnit(PINK,TAIL),
                                 DolphinUnit(BOTTLENOSE,HEAD))));
  }

  const TileVector &GetTileVector(int i_index) const
  {
    if (i_index < 0 || i_index > 8)
    {
      std::cerr << "Illegal Index in TileSet::GetTileVector() " << i_index << std::endl;
      exit(1);
    }
    return m_tilesets[i_index];
  }
private:
  std::vector<TileVector> m_tilesets;
};

// cells:
// 0 1 2
// 3 4 5
// 6 7 8

class TileGrid
{
public:
  TileGrid(const TileSet &i_ts) : m_ts(i_ts)
  {
    for (int i = 0 ; i < 9 ; ++i)
    {
      m_grid.push_back(std::pair<int,int>(-1,-1));
    }
  }

  void Iterate(int i_depth = 0)
  {
    std::vector<int> unused;
    int i,j;

    for (i = 0 ; i < 9 ; ++i)
    {
      bool found = false;
      for (j = 0 ; j < i_depth ; ++j)
      {
        if (m_grid[j].first == i)
        {
          found = true;
          break;
        }
      }
      if (!found)
      {
        unused.push_back(i);
      }
    }

    for (i = 0 ; i < unused.size() ; ++i)
    {
      for (j = 0 ; j < 4 ; ++j)
      {
        m_grid[i_depth] = std::pair<int,int>(unused[i],j);
      
        if (!Validate(i_depth)) continue;

        if (i_depth == 8)
        {
          std::cout << "Found one: " << std::endl;
          Print(i_depth);
        }
        else
        {
          Iterate(i_depth+1);
        }
      }
    }
  }

  void Print(int i_depth)
  {
    int row,col;

    for (row = 0 ; row < 3 ; row++)
    {
      // first line.
      for (col = 0 ; col < 3 ; col++)
      {
        int cell = row * 3 + col;
        if (i_depth < cell)
        {
          std::cout << "   ";
        }
        else
        {
          std::cout << " ";
          std::cout << GetCellTile(cell).GetTop();
          std::cout << " ";
        }
      }
      std::cout << std::endl;

      // second line.
      for (col = 0 ; col < 3 ; col++)
      {
        int cell = row * 3 + col;
        if (i_depth < cell)
        {
          std::cout << " X ";
        }
        else
        {
          std::cout << GetCellTile(cell).GetLeft();
          std::cout << " ";
          std::cout << GetCellTile(cell).GetRight();
        }
      }
      std::cout << std::endl;

      // third line.
      for (col = 0 ; col < 3 ; col++)
      {
        int cell = row * 3 + col;
        if (i_depth < cell)
        {
          std::cout << "   ";
        }
        else
        {
          std::cout << " ";
          std::cout << GetCellTile(cell).GetBottom();
          std::cout << " ";
        }
      }
      std::cout << std::endl;
    }
  }

  bool Validate(int i_depth)
  {
    switch(i_depth)
    {
    case 8:
      if (!GetCellTile(8).GetLeft().Matches(GetCellTile(7).GetRight())) return false;
      if (!GetCellTile(8).GetTop().Matches(GetCellTile(5).GetBottom())) return false;
    case 7:
      if (!GetCellTile(7).GetLeft().Matches(GetCellTile(6).GetRight())) return false;
      if (!GetCellTile(7).GetTop().Matches(GetCellTile(4).GetBottom())) return false;
    case 6:
      if (!GetCellTile(6).GetTop().Matches(GetCellTile(3).GetBottom())) return false;
    case 5:
      if (!GetCellTile(5).GetLeft().Matches(GetCellTile(4).GetRight())) return false;
      if (!GetCellTile(5).GetTop().Matches(GetCellTile(2).GetBottom())) return false;
    case 4:
      if (!GetCellTile(4).GetLeft().Matches(GetCellTile(3).GetRight())) return false;
      if (!GetCellTile(4).GetTop().Matches(GetCellTile(1).GetBottom())) return false;
    case 3:
      if (!GetCellTile(3).GetTop().Matches(GetCellTile(0).GetBottom())) return false;
    case 2:
      if (!GetCellTile(2).GetLeft().Matches(GetCellTile(1).GetRight())) return false;
    case 1:
      if (!GetCellTile(1).GetLeft().Matches(GetCellTile(0).GetRight())) return false;
    case 0:
      break;
    default:
      std::cerr << "Illegal depth in Validate! " << i_depth << std::endl;
      exit(1);
    }
    return true;
  }

  const Tile &GetCellTile(int i_cell)
  {
    return m_ts.GetTileVector(m_grid[i_cell].first).GetTile(m_grid[i_cell].second);
  }



private:

  std::vector<std::pair<int,int> >m_grid;

  const TileSet &m_ts;
};






int main(int argc,char **argv)
{
  TileSet ts;

  TileGrid tg(ts);

  tg.Iterate();
}

