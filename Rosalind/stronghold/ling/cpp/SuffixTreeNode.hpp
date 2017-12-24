#include <vector>

class SuffixTreeEdge;

class SuffixTreeNode
{
public:
  SuffixTreeNode();
  void ProcessNewString();
  void FindCommonSubStrings(const SubString& prefix,std::vector<std::pair<SubString,size_t>> &result);
  size_t CountByLength();

  
