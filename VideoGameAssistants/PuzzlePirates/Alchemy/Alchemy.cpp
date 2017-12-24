#include "Board.hpp"
#include "BoardOrganism.hpp"
#include "GA.hpp"
#include "HexGridPrint.hpp"
#include <boost/lexical_cast.hpp>
#include <math.h>

void ShowStatistics(const std::vector<BoardOrganism *> &i_organisms)
{
  size_t j;

  double smallest = -1;
  double largest = -1;
  double meannum = 0;
  double meanden = 0;
  for (j = 0 ; j < i_organisms.size() ; ++j)
  {
    double f=i_organisms[j]->GetFitness();
    if (smallest == -1 || f < smallest)
    {
      smallest = f;
    }
    if (largest == -1 || f > largest)
    {
      largest = f;
    }

    meannum += f;
    meanden += 1;
  }
  double mean = meannum / meanden;
  double ssq = 0;
  for (j = 0 ; j < i_organisms.size() ; ++j)
  {
    double var = i_organisms[j]->GetFitness() - mean;
    ssq += var * var;
  }
  double stdev = sqrt(ssq / meanden);

  std::cout << smallest << "--|" << mean - stdev << "|||" << mean << 
    "|||" << mean+stdev << "|--" << largest << std::endl;
}




void ShowBoardOrganism(const BoardOrganism &bo,const Board &b)
{
  HexGridPrint hgp(11,12,false,true);

  int i,j;
  for (i = 0 ; i < 11 ; ++i)
  {
    for (j = 0 ; j < 11 + (i%2) ; j++)
    {
      const BoardCell &bc = b.GetCell(i,j);

      if (bc.GetType() == BoardCell::BOTTLE)
      {
        hgp.AddItem(i,j,HexGridPrint::DIR3,ColorInfo::GetColorChar(bc.GetColor()));
        hgp.AddItem(i,j,HexGridPrint::STAT1,boost::lexical_cast<char>(bc.GetBottleSize()));
      }
      else if (bc.GetType() == BoardCell::SOURCE)
      {
        hgp.AddItem(i,j,HexGridPrint::DIR0,ColorInfo::GetColorChar(bc.GetColor()));
      }
      else
      {
        size_t k;
        for (k = 0 ; k < 6 ; ++k)
        {
          const PipeDefinition &pdef = bc.GetUniquePipeRotations()[bo.GetAllele(i,j)];

          if (pdef[k] != 0)
            hgp.AddItem(i,j,(HexGridPrint::HexLoc)k,boost::lexical_cast<char>(pdef[k]));
        }
      }
    }
  }
  std::cout << hgp.Show() << "Fitness: " << bo.GetFitnessDescriptor() << std::endl << bo.GetMetaState();
}



const BoardOrganism *bestone = NULL;

void ManageBestOrganism(const std::vector<BoardOrganism *> &i_organisms,const Board &b)
{
  size_t j;

  bool bested = false;
  for (j = 0 ; j < i_organisms.size() ; ++j)
  {
    if (!bestone || bestone->GetFitness() < i_organisms[j]->GetFitness())
    {
      bestone = i_organisms[j];
      bested = true;
    }
  }
  if (bested)
  {
    ShowBoardOrganism(*bestone,b);
  }
}


int main(int argc,char **argv)
{
  if (argc != 2)
  {
    std::cout << "Bad command line; need file name." << std::endl;
    exit(1);
  }

  Board b(argv[1]);

  BoardOrganism::Initialize(b);

  GA<BoardOrganism> ga(100);

  int i;
  for (i = 0 ; i < 100 ; ++i)
  {
    std::cout << "Generation " << i << " ";

    ShowStatistics(ga.GetCurrentPopulation());
    ManageBestOrganism(ga.GetCurrentPopulation(),b);


    ga.Generate(10);
  }
}



      
