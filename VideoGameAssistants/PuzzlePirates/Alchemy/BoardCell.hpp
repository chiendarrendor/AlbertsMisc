#include <string>
#include <iostream>
#include <map>
#include <boost/array.hpp>
#include <vector>
#include "ColorInfo.hpp"

typedef boost::array<int,6> PipeDefinition;

class BoardCell
{
public:
  enum CellType { SOURCE,BOTTLE,NORMAL };

  BoardCell();

  bool AssignContentCode(const std::string &i_code,CellType i_type = NORMAL);

  CellType GetType() const;
  int GetBottleSize() const;
  int GetNumPipes() const;

  ColorInfo::Color GetColor() const;
  const std::vector<PipeDefinition> &GetUniquePipeRotations() const;

private:
  CellType m_type;
  int m_bottlesize;
  int m_numpipes;
  ColorInfo::Color m_color;
  
  std::vector<PipeDefinition> m_UniqueRotations;

  static void SetPipeDefinition(const std::string &i_name,
                                int i0,int i1,int i2,int i3,int i4,int i5);

  static PipeDefinition RotateDefinition(const PipeDefinition &i_pdef);
  static PipeDefinition PipeSwap(const PipeDefinition &i_pdef);

  static bool s_Initialized;
  static std::map<std::string,PipeDefinition > s_PipeDefinitions;
};
