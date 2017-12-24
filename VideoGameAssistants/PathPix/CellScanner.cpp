
#include "CellScanner.hpp"
#include "bitmap_Image.h"
#include <iostream>
#include <set>

CellScanner::CellScanner(const bitmapImage &i_bmi) :
  m_ColorChars(),
  m_bmi(i_bmi)
{
  m_ColorChars[11796480] = 'R';
  m_ColorChars[0] = 'K';
  m_ColorChars[16750848] = 'O';
  m_ColorChars[16763904] = 'y';
  m_ColorChars[16776960] = 'Y';
  m_ColorChars[16737945] = 'P';

  m_ColorChars[6266815] = 'C';
  m_ColorChars[16711680] = 'R';
  
  m_ColorChars[13342872] = 'S';
  m_ColorChars[8421504] = 'G';
  m_ColorChars[8421568] = 'B';

  m_ColorChars[10263552] = 'L';

}

bool CellScanner::Scan(char &o_color,int &o_num,
                   int lx,int rx,
                   int ty,int by,bool i_debug) const
{

  // step 1.  inset enough to avoid potential walls (which are three pixels across
  //          centered on the wall)
  lx += 2;
  rx -= 2;
  ty += 2;
  by -= 2;

  // step 2.  find background color... lx,ty should be background, regardless
  int bcolor = m_bmi.getPixel(lx,ty);

  // step 3, find coordinates of edges of box, if there is any.
  int blx,brx,bty,bby;

  for (blx = lx ; blx <= rx ; ++blx)
  {
    if (m_bmi.getPixel(blx,(ty+by)/2) != bcolor) break;
  }
  if (blx > rx) return false;

  for (brx = rx ; brx >= lx ; --brx)
  {
    if (m_bmi.getPixel(brx,(ty+by)/2) != bcolor) break;
  }

  for (bty = ty ; bty <= by ; ++bty)
  {
    if (m_bmi.getPixel((lx+rx)/2,bty) != bcolor) break;
  }

  for (bby = by ; bby >= ty ; --bby)
  {
    if (m_bmi.getPixel((lx+rx)/2,bby) != bcolor) break;
  }

  // if we get here, we have the coordinates of the box.
  // step 4...find primary color
  int pcolor = m_bmi.getPixel(blx,bty);

  std::map<int,char>::const_iterator colit = m_ColorChars.find(pcolor);
  if (colit == m_ColorChars.end())
  {
    std::cout << "Can't find char for color: " << pcolor << "(" << 
      m_bmi.getRed(pcolor) << "," <<
      m_bmi.getGreen(pcolor) << "," <<
      m_bmi.getBlue(pcolor) << ")" << std::endl;
    exit(1);
  }

  o_color = colit->second;

  // determine horizontal extent of character(s)
  //
  int i,j;
  int cl1 = -1;
  int cr1 = -1;
  int cl2 = -1;
  int cr2 = -1;
  for (i = blx ; i <= brx ; ++i)
  {
    bool empty = true;
    for (j = bty ; j <= bby ; ++j)
    {
      if (m_bmi.getPixel(i,j) != pcolor) 
      {
        empty = false;
        break;
      }
    }
    
    if (cl1 == -1 && empty == true) { continue; }
    if (cl1 == -1 && empty == false) { cl1 = i;  continue; }
    // if we get here, cl1 is not -1
    if (cr1 == -1 && empty == true) { cr1 = i-1 ; continue; }
    if (cr1 == -1 && empty == false) { continue ; }
    // if we get here cr1 is not -1
    if (cl2 == -1 && empty == true) { continue; }
    if (cl2 == -1 && empty == false) { cl2 = i ; continue; }
    // if we get here cl2 is not -1
    if (cr2 == -1 && empty == true) { cr2 = i-1 ; continue; }
    if (empty == false) { continue; }
  }

  o_num = identifyCharacter(cl1,cr1,bty,bby,pcolor,i_debug);
  if (cl2 != -1)
  {
    o_num *= 10;
    o_num += identifyCharacter(cl2,cr2,bty,bby,pcolor,i_debug);
  }

  return true;
}

// given a character in the bounding box (lx and rx are tight bounds,
// ty and by will not be tight) determine what decimal digit it represents
int CellScanner::identifyCharacter(int lx,int rx,int ty,int by,int pcolor,bool i_debug) const
{

  // scan across each horizontal of the character to determine:
  // first used horizontal
  // last used horizontal
  // location of full-width horizontal, if any
  // number of unique right-most pixel
  // locations of left and right 'deep insets' (at least 50% of width of character)
  // locations of 'loops' (on-off-on) specifically:
  //   only high
  //   only low
  //   broken high/low
  //   whole length of character

  int firsthorizontal = -1;
  int lasthorizontal = -1;
  int i,j;

  if (i_debug)
  {
    bitmapImage debugimage;
    debugimage.setSize(rx-lx+1,by-ty+1);
    for (i = ty ; i <= by ; ++i)
    {
      for (j = lx ; j <= rx ; ++j)
      {
        int c = m_bmi.getPixel(j,i);
        debugimage.setPixel(j-lx,i-ty,(c == pcolor) ? pcolor : 0);
      }
    }
    debugimage.saveToBitmapFile("character.bmp");
  }
          
    

  for (i = ty ; i <= by ; ++i)
  {
    for (j = lx ; j <= rx ; ++j)
    {
      int c = m_bmi.getPixel(j,i);
      if (firsthorizontal == -1 && c != pcolor) firsthorizontal = i;
      if (c != pcolor) lasthorizontal = i;
    }
  }

  bool topfull = false;
  bool bottomfull = false;

  std::map<int,int> rightmosts;
  int insetdepth = 5 * (rx - lx) / 10;
  int centerheight = (firsthorizontal + lasthorizontal) / 2;
  bool hashighleftinset = false;
  bool haslowleftinset = false;
  bool hashighrightinset = false;

  int splitchangecount = 0;
  bool lastsplitstate = false;


  for (i = firsthorizontal ; i <= lasthorizontal ; ++i)
  {
    bool isfullwidth = true;
    int lastpixel = -1;
    int ecounter = 0;
    int prevcolor = 0; // 0 if back color (pcolor), 1 otherwise
    int firstpixel = -1;

    for (j = lx ; j <= rx ; ++j)
    {
      int c = m_bmi.getPixel(j,i);

      if (c != pcolor && firstpixel == -1)
      {
        firstpixel = (j-lx);
      }

      if (c == pcolor) 
      {
        isfullwidth = false;
      }

      if (c != pcolor) lastpixel = j;

      if ((prevcolor == 0 && c != pcolor) ||
          (prevcolor == 1 && c == pcolor))
      {
        ecounter++;
        prevcolor = (c!=pcolor);
      }

    }

    if (firstpixel >= insetdepth)
    {
      if (i < centerheight) hashighleftinset = true;
      if (i > centerheight) haslowleftinset = true;
    }

    if (prevcolor == 1) ecounter++;
    if (ecounter == 4)
    {
      if (lastsplitstate == false)
      {
        lastsplitstate = true;
        splitchangecount++;
      }
    }
    else
    {
      if (lastsplitstate == true)
      {
        lastsplitstate = false;
        splitchangecount++;
      }
    }

    if (i == firsthorizontal && isfullwidth == true) topfull = true;
    if (i == lasthorizontal && isfullwidth == true) bottomfull = true;

    if (lastpixel != -1) rightmosts[lastpixel]++;

    if ((rx-lastpixel) >= insetdepth)
    {
      if (i < centerheight)
      {
        hashighrightinset = true;
      }
    }
  }
 

  // ---- 1
  if (rightmosts.size() == 1) return 1;

  if (rightmosts.size() == 2)
  {
    // make sure that the most common case is the lefter of the two
    std::map<int,int>::iterator fit = rightmosts.begin();
    std::map<int,int>::iterator sit = rightmosts.begin();
    ++sit;
    // ---- 4
    if (fit->second > sit->second) return 4;
  }

  // ---- 7
  if (topfull) return 7;
  // ---- 2
  if (bottomfull) return 2;

  // ---- 3
  if (hashighleftinset && haslowleftinset) return 3;

  // ---- 5
  if (hashighrightinset && haslowleftinset) return 5;

  // ---- 6
  if (hashighrightinset) return 6;

  // ---- 9
  if (haslowleftinset) return 9;


  // ---- 0
  if (splitchangecount == 2) return 0;
  // ---- 8
  if (splitchangecount == 4) return 8;

  std::cout << "still undetermined." << std::endl;

  return 0;
}
      

  
