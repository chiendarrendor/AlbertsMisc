#include "Board.hpp"
#include "HexGridPrint.hpp"
#include <boost/lexical_cast.hpp>
#include "BoardOrganism.hpp"
#include "MersenneTwister.h"
#include "ColorInfo.hpp"


void ShowOneRotation(HexGridPrint &hgp,const BoardCell &bc,int xcoord)
{
  size_t i;

  for (i = 0 ; i < bc.GetUniquePipeRotations().size() ; ++i)
  {
    const PipeDefinition &pdef = bc.GetUniquePipeRotations()[i];
    
    size_t k;

    for (k = 0 ; k < 6 ; ++k)
    {
      if (pdef[k] != 0)
        hgp.AddItem(xcoord,i,(HexGridPrint::HexLoc)k,boost::lexical_cast<char>(pdef[k]));
    }
  }
}

void ShowRotations(const Board &b)
{
  HexGridPrint hgp(11,12,false,true);
  
  ShowOneRotation(hgp,b.GetCell(4,1),0);
  ShowOneRotation(hgp,b.GetCell(6,2),1);
  ShowOneRotation(hgp,b.GetCell(1,1),2);
  ShowOneRotation(hgp,b.GetCell(0,4),3);
  ShowOneRotation(hgp,b.GetCell(3,10),4);
  ShowOneRotation(hgp,b.GetCell(10,7),5);
  ShowOneRotation(hgp,b.GetCell(7,5),6);
  ShowOneRotation(hgp,b.GetCell(2,3),7);
  
  std::cout << hgp.Show();
}

void Highlight(HexGridPrint &hgp,int x,int y,char c)
{
  hgp.AddItem(x,y,HexGridPrint::DIR1,c);
  hgp.AddItem(x,y,HexGridPrint::DIR2,c);
  hgp.AddItem(x,y,HexGridPrint::DIR4,c);
  hgp.AddItem(x,y,HexGridPrint::DIR5,c);
}

void ShowBoardOrganismConstruction(const BoardOrganism &bo,const Board &b)
{
  HexGridPrint hgp(11,12,false,true);

  int i,j;
  for (i = 0 ; i < 11 ; ++i)
  {
    for (j = 0 ; j < 11 + (i%2) ; j++)
    {
      int al = bo.GetAllele(i,j);
      const BoardCell &bc = b.GetCell(i,j);

      if (bc.GetType() != BoardCell::NORMAL)
      {
        if (al != -1) Highlight(hgp,i,j,'?');
      }
      else
      {
        hgp.AddItem(i,j,HexGridPrint::STAT1,boost::lexical_cast<char>(al));
        hgp.AddItem(i,j,HexGridPrint::STAT2,boost::lexical_cast<char>(bc.GetUniquePipeRotations().size()));

        if (al < 0 || al >= (int)bc.GetUniquePipeRotations().size()) Highlight(hgp,i,j,'?');
      }
    }
  }
  std::cout << hgp.Show();
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
  std::cout << hgp.Show();
}

void ShowBoardOrganismMutation(const BoardOrganism &bo,const BoardOrganism &bo2,const Board &b)
{
  HexGridPrint hgp(11,12,false,true);

  int i,j;
  for (i = 0 ; i < 11 ; ++i)
  {
    for (j = 0 ; j < 11 + (i%2) ; j++)
    {
      int al = bo.GetAllele(i,j);
      int al2 = bo2.GetAllele(i,j);
      const BoardCell &bc = b.GetCell(i,j);

      if (bc.GetType() != BoardCell::NORMAL)
      {
        if (al != -1) Highlight(hgp,i,j,'?');
        if (al2 != -1) Highlight(hgp,i,j,'!');
      }
      else
      {
        hgp.AddItem(i,j,HexGridPrint::STAT1,boost::lexical_cast<char>(al));
        hgp.AddItem(i,j,HexGridPrint::STAT2,boost::lexical_cast<char>(al2));

        if (al != al2) Highlight(hgp,i,j,'*');
      }
    }
  }
  std::cout << hgp.Show();
}

void ShowBoardOrganismCrossover(const Board &b,
                                const BoardOrganism &bp1,
                                const BoardOrganism &bp2,
                                const BoardOrganism &bch)
{
  HexGridPrint hgp(11,12,false,true);

  int i,j;
  for (i = 0 ; i < 11 ; ++i)
  {
    for (j = 0 ; j < 11 + (i%2) ; j++)
    {
      int alp1 = bp1.GetAllele(i,j);
      int alp2 = bp2.GetAllele(i,j);
      int alch = bch.GetAllele(i,j);

      const BoardCell &bc = b.GetCell(i,j);

      if (bc.GetType() != BoardCell::NORMAL)
      {
        if (alp1 != -1) Highlight(hgp,i,j,'?');
        if (alp2 != -1) Highlight(hgp,i,j,'!');
        if (alch != -1) Highlight(hgp,i,j,'@');
      }
      else
      {
        hgp.AddItem(i,j,HexGridPrint::DIR0,boost::lexical_cast<char>(alp2));
        hgp.AddItem(i,j,HexGridPrint::DIR3,boost::lexical_cast<char>(alp1));
        hgp.AddItem(i,j,HexGridPrint::STAT1,boost::lexical_cast<char>(alch));

        if (alp1 == alp2)
        {
          if (alp1 != alch)
          {
            Highlight(hgp,i,j,'?');
          }
        }
        else
        {
          if (alp1 == alch)
          {
            Highlight(hgp,i,j,'^');
          }
          else if (alp2 == alch)
          {
            Highlight(hgp,i,j,'v');
          }
          else
          {
            Highlight(hgp,i,j,'!');
          }
        }
      }
    }
  }
  std::cout << hgp.Show();
}




int main(int argc,char **argv)
{
  Board b("tboard.txt");
  MTRand rand;
  BoardOrganism::Initialize(b,rand);
  BoardOrganism bo;

  //ShowRotations(b);
  //ShowBoardOrganismConstruction(bo,b);

  BoardOrganism bo2 = bo;
  bo2.Mutate();

  // ShowBoardOrganismMutation(bo,bo2,b);

  BoardOrganism bo3;

  BoardOrganism boc(bo);

  boc.Crossover(bo3);

  // ShowBoardOrganismCrossover(b,bo,bo3,boc);

  ShowBoardOrganism(bo,b); // this one's non-test useful :-)
  bo.GetFitness();

  std::cout << "Outer Secondary: " << ColorInfo::GetColorChar(b.GetOuterSecondary()) << std::endl;


}
