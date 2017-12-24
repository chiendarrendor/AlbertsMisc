#include "THEDealer.hpp"
#include <iostream>
#include <map>

class THEHandInfo
{
public:
  THEHandInfo(Hand &h)
  {
    if (h.size() != 2)
    {
      std::cout << "bad THE hand." << std::endl;
      exit(1);
    }
    if (h[0]->GetRank() == h[1]->GetRank())
    {
      m_r1 = m_r2 = h[0]->GetRank();
    }
    else if (h[0]->GetRank() == 1)
    {
      m_r1 = 1;
      m_r2 = h[1]->GetRank();
    }
    else if (h[1]->GetRank() == 1)
    {
      m_r1 = 1;
      m_r2 = h[0]->GetRank();
    }
    else if (h[0]->GetRank() > h[1]->GetRank())
    {
      m_r1 = h[0]->GetRank();
      m_r2 = h[1]->GetRank();
    }
    else
    {
      m_r1 = h[1]->GetRank();
      m_r2 = h[0]->GetRank();
    }
    
    m_suited = h[0]->GetSuit() == h[1]->GetSuit();
  }

  Rank GetHighRank() const { return m_r1; }
  Rank GetLowRank() const { return m_r2; }
  bool IsSuited() const { return m_suited; }

  bool operator<(const THEHandInfo &i_right) const
  {
    if (this->GetHighRank() != i_right.GetHighRank()) return this->GetHighRank() < i_right.GetHighRank();
    if (this->GetLowRank() != i_right.GetLowRank()) return this->GetLowRank() < i_right.GetLowRank();
    if (this->IsSuited() == i_right.IsSuited()) return false;
    return this->IsSuited();
  }
  
private:
  Rank m_r1;
  Rank m_r2;
  bool m_suited;
};

std::ostream &operator<<(std::ostream &o,const THEHandInfo &the)
{
  if (the.GetHighRank() == the.GetLowRank())
  {
    o << GetRankString(the.GetHighRank()) << " Pair    ";
  }
  else
  {
    o << GetRankString(the.GetHighRank()) << "/" <<
      GetRankString(the.GetLowRank()) << " ";
    if (the.IsSuited())
    {
      o << "Suited";
    }
    else
    {
      o << "Unsuited";
    }
  }
  return o;
}

struct ranker
{
  bool operator()(const double &i_left,const double &i_right)
  {
    return i_left > i_right;
  }
};



int main(int argc, char **argv)
{
  std::map<THEHandInfo,std::pair<int,int> > handrankings;

  int i;

  for (i = 0 ; i < 10000 ; ++i)
  {
    THEDealer d;
    size_t j;
    std::vector<bool> winners(d.m_PlayerHands.size());
    for (j = 0 ; j < d.m_bestidx.size() ; ++j)
    {
      winners[d.m_bestidx[j]] = true;
    }

    for (j = 0 ; j < d.m_PlayerHands.size() ; ++j)
    {
      std::pair<int,int> &rankinfo = handrankings[THEHandInfo(d.m_PlayerHands[j])];
      rankinfo.second++;
      if (winners[j]) rankinfo.first++;
    }
    if (i % 1000 == 0) std::cout << "." << std::flush;
  }
  std::cout << std::endl;

  std::multimap<double,THEHandInfo,ranker> ranking;
  std::map<THEHandInfo,std::pair<int,int> >::iterator mit;

  for (mit = handrankings.begin() ; mit != handrankings.end() ; ++mit)
  {
    ranking.insert(std::multimap<double,THEHandInfo,ranker>::value_type(
           (double)mit->second.first/(double)mit->second.second,mit->first));
  }
  
  std::multimap<double,THEHandInfo,ranker>::iterator rankit;
  int ctr;
  
  for(rankit = ranking.begin(),ctr = 0;rankit != ranking.end() && ctr < 20 ; ++rankit,++ctr)
  {
    std::cout << rankit->second << "\t\t" << rankit->first << std::endl;
  }

}
