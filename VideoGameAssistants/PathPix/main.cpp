#include <cstdlib>
#include <iostream>
#include "bitmap_Image.h"

using namespace std;

int main(int argc, char *argv[])
{
 int w = 640,h=480;
 bitmapImage b(w,h); // create a bitmap with width=640, height=480
 
   // loop through all of its pixels
    for (int x=0;x<w;x++)
      for (int y=0;y<h;y++)
        b.setPixelRGB(x,y,x/3,y/3,x*y/300);
        // give each pixel a colour based on its coordinates
        
    // save the bitmap to a file using a bit depth of 24
    b.saveToBitmapFile("first.bmp",24);
    return 0;
}
