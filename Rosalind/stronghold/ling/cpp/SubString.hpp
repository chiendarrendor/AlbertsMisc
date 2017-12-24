#include <string>

class SubString
{
public:
  SubString(const std::string &i_string,size_t first,size_t length);
  SubString(const SubString& i_right);
  SubString();

  SubString& operator=(const SubString& i_right);

  int GetLength() const;
  int GetCharAt(size_t index) const;
  SubString SubSubString(size_t first,size_t length) const;
  SubString SubStringToEnd(size_t first) const;

  std::string ToString() const;
private:
  const std::string* m_string;
  size_t m_first;
  size_t m_length;
};

