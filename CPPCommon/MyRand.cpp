#include <time.h>
#include <boost/random.hpp>

#define RNGTYPE boost::mt19937

namespace
{
  RNGTYPE *pRNG = NULL;
};

void Init()
{
  if (!pRNG) pRNG = new RNGTYPE (::time(NULL));
}

int DieRoll(int i_nsides)
{
  Init();
  boost::uniform_smallint<> die(1,i_nsides);
  boost::variate_generator<RNGTYPE&,boost::uniform_smallint<> > r(*pRNG,die);
  return r();
}

bool CoinFlip()
{
  Init();
  boost::uniform_smallint<> die(1,2);
  boost::variate_generator<RNGTYPE&,boost::uniform_smallint<> > r(*pRNG,die);
  return r() == 1;
}

int RandRange(int i_lowest,int i_highest)
{
  Init();
  boost::uniform_int<> die(i_lowest,i_highest);
  boost::variate_generator<RNGTYPE&,boost::uniform_int<> > r(*pRNG,die);
  return r();
}

double Rand01()
{
  Init();
  boost::uniform_01<RNGTYPE> r01(*pRNG);
  return r01();
}

double RandRange(double i_lowest,double i_highest)
{
  Init();
  boost::uniform_real<> die(i_lowest,i_highest);
  boost::variate_generator<RNGTYPE&,boost::uniform_real<> > r(*pRNG,die);
  return r();
}

  
    
  
