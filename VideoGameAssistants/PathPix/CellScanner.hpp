#include <map>

class bitmapImage;

class CellScanner
{
public:
  CellScanner(const bitmapImage &i_bmi);

  bool Scan(char &o_color,int &o_num,
            int lx,int rx,
            int ty,int by,bool i_debug = false) const;
private:
  std::map<int,char> m_ColorChars;
  const bitmapImage &m_bmi;

  int identifyCharacter(int lx,int rx,int ty,int by,int pcolor,bool i_debug) const;

};

