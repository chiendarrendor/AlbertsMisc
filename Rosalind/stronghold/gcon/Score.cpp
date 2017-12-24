#include "Score.hpp"
#include <vector>
#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <sstream>

namespace
{
  std::vector<std::string> split(std::string s)
  {
    std::vector<std::string> result;
    bool instring = false;
    int startidx;
    for (int i = 0 ; i < s.length() ; ++i)
    {
      if (s[i] == ' ' && !instring) continue;
      if (s[i] != ' ' && instring) continue;
      if (s[i] != ' ' && !instring) { instring = true; startidx = i; continue; }
      // s[i] == ' ' && instring
      instring = false;
      result.push_back(s.substr(startidx,i-startidx));
    }
    if (instring)
    {
      result.push_back(s.substr(startidx,s.length()-startidx));
    }
    return result;
  }

  std::string join(const std::string& sep, const std::vector<std::string>& items)
  {
    std::ostringstream oss;
    bool first = true;
    
    for (int i = 0 ; i < items.size() ; ++i)
    {
      if (!first) oss << sep;
      first = false;
      oss << items[i];
    }
    return oss.str();
  }

}





Score::Score(const char* filename)
{
  std::ifstream ifs(filename);
  std::string gpstring;
  std::getline(ifs,gpstring);
  m_gappenalty=atoi(gpstring.c_str());

  std::string hline;
  std::getline(ifs,hline);
  std::vector<std::string>headers = split(hline);

  std::string opline;
  while(std::getline(ifs,opline))
  {
    std::vector<std::string> items = split(opline);
    std::string fromitem = items[0];
    for (int i = 1 ; i < items.size() ; ++i)
    {
      std::string toitem = headers[i-1];
      std::pair<char,char> keypair(fromitem[0],toitem[0]);
      m_scoremap[keypair] = atoi(items[i].c_str());
    }
  }
  ifs.close();
}

int Score::GetGapPenalty() const
{
  return m_gappenalty;
}

int Score:: GetScore(char from,char to) const
{
  std::pair<char,char> keypair(from,to);
  ScoreMap::const_iterator fit = m_scoremap.find(keypair);
  if (fit == m_scoremap.end()) return 0;
  return fit->second;
}





//private:
//  int m_gappenalty;
//  typedef std::unordered_map<std::pair<char,char>,int> ScoreMap;
//  ScoreMap m_scoremap;
