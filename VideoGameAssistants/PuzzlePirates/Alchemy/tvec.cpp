#include <vector>
#include <iostream>

class Foo
{
public:
  Foo() : m_num(s_ctr++) { std::cout << "Foo " << m_num << " ctor" << std::endl; }
  Foo(const Foo &i_right) : m_num(s_ctr++) { std::cout << "Foo " << m_num << " cpyctor" << std::endl; }
  Foo &operator=(const Foo &i_right) { std::cout << "Foo " << m_num << " assign" << std::endl; }
  virtual ~Foo() { std::cout << "Foo " << m_num << " dtor" << std::endl; }
private:
  int m_num;
  static int s_ctr;
};

int Foo::s_ctr = 0;


int main(int argc,char **argv)
{
  std::cout << "Starting:" << std::endl;
  std::vector<Foo> f1;
  std::cout << "Adding: " << std::endl;
  f1.push_back(Foo());
  f1.push_back(Foo());
  f1.push_back(Foo());
  std::cout << "Adding existing: " << std::endl;
  Foo f;
  f1.push_back(f);
  std::cout << "assigning vector: " << std::endl;
  std::vector<Foo> f2;
  f2 = f1;
  std::cout << "Swapping vector: " << std::endl;
  std::vector<Foo> f3;
  f3.swap(f1);
  std::cout << "Going out of scope." << std::endl;
}

