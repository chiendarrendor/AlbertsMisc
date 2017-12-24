#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <list>
#include <unordered_map>
#include <sstream>
#include <limits.h>

template <class T>
inline void hash_combine(std::size_t & seed, const T & v)
{
  std::hash<T> hasher;
  seed ^= hasher(v) + 0x9e3779b9 + (seed << 6) + (seed >> 2);
}

namespace std
{
  template<typename S, typename T> struct hash<pair<S, T>>
  {
    inline size_t operator()(const pair<S, T> & v) const
    {
      size_t seed = 0;
      ::hash_combine(seed, v.first);
      ::hash_combine(seed, v.second);
      return seed;
    }
  };
}

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
  LDist(const std::string& i_s1,const std::string& i_s2);
  int Distance() const;
  std::string FromAugment() const;
  std::string ToAugment() const;
private:
  const std::string &m_s1;
  const std::string &m_s2;
  typedef std::unordered_map<std::pair<int,int>,LDReturn> MemoMap;
  mutable MemoMap m_memo;
  mutable int m_smallest;
  LDReturn broken;
  const LDReturn& theReturn;

  const LDReturn& LevenshteinDistance(int parcount,const std::string& s1,int s1idx,const std::string& s2,int s2idx) const;
};

LDist::LDist(const std::string& i_s1,const std::string& i_s2) :
  m_s1(i_s1),
  m_s2(i_s2),
  m_smallest(INT_MAX),
  broken(2 * i_s1.length() + 2 * i_s2.length()),
  theReturn(LevenshteinDistance(0,i_s1,0,i_s2,0))
{
}

const LDReturn& LDist::LevenshteinDistance(int parcount,const std::string& s1,int s1idx,const std::string& s2,int s2idx) const
{
  std::pair<int,int> keypair(s1idx,s2idx);

  //  if (parcount >= m_smallest) return broken;

  MemoMap::const_iterator fit = m_memo.find(keypair);


  if (fit != m_memo.end()) 
  {
    return fit->second;
  }

  if (s1.length() == 0)
  {
    LDReturn ldr(s2.length());

    if (parcount + s2.length() < m_smallest) m_smallest = parcount + s2.length();

    std::string d("I");

    for (size_t i = 0 ; i < s2.length() ; ++i) { ldr.deltas += d; }
    m_memo[keypair] = ldr;

    return m_memo[keypair];
  }

  if (s2.length() == 0)
  {
    LDReturn ldr(s1.length());

    if (parcount + s1.length() < m_smallest) m_smallest = parcount + s1.length();

    std::string d("D");

    for (size_t i = 0 ; i < s1.length() ; ++i) { ldr.deltas += d; }
    m_memo[keypair] = ldr;

    return m_memo[keypair];
  }

  const LDReturn &opt3 = LevenshteinDistance(parcount + (s1[0] == s2[0] ? 0 : 1) , 
					     s1.substr(1),s1idx+1,s2.substr(1),s2idx+1);
  const LDReturn &opt1 = LevenshteinDistance(parcount+1,s1.substr(1),s1idx+1,s2,s2idx);
  const LDReturn &opt2 = LevenshteinDistance(parcount+1,s1,s1idx,s2.substr(1),s2idx+1);

  int od1 = opt1.distance + 1;
  int od2 = opt2.distance + 1;
  int od3 = opt3.distance + (s1[0] == s2[0] ? 0 : 1);

  if (opt1 == broken && opt2 == broken && opt3 == broken) return broken;

  if (od1 <= od2 && od1 <= od3)
  {
    LDReturn ldr(od1);
    ldr.deltas = std::string("D") + opt1.deltas;
    m_memo[keypair] = ldr;

    return m_memo[keypair];
  }
  
  if (od2 <= od3)
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

  std::ifstream ifs(argv[1]);

  std::string str1,str2;
  std::getline(ifs,str1);
  std::getline(ifs,str2);
  ifs.close();

  LDist ld(str1,str2);

  std::cout << ld.Distance() << std::endl;
  std::cout << ld.FromAugment() << std::endl;
  std::cout << ld.ToAugment() << std::endl;
}

