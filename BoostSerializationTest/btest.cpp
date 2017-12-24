#include <boost/noncopyable.hpp>
#include <iostream>
#include <boost/filesystem.hpp>
#include <OpenZorz/common/Serialize.hpp>
#include <fstream>

class foo : public boost::noncopyable
{
public:
  int a;

  SERIALIZE_FUNC
  {
    SERIALIZE(a);
  }

};

int main(int argc,char **argv)
{
  foo f;

  std::cout << "F.A: " << f.a << std::endl;

  std::cout << "FileSize: " << boost::filesystem::file_size("btest.cpp") << std::endl;

  std::ofstream outdata("sertest.xml");
  SaveArchive i_ar(outdata);
  SERIALIZE(f);

}

// boost_serialization_mgw45-mt-1_46
