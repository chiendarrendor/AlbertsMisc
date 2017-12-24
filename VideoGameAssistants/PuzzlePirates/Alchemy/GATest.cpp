#include "GA.hpp"

struct TPop
{
  TPop() : m_datum(s_pRandPtr->randInt()) {}
  TPop(const TPop &i_right) : m_datum(i_right.m_datum) {}

  void Mutate()
  {
    m_datum = m_datum ^ (1 << s_pRandPtr->randInt(31));
  }

  void Crossover(const TPop &i_right)
  {
    unsigned long thismask;
    unsigned long rightmask;

    int cnt = s_pRandPtr->randInt(31);
    int hilo = s_pRandPtr->randInt(1);

    unsigned long mask = 0;
    int i;
    for (i = 0 ; i < cnt ; ++i)
    {
      mask = mask << 1;
      mask += 1;
    }
    if (hilo == 0)
    {
      thismask = mask;
      rightmask = ~mask;
    }
    else
    {
      thismask = ~mask;
      rightmask = mask;
    }

    m_datum = (m_datum & thismask) + (i_right.m_datum & rightmask);
  }

  double GetFitness() const { return (double)m_datum; }


  static MTRand *s_pRandPtr;
  unsigned long m_datum;
};

MTRand *TPop::s_pRandPtr = NULL;

int main(int argc,char **argv)
{
  TPop::s_pRandPtr = new MTRand;

  GA<TPop> testga(10,.01);

  int gen = 0;

  do
  {
    std::cout << "gen " << gen << ": ";
    int i;
    for (i = 0 ; i < 10 ; ++i)
    {
      std::cout << std::hex << testga.GetCurrentPopulation()[i].m_datum << " ";
    }
    std::cout << std::endl;

    testga.Generate();

  }  while(gen++ < 20);
}


