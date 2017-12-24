#include "BoardOrganism.hpp"
#include "Board.hpp"
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/connected_components.hpp>
#include "MyRand.hpp"
#include <math.h>
#include <sstream>

const double QUICKSILVERCOLORSCORE = 1.0;
const double BROWNCOLORSCORE = 0.0;
const double PRIMARYCOLORSCORE = 1.0;
const double SECONDARYCOLORSCORE = 2.0;
const double OUTERSECONDARYCOLORSCORE = 3.0;
const double BOTTLEPOPPENALTY = -5.0;



const Board *BoardOrganism::s_pBoard = NULL;
bool BoardOrganism::s_Initialized = false;
int BoardOrganism::s_UID = 0;

void BoardOrganism::Initialize(const Board &i_b)
{
  s_Initialized = true;
  s_pBoard = &i_b;
}

BoardOrganism::BoardOrganism() : 
  m_UID(s_UID++),
  m_mFitness(-1),
  m_metamutationprobability(Rand01()),
  m_mutationcount(RandRange(1,20)),
  m_normalmutationprobability(Rand01())
{
  FixMetaBounds();
  int i,j;

  for (i = 0 ; i < 11 ; ++i)
  {
    for (j = 0 ; j < 11 + (i%2) ; j++)
    {
      const BoardCell &bc = s_pBoard->GetCell(i,j);
      if (bc.GetType() == BoardCell::NORMAL)
      {
        m_dna[i][j] = RandRange(0,bc.GetUniquePipeRotations().size()-1);
      }
      else
      {
        m_dna[i][j] = -1;
      }
    }
  }
  std::cout << "CTOR: " << m_UID << std::endl;
}

BoardOrganism::BoardOrganism(const BoardOrganism &i_right) : 
  m_UID(s_UID++),
  m_mFitness(i_right.m_mFitness),
  m_metamutationprobability(i_right.m_metamutationprobability),
  m_mutationcount(i_right.m_mutationcount),
  m_normalmutationprobability(i_right.m_normalmutationprobability)
{
  FixMetaBounds();
  int i,j;

  for (i = 0 ; i < 11 ; ++i)
  {
    for (j = 0 ; j < 11 + (i%2) ; j++)
    {
      m_dna[i][j] = i_right.GetAllele(i,j);
    }
  }
  std::cout << "copy CTOR: " << m_UID << std::endl;
}

BoardOrganism::~BoardOrganism()
{
  std::cout << "dtor: " << m_UID << std::endl;
}


int BoardOrganism::GetAllele(int i,int j) const
{
  return m_dna[i][j];
}

void BoardOrganism::Crossover(const BoardOrganism &i_right)
{
  int i,j;
  m_mFitness = -1;

  m_metamutationprobability = CoinFlip() ? m_metamutationprobability : i_right.m_metamutationprobability;

  m_mutationcount = CoinFlip() ? m_mutationcount : i_right.m_mutationcount;

  m_normalmutationprobability = CoinFlip() ? m_normalmutationprobability : i_right.m_normalmutationprobability;

  FixMetaBounds();


  for (i = 0 ; i < 11 ; ++i)
  {
    for (j = 0 ; j < 11 + (i%2) ; j++)
    {
      if (m_dna[i][j] == -1) continue;

      if (CoinFlip())
      {
        m_dna[i][j] = i_right.GetAllele(i,j);
      }
    }
  }
}

void BoardOrganism::Mutate()
{
  int rx,ry;
  const BoardCell *pbc = NULL;

  if (Rand01() < m_metamutationprobability)
  {
    switch(RandRange(0,2))
    {
    case 0:
      m_metamutationprobability += RandRange(-0.05,+0.05);
      break;
    case 1:
      m_mutationcount += RandRange(-3,+3);
      break;
    case 2:
      m_normalmutationprobability += RandRange(-0.05,+0.05);
      break;
    }
    FixMetaBounds();
  }

  if (Rand01() >= m_normalmutationprobability) return;

  m_mFitness = -1;

  int i;
  for (i = 0 ; i < m_mutationcount ; ++i)
  {
    do
    {
      // find a random normal cell.
      // x is any column
      rx = RandRange(0,10);

      // y is 0-10 but
      // 1 longer if rx%2 == 1
      // rows 0 and maxy are specials
      ry = RandRange(0,10+(rx%2)-2) + 1;

      pbc = &(s_pBoard->GetCell(rx,ry));
    
      if (pbc == NULL || pbc->GetType() != BoardCell::NORMAL)
      {
        std::cout << "Illegal mutation cell calculated: " << rx << "," << ry << std::endl;
        exit(1);
      }
    } while(pbc->GetUniquePipeRotations().size() == 1);

    int oldal = m_dna[rx][ry];
    int rawnewal = RandRange(0,pbc->GetUniquePipeRotations().size() - 2);
    if (rawnewal < oldal)
    {
      m_dna[rx][ry] = rawnewal;
    }
    else
    {
      m_dna[rx][ry] = rawnewal + 1;
    }
  }
}

struct CellKey
{
  int m_i;
  int m_j;
  int m_p;
  CellKey(int i_i,int i_j,int i_p) : m_i(i_i),m_j(i_j),m_p(i_p) {}
};

bool operator<(const CellKey &i_left,const CellKey &i_right)
{
  if (i_left.m_i != i_right.m_i) return i_left.m_i < i_right.m_i;
  if (i_left.m_j != i_right.m_j) return i_left.m_j < i_right.m_j;
  return i_left.m_p < i_right.m_p;
}

// returns the pipe id 
int BoardOrganism::GetPipeId(int i_i,int i_j,int i_dir) const
{
  if (i_i < 0 || i_i >= 11) return 0;
  if (i_j < 0 || i_j >= 11 + (i_i % 2)) return 0;
  if (s_pBoard->GetCell(i_i,i_j).GetType() == BoardCell::SOURCE)
    return (i_dir == 0) ? 1 : 0;
  if (s_pBoard->GetCell(i_i,i_j).GetType() == BoardCell::BOTTLE)
    return (i_dir == 3) ? 1 : 0;
  return s_pBoard->GetCell(i_i,i_j).GetUniquePipeRotations()[GetAllele(i_i,i_j)][i_dir];
}

int BoardOrganism::GetXInDir(int i_i,int i_j,int i_dir)
{
  if (i_dir == 1 || i_dir == 2) return i_i-1;
  if (i_dir == 0 || i_dir == 3) return i_i;
  return i_i+1;
}

int BoardOrganism::GetYInDir(int i_i,int i_j,int i_dir)
{
  if (i_dir == 0) return i_j+1;
  if (i_dir == 3) return i_j-1;
  if (i_dir == 2 || i_dir == 4)
  {
    if (i_i % 2 == 0) return i_j;
    else return i_j-1;
  }
  else
  {
    if (i_i % 2 == 0) return i_j+1;
    else return i_j;
  }
}
  
double BoardOrganism::GetFitness() const
{
  if (m_mFitness != -1) return m_mFitness;

  // create a mapping between cell x,y,pipe # and a unique integer.
  std::map<CellKey,int> cellMap;

  boost::adjacency_list<boost::vecS,boost::vecS,boost::undirectedS> graph;

  // for each cell
  int i,j,k;
  for (i = 0 ; i < 11 ; ++i)
  {
    for (j = 0 ; j < 11 + (i%2) ; j++)
    {
      // make an entry for each pipe in this cell
      const BoardCell &bc = s_pBoard->GetCell(i,j);
      for (k = 1 ; k <= bc.GetNumPipes() ; k++)
      {
        cellMap[CellKey(i,j,k)] = boost::add_vertex(graph);
      }

      // go out edges 1,2,3 and see if we can hook up edges
      int nx,ny;
      int myedge;
      int oedge;
      int dir;

      // edge 1
      dir = 1;
      nx = GetXInDir(i,j,dir);
      ny = GetYInDir(i,j,dir);
      myedge = GetPipeId(i,j,dir);
      oedge = GetPipeId(nx,ny,(dir+3)%6);

      if (myedge != 0 && oedge != 0)
      {
        boost::add_edge(cellMap[CellKey(i,j,myedge)],cellMap[CellKey(nx,ny,oedge)],graph);
      }

      // edge 2
      dir = 2;
      nx = GetXInDir(i,j,dir);
      ny = GetYInDir(i,j,dir);
      myedge = GetPipeId(i,j,dir);
      oedge = GetPipeId(nx,ny,(dir+3)%6);

      if (myedge != 0 && oedge != 0)
      {
        boost::add_edge(cellMap[CellKey(i,j,myedge)],cellMap[CellKey(nx,ny,oedge)],graph);
      }

      // edge 3
      dir = 3;
      nx = GetXInDir(i,j,dir);
      ny = GetYInDir(i,j,dir);
      myedge = GetPipeId(i,j,dir);
      oedge = GetPipeId(nx,ny,(dir+3)%6);

      if (myedge != 0 && oedge != 0)
      {
        boost::add_edge(cellMap[CellKey(i,j,myedge)],cellMap[CellKey(nx,ny,oedge)],graph);
      }
    }
  }
  std::vector<int> component(boost::num_vertices(graph));
  int numcon = boost::connected_components(graph,&component[0]);

  std::map<CellKey,int>::iterator loopit;
  std::map<int,std::vector<CellKey> > revlist;
  for(loopit = cellMap.begin() ; loopit != cellMap.end() ; ++loopit)
  {
    const CellKey &ck = loopit->first;

    int ccon = component[loopit->second];
    revlist[ccon].push_back(ck);
  }

  std::set<ColorInfo::Color> usedcolors;
  double bottlescore = 0.0;

  std::ostringstream oss;

  oss << "nc: " << numcon << "  ";



  int normalcellcount = 0;
  int terminatingcellcount = 0;

  std::map<int,std::vector<CellKey> >::iterator pit;
  for (pit = revlist.begin() ; pit != revlist.end() ; ++pit)
  {
    size_t idx;
    bool hasbottle = false;
    bool hasend = false;
    int localcellcount = 0;

    // determine what the source color is by mixing all the sources in this connected component.
    ColorInfo::Color sourcecolor = ColorInfo::WHITE;
    for (idx = 0 ; idx < pit->second.size() ; ++idx)
    {
      const CellKey &ck = pit->second[idx];
      const BoardCell &bc = s_pBoard->GetCell(ck.m_i,ck.m_j);
      BoardCell::CellType ct = bc.GetType();

      if (ct == BoardCell::NORMAL) 
      {
        normalcellcount++;
        localcellcount++;
        continue;
      }

      hasend = true;
      if (ct == BoardCell::SOURCE) sourcecolor = ColorInfo::Mix(sourcecolor,bc.GetColor());
      if (ct == BoardCell::BOTTLE) hasbottle = true;
    }

    if (hasend) terminatingcellcount += localcellcount;

    // if there are no sources, ignore it.
    if (sourcecolor == ColorInfo::WHITE) continue;
    // if there are no bottles, ignore it.
    if (!hasbottle) continue;

    double colorscore;
    if (sourcecolor == ColorInfo::QUICKSILVER) colorscore = QUICKSILVERCOLORSCORE;
    else if (sourcecolor == ColorInfo::BROWN) colorscore = BROWNCOLORSCORE;
    else if (sourcecolor == ColorInfo::RED || 
             sourcecolor == ColorInfo::YELLOW ||
             sourcecolor == ColorInfo::BLUE) colorscore = PRIMARYCOLORSCORE;
    else if (sourcecolor == s_pBoard->GetOuterSecondary()) colorscore = OUTERSECONDARYCOLORSCORE;
    else colorscore = SECONDARYCOLORSCORE;

    oss << ColorInfo::GetColorChar(sourcecolor) << "->";

    // for all the bottles in this connected component, score them based on the aggregate pouring color.
    for (idx = 0 ; idx < pit->second.size() ; ++idx)
    {
      const CellKey &ck = pit->second[idx];
      const BoardCell &bc = s_pBoard->GetCell(ck.m_i,ck.m_j);
      BoardCell::CellType ct = bc.GetType();

      if (ct != BoardCell::BOTTLE) continue;

      oss << ColorInfo::GetColorChar(bc.GetColor()) << bc.GetBottleSize();

      if (sourcecolor != ColorInfo::QUICKSILVER && sourcecolor != bc.GetColor())
      { 
        bottlescore += BOTTLEPOPPENALTY;
        oss << "(pop!)";
      }
      else 
      { 
        bottlescore += colorscore * bc.GetBottleSize();
        usedcolors.insert(sourcecolor);
      }
      oss << ",";
    }
  }
  double flowscore = bottlescore * usedcolors.size();

  double pipescore = double(terminatingcellcount)/double(normalcellcount);
  //  double pipescore = double(s_pBoard->GetNumPipes - numcon);

  double result;
  if (flowscore < 0) result = 0;
  else result = flowscore + pipescore;

  oss << "----" << result;
  m_mFitnessDescriptor = oss.str();

  return (result == 0) ? 0 : exp(result);
}

const std::string &BoardOrganism::GetFitnessDescriptor() const
{
  return m_mFitnessDescriptor;
}

const std::string BoardOrganism::GetMetaState() const
{
  std::ostringstream oss;
  oss << "MMP: " << m_metamutationprobability << std::endl;
  oss << "MC: " << m_mutationcount << std::endl;
  oss << "NMP: " << m_normalmutationprobability << std::endl;
  return oss.str();
}

void BoardOrganism::FixMetaBounds()
{
  if (m_metamutationprobability > 1) m_metamutationprobability = 1;
  if (m_normalmutationprobability > 1) m_metamutationprobability = 1;
  if (m_metamutationprobability < .01) m_metamutationprobability = .01;
  if (m_normalmutationprobability < .01) m_normalmutationprobability = .01;
  if (m_mutationcount < 2) m_mutationcount = 2;
}
