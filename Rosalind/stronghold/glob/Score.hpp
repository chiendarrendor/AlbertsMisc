#include <unordered_map>

#include "PairHash.hpp"

class Score
{
public:
  Score(const char* filename);
  int GetGapPenalty() const;
  int GetScore(char from,char to) const;
private:
  int m_gappenalty;
  typedef std::unordered_map<std::pair<char,char>,int> ScoreMap;
  ScoreMap m_scoremap;
  
};

