#include <map>
#include <iostream>
#include <vector>
#include "CellScanner.hpp"
#include "bitmap_Image.h"

int main(int argc,char **argv)
{
  if (argc != 2)
  {
    std::cout << "Need file name on command line" << std::endl;
    exit(1);
  }


  bitmapImage bmp;
  int status = bmp.loadFromBitmapFile(argv[1]);
  if (status != 0)
  {
    std::cout << "Can't open " << argv[1] << " for reading as a .BMP." << std::endl;
    exit(1);
  }

  CellScanner cscan(bmp);

  // line color is 125 255 125
  int linecol = bmp.getColourForRGB(125,255,125);
  int i,j;
  std::map<int,int> xcount;
  std::map<int,int> ycount;
  std::map<int,int>::iterator cit;

  for (i = 0 ; i < bmp.getWidth() ; ++i)
  {
    for (j = 0 ; j < bmp.getHeight() ; ++j)
    {
      if (bmp.getPixel(i,j) != linecol) continue;
      xcount[i]++;
      ycount[j]++;
    }
  }

  std::vector<int> xlines;
  std::vector<int> ylines;

  for (cit = xcount.begin() ; cit != xcount.end() ; ++cit)
  {
    if (cit->second < 100) continue;
    xlines.push_back(cit->first);
  }

  for (cit = ycount.begin() ; cit != ycount.end() ; ++cit)
  {
    if (cit->second < 100) continue;
    ylines.push_back(cit->first);
  }

  if (xlines.size() < 5 || ylines.size() < 5)
  {
    std::cout << "file appears to be gridless." << std::endl;
    exit(1);
  }

  std::cout << (xlines.size() - 1) << " " << (ylines.size() - 1) << std::endl;

  for (i = 0 ; i < (int)xlines.size() - 1 ; ++i)
  {
    for (j = 0 ; j < (int)ylines.size() - 1 ; ++j)
    {
      char color;
      int num;
      bool hasNumber = cscan.Scan(color,num,
                                  xlines[i],xlines[i+1],
                                  ylines[j],ylines[j+1]);

      if (!hasNumber) continue;

      std::cout << color << " " << num << " " << i << " " << j << std::endl;
    }
  }
  
  std::cout << "--" << std::endl;

  for (i = 0 ; i < (int)xlines.size() - 1 ; ++i)
  {
    for (j = 0 ; j < (int)ylines.size() - 1 ; ++j)
    {
      // if this isn't the rightmost cell, see if there is a right wall
      if (i != (int)xlines.size() - 2)
      {
        int tx = xlines[i+1];
        int ty = (ylines[j]+ylines[j+1])/2;

        if (bmp.getPixel(tx,ty) != linecol) 
        {
          std::cout << "V " << i << " " << j << std::endl;
        }
      }

      // if this isn't the bottommost cell, see if there is a bottom wall
      if (j != (int)ylines.size() - 2)
      {
        int tx = (xlines[i]+xlines[i+1])/2;
        int ty = ylines[j+1];
        
        if (bmp.getPixel(tx,ty) != linecol) 
        {
          std::cout << "H " << i << " " << j << std::endl;
        }
      }
    }
  }
}
