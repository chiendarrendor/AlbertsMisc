#include <vector>
#include <iostream>

enum FruitType { APPLE,BANANA,ORANGE,GREEN };
enum FruitEnd { STEM,BODY };

class FruitUnit
{
public:
  FruitUnit(FruitType i_dtype,FruitEnd i_dend) : m_dtype(i_dtype), m_dend(i_dend) {}
  FruitType GetFruitType() const { return m_dtype; }
  FruitEnd GetFruitEnd() const { return m_dend; }
  bool Matches(const FruitUnit &i_right) const
  {
    if (GetFruitType() != i_right.GetFruitType()) return false;
    if (GetFruitEnd() == i_right.GetFruitEnd()) return false;
    return true;
  }

private:
  FruitType m_dtype;
  FruitEnd m_dend;
};

std::ostream &operator<<(std::ostream &o, const FruitUnit &i_du)
{
  if (i_du.GetFruitType() == APPLE && i_du.GetFruitEnd() == STEM) o << 'A';
  else if (i_du.GetFruitType() == APPLE && i_du.GetFruitEnd() == BODY) o << 'a';
  else if (i_du.GetFruitType() == BANANA && i_du.GetFruitEnd() == STEM) o << 'B';
  else if (i_du.GetFruitType() == BANANA && i_du.GetFruitEnd() == BODY) o << 'b';
  else if (i_du.GetFruitType() == ORANGE && i_du.GetFruitEnd() == STEM) o << 'O';
  else if (i_du.GetFruitType() == ORANGE && i_du.GetFruitEnd() == BODY) o << 'o';
  else if (i_du.GetFruitType() == GREEN && i_du.GetFruitEnd() == STEM) o << 'G';
  else if (i_du.GetFruitType() == GREEN && i_du.GetFruitEnd() == BODY) o << 'g';
  else o << "?";

  return o;
}



class Tile
{
public:
  Tile(FruitUnit i_top,FruitUnit i_left,FruitUnit i_right,FruitUnit i_bottom,bool i_isSpecial=false) :
    m_top(i_top),m_left(i_left),m_right(i_right),m_bottom(i_bottom),m_isSpecial(i_isSpecial) {}
  const FruitUnit &GetTop() const { return m_top; }
  const FruitUnit &GetLeft() const { return m_left; }
  const FruitUnit &GetRight() const { return m_right; }
  const FruitUnit &GetBottom() const { return m_bottom; }
  const bool IsSpecial() const { return m_isSpecial; }

private:
  FruitUnit m_top;
  FruitUnit m_left;
  FruitUnit m_right;
  FruitUnit m_bottom;
  bool m_isSpecial;
};
  
class TileVector
{
public:
  TileVector(const Tile &i_initial)
  {
    m_tiles.push_back(i_initial);
    m_tiles.push_back(Tile(i_initial.GetLeft(),i_initial.GetBottom(),
                           i_initial.GetTop(),i_initial.GetRight(),i_initial.IsSpecial()));
    m_tiles.push_back(Tile(i_initial.GetBottom(),i_initial.GetRight(),
                           i_initial.GetLeft(),i_initial.GetTop(),i_initial.IsSpecial()));
    m_tiles.push_back(Tile(i_initial.GetRight(),i_initial.GetTop(),
                           i_initial.GetBottom(),i_initial.GetLeft(),i_initial.IsSpecial()));
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
                                 FruitUnit(ORANGE,STEM),
                                 FruitUnit(APPLE,BODY),
                                 FruitUnit(BANANA,STEM),
                                 FruitUnit(ORANGE,BODY))));
    m_tilesets.push_back(TileVector(Tile(
                                 FruitUnit(APPLE,STEM),
                                 FruitUnit(ORANGE,STEM),
                                 FruitUnit(GREEN,BODY),
                                 FruitUnit(BANANA,BODY))));
    m_tilesets.push_back(TileVector(Tile(
                                 FruitUnit(GREEN,BODY),
                                 FruitUnit(ORANGE,BODY),
                                 FruitUnit(BANANA,STEM),
                                 FruitUnit(APPLE,STEM))));
    m_tilesets.push_back(TileVector(Tile(
                                 FruitUnit(APPLE,BODY),
                                 FruitUnit(ORANGE,BODY),
                                 FruitUnit(GREEN,STEM),
                                 FruitUnit(BANANA,STEM))));
    m_tilesets.push_back(TileVector(Tile(
                                 FruitUnit(APPLE,BODY),
                                 FruitUnit(GREEN,BODY),
                                 FruitUnit(ORANGE,STEM),
                                 FruitUnit(BANANA,STEM),
                                 true)));
    m_tilesets.push_back(TileVector(Tile(
                                 FruitUnit(GREEN,BODY),
                                 FruitUnit(APPLE,STEM),
                                 FruitUnit(BANANA,BODY),
                                 FruitUnit(GREEN,STEM))));
    m_tilesets.push_back(TileVector(Tile(
                                 FruitUnit(ORANGE,BODY),
                                 FruitUnit(GREEN,STEM),
                                 FruitUnit(GREEN,BODY),
                                 FruitUnit(APPLE,STEM))));
    m_tilesets.push_back(TileVector(Tile(
                                 FruitUnit(ORANGE,BODY),
                                 FruitUnit(BANANA,STEM),
                                 FruitUnit(BANANA,BODY),
                                 FruitUnit(APPLE,STEM))));
    m_tilesets.push_back(TileVector(Tile(
                                 FruitUnit(APPLE,STEM),
                                 FruitUnit(ORANGE,BODY),
                                 FruitUnit(GREEN,STEM),
                                 FruitUnit(GREEN,BODY))));
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
          if (GetCellTile(cell).IsSpecial())
          {
            std::cout << "*";
          }
          else
          {
            std::cout << " ";
          }
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

