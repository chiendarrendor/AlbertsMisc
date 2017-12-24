#include "SubString.hpp"

SubString::SubString(const std::string &i_string,size_t first,size_t length) :
  m_string(&i_string),
  m_first(first),
  m_length(length)
{
}

SubString::SubString(const SubString& i_right)
{
  *this = i_right;
}

SubString& SubString::operator=(const SubString& i_right)
{
  if (this != &i_right)
  {
    m_string = i_right.m_string;
    m_first = i_right.m_first;
    m_length = i_right.m_length;
  }
  return *this;
}

SubString::SubString() : m_string(NULL),m_first(0),m_length(0) {}


int SubString::GetLength() const { return m_length; }
int SubString::GetCharAt(size_t index) const { return (*m_string)[index]; }

SubString SubString::SubSubString(size_t first,size_t length) const
{
  return SubString(*m_string,m_first+first,length);
}

SubString SubString::SubStringToEnd(size_t first) const
{
  return SubString(*m_string,m_first+first,m_length-first);
}

std::string SubString::ToString() const
{
  return m_string->substr(m_first,m_length);
}

