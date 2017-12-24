#include <string>

class XYPrint
{
public:
  XYPrint(int i_width,int i_height);

  void SetChar(int i_x,int i_y,char i_c);

  enum Dir { LEFT,RIGHT,UP,DOWN };

  void AddString(const std::string &i_string,int i_x,int i_y,Dir i_d=RIGHT);

  const std::string &Show() const;

private:
  std::string m_grid;
  int m_width;
  int m_height;
};

