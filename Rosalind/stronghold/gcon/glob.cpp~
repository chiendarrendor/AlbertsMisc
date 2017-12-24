#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <list>
#include <unordered_map>
#include <sstream>
#include <limits.h>

#include "PairHash.hpp"
#include "Score.hpp"

class LDReturn
{
public:
  LDReturn() {}
  LDReturn(int i_dist) : distance(i_dist) {}
  LDReturn(const LDReturn& i_right) : distance(i_right.distance),deltas(i_right.deltas) {}
  LDReturn& operator=(const LDReturn& i_right)
  {
    if (this == &i_right) return *this;
    distance = i_right.distance;
    deltas = i_right.deltas;
  }

  bool operator==(const LDReturn& i_right) const { return distance == i_right.distance; }

  int distance;
  std::string deltas;
};



class LDist
{
public:
  LDist(const std::string& i_s1,const std::string& i_s2, const Score& i_score);
  int Distance() const;
  std::string FromAugment() const;
  std::string ToAugment() const;
private:
  const std::string &m_s1;
  const std::string &m_s2;
  const Score& m_score;
  typedef std::unordered_map<std::pair<int,int>,LDReturn> MemoMap;
  mutable MemoMap m_memo;
  const LDReturn& theReturn;

  const LDReturn& LevenshteinDistance(const std::string& s1,int s1idx,const std::string& s2,int s2idx) const;
};

LDist::LDist(const std::string& i_s1,const std::string& i_s2,const Score& i_score) :
  m_s1(i_s1),
  m_s2(i_s2),
  m_score(i_score),
  theReturn(LevenshteinDistance(i_s1,0,i_s2,0))
{
}

const LDReturn& LDist::LevenshteinDistance(const std::string& s1,int s1idx,const std::string& s2,int s2idx) const
{
  std::pair<int,int> keypair(s1idx,s2idx);

  MemoMap::const_iterator fit = m_memo.find(keypair);


  if (fit != m_memo.end()) 
  {
    return fit->second;
  }

  if (s1.length() == 0)
  {
    LDReturn ldr(-s2.length()*m_score.GetGapPenalty());

    std::string d("I");

    for (size_t i = 0 ; i < s2.length() ; ++i) { ldr.deltas += d; }
    m_memo[keypair] = ldr;

    return m_memo[keypair];
  }

  if (s2.length() == 0)
  {
    LDReturn ldr(-s1.length()*m_score.GetGapPenalty());

    std::string d("D");

    for (size_t i = 0 ; i < s1.length() ; ++i) { ldr.deltas += d; }
    m_memo[keypair] = ldr;

    return m_memo[keypair];
  }

  const LDReturn &opt3 = LevenshteinDistance(s1.substr(1),s1idx+1,s2.substr(1),s2idx+1);
  const LDReturn &opt1 = LevenshteinDistance(s1.substr(1),s1idx+1,s2,s2idx);
  const LDReturn &opt2 = LevenshteinDistance(s1,s1idx,s2.substr(1),s2idx+1);

  int od1 = opt1.distance - m_score.GetGapPenalty();
  int od2 = opt2.distance - m_score.GetGapPenalty();
  int od3 = opt3.distance + m_score.GetScore(s1[0],s2[0]);

  if (od1 >= od2 && od1 >= od3)
  {
    LDReturn ldr(od1);
    ldr.deltas = std::string("D") + opt1.deltas;
    m_memo[keypair] = ldr;

    return m_memo[keypair];
  }
  
  if (od2 >= od3)
  {
    LDReturn ldr(od2);
    ldr.deltas = std::string("I") + opt2.deltas;
    m_memo[keypair] = ldr;

    return m_memo[keypair];
  }

  if (s1[0] == s2[0])
  {
    LDReturn ldr(od3);
    ldr.deltas = std::string("S") + opt3.deltas;
    m_memo[keypair] = ldr;

    return m_memo[keypair];
  }

  LDReturn ldr(od3);
  ldr.deltas = std::string("T") + opt3.deltas;
  m_memo[keypair] = ldr;

  return m_memo[keypair];
}

int LDist::Distance() const
{
  return theReturn.distance;
}

std::string LDist::FromAugment() const
{
  std::ostringstream oss;
  int deltaidx = 0;
  int stridx = 0;

  while(deltaidx < theReturn.deltas.length())
  {
    if (theReturn.deltas[deltaidx] == 'I')
    {
      oss << '-';
    }
    else
    {
      oss << m_s1[stridx++];
    }
    ++deltaidx;
  }
  return oss.str();
}

std::string LDist::ToAugment() const
{
  std::ostringstream oss;
  int deltaidx = 0;
  int stridx = 0;

  while(deltaidx < theReturn.deltas.length())
  {
    if (theReturn.deltas[deltaidx] == 'D')
    {
      oss << '-';
    }
    else
    {
      oss << m_s2[stridx++];
    }
    ++deltaidx;
  }
  return oss.str();
}



int main(int argc,char **argv)
{
  if (argc != 2)
  {
    std::cerr << "bad command line" << std::endl;
    exit(1);
  }

  Score score("score.txt");

  std::ifstream ifs(argv[1]);

  std::string str1,str2;
  std::getline(ifs,str1);
  std::getline(ifs,str2);
  ifs.close();

  LDist ld(str1,str2,score);

  std::cout << ld.Distance() << std::endl;
  std::cout << ld.FromAugment() << std::endl;
  std::cout << ld.ToAugment() << std::endl;
}

