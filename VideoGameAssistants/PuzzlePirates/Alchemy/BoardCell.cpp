#include "BoardCell.hpp"

bool BoardCell::s_Initialized = false;
std::map<std::string,PipeDefinition > BoardCell::s_PipeDefinitions;

void BoardCell::SetPipeDefinition(const std::string &i_name,
                                  int i0,int i1,int i2,int i3,int i4,int i5)
{
    PipeDefinition b = { { i0,i1,i2,i3,i4,i5 } };
    s_PipeDefinitions[i_name]  = b;
}  

PipeDefinition BoardCell::RotateDefinition(const PipeDefinition &i_pdef)
{
  PipeDefinition result = i_pdef;
  int t = result[0];
  result[0] = result[1];
  result[1] = result[2];
  result[2] = result[3];
  result[3] = result[4];
  result[4] = result[5];
  result[5] = t;
  return result;
}

PipeDefinition BoardCell::PipeSwap(const PipeDefinition &i_pdef)
{
  PipeDefinition result = i_pdef;
  int i;
  for (i = 0 ; i < 6 ; ++i)
  {
    if (result[i] == 1) result[i] = 2;
    else if (result[i] == 2) result[i] = 1;
  }
  return result;
}


BoardCell::BoardCell() : 
  m_bottlesize(0),
  m_color(ColorInfo::WHITE)
{ 
  if (s_Initialized == false)
  {
    s_Initialized = true;
    //                     0 1 2 3 4 5
    SetPipeDefinition("c", 1,0,0,0,0,1 );
    SetPipeDefinition("C", 1,0,0,0,1,0 );
    SetPipeDefinition("I", 1,0,0,1,0,0 );
    SetPipeDefinition("Y", 1,0,1,0,1,0 );
    SetPipeDefinition("h", 1,0,0,1,0,1 );
    SetPipeDefinition("r", 1,0,0,1,1,0 );
    SetPipeDefinition("X", 1,1,0,1,1,0 );
    SetPipeDefinition("P", 1,0,1,1,1,0 );
    SetPipeDefinition("K", 1,0,0,1,1,1 );
    SetPipeDefinition("5", 1,1,1,1,1,0 );
    SetPipeDefinition("6", 1,1,1,1,1,1 );

    // two-pipe cells
    SetPipeDefinition("II",1,0,2,1,0,2 );
    SetPipeDefinition("BA",1,2,0,1,0,2 );
    SetPipeDefinition("Ic",1,0,0,1,2,2 );
    SetPipeDefinition("cC",1,2,2,0,1,0 );
    SetPipeDefinition("Cc",1,0,1,0,2,2 );
    SetPipeDefinition("CC",1,2,0,2,1,0 );
    SetPipeDefinition("W", 1,2,0,0,1,2 );
  }
}

bool BoardCell::AssignContentCode(const std::string &i_code,CellType i_type) 
{ 
  m_type = i_type;
  m_numpipes = 1;

  if (i_type == BOTTLE)
  {
    switch (i_code[0])
    {
    case 'Y': m_color = ColorInfo::YELLOW; break;
    case 'R': m_color = ColorInfo::RED; break;
    case 'B': m_color = ColorInfo::BLUE; break;
    case 'G': m_color = ColorInfo::GREEN; break;
    case 'V': m_color = ColorInfo::VIOLET; break;
    case 'O': m_color = ColorInfo::ORANGE; break;
    default:
      std::cout << "Illegal bottle code: " << i_code[0] << std::endl;
      exit(1);
    }

    m_bottlesize = i_code[1] - '0';
  } 
  else if (i_type == SOURCE)
  {
    switch (i_code[0])
    {
    case 'Y': m_color = ColorInfo::YELLOW; break;
    case 'R': m_color = ColorInfo::RED; break;
    case 'B': m_color = ColorInfo::BLUE; break;
    case 'Q': m_color = ColorInfo::QUICKSILVER; break;
    default:
      std::cout << "Illegal source code: " << i_code << std::endl;
      exit(1);
    }
  }
  else
  {
    std::map<std::string,PipeDefinition >::iterator findit= s_PipeDefinitions.find(i_code);
    if (findit == s_PipeDefinitions.end())
    {
      std::cout << "Illegal pipe code: " << i_code << std::endl;
      exit(1);
    }

    PipeDefinition pdef = findit->second;

    int k;
    for (k = 0 ; k < 6 ; ++k)
    {
      if (pdef[k] > m_numpipes) m_numpipes = pdef[k];
    }

    m_UniqueRotations.push_back(pdef);

    int i;
    for (i = 1 ; i < 6 ; ++i)
    {
      pdef = RotateDefinition(pdef);

      int j;
      bool found = false;
      for (j = 0 ; j < i ; ++j)
      {
        if (pdef == m_UniqueRotations[j] || pdef == PipeSwap(m_UniqueRotations[j]))
        {
          found = true;
          break;
        }
      }
      if (!found) m_UniqueRotations.push_back(pdef);
    }
  }

  return true;
}

BoardCell::CellType BoardCell::GetType() const 
{ return m_type; }

int BoardCell::GetBottleSize() const 
{ return m_bottlesize; }

int BoardCell::GetNumPipes() const 
{ return m_numpipes; }

const std::vector<PipeDefinition> &BoardCell::GetUniquePipeRotations() const
{ return m_UniqueRotations; }

ColorInfo::Color BoardCell::GetColor() const
{
  return m_color;
}
