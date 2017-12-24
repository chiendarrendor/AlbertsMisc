#include <iostream>
#include <fstream>
#include "bitmap_Image.h"

using namespace std;

bitmapImage::bitmapImage()
{
   pixelData = NULL;                             
   setSize(0,0);                          
}

bitmapImage::bitmapImage(const char* filename)
{
   pixelData = NULL;   
   loadFromBitmapFile(filename);                            
}

bitmapImage::bitmapImage(int width,int height)
{
   pixelData = NULL;                             
   setSize(width,height);                 
}

bitmapImage::~bitmapImage()
{
  freePixelData();                           
}

void bitmapImage::freePixelData()
{
   if (pixelData==NULL) // if already freed
      return;
      
   for (int x=0;x<width;x++)
   {
       delete pixelData[x];   
   }
   
   width = 0;
   height = 0;
   delete pixelData;
   pixelData = NULL;     
}

void bitmapImage::setSize(int width,int height)
{
   if (pixelData!=NULL)
      freePixelData();
      
   if (width==0 || height==0)
   {
      return;             
   }     
   this->width = width;
   this->height = height;
   pixelData = new int*[width];
   for (int x=0;x<width;x++)
   {
       pixelData[x]=new int[height];
   }
}

int bitmapImage::getWidth() const
{
    return width;
}

int bitmapImage::getHeight() const
{
    return height;
}

int bitmapImage::getPixel(int x,int y) const
{
   if ((x<0) || (x>=width) || (y<0) || (y>=height))
      return 0;
   else
      return pixelData[x][y];
}

void bitmapImage::setPixel(int x,int y,int colour)
{
   if ((x>=0) && (x<width) && (y>=0) && (y<height))
      pixelData[x][y] = colour;
}

int bitmapImage::loadFromBitmapFile(const char*filename)
{
  std::ifstream in_file;
  char buffer[100];  
  int fileSize;
  int sizeOfHeader;
  int bytesofPixelData;
  int height,width;
  int bitDepth=0;
  int compressionMethod=0;
  
   in_file.open(filename,ios::binary|ios::in);

   in_file.read(buffer,2);
    if (buffer[0]!='B' || buffer[1]!='M')
    {
       perror("Invalid Bitmap File Format");                       
       return 1;                   
    }
   in_file.read((char*)&fileSize,sizeof(int));
   in_file.read(buffer,4);
   in_file.read((char*)&sizeOfHeader,sizeof(int));
   in_file.read(buffer,4);
   in_file.read((char*)&width,4);
   in_file.read((char*)&height,4);
   in_file.read(buffer,2); 

   in_file.read((char*)&bitDepth,2);
   if (bitDepth!=24 && bitDepth!=32 && bitDepth!=16)
   {
      cout << "problem with unsupported bit depth: "<<bitDepth<<"\n";    
      return 3;             
   }
   
   in_file.read((char*)&compressionMethod,4);// compression number  
   if (compressionMethod!=0)
   {
      cout << "Unsupported compression method: "<<compressionMethod<<"\n";    
      return 2;                                         
   }
     
   in_file.read((char*)&bytesofPixelData,sizeof(int));
   if (bytesofPixelData+sizeOfHeader!=fileSize)
   {
      cout << "bitmap block size inconsistant\n";
      return 4;                                            
   }
   
   // read the rest of the header
   in_file.read(buffer,sizeOfHeader-38);
   
   setSize(width,height);
   /* 
   the number of bytes in a scanline must be a multiple of 4 so a padding is used to fill the gap 
   */
   int padding=(width*bitDepth/8)%4;
   if (padding!=0)
      padding = 4-padding; 
    
  // loop through rows of pixels
  for (int y=height-1;y>=0;y--)
  {
      for (int x=0;x<width;x++)
      {
          int * p = &(pixelData[x][y]);
           (*p)=0;
          if (bitDepth==32)
          {
            // read each directly from the file     
            in_file.read((char*)p,4);
          }
          else if (bitDepth==24)
          {
            // read each directly from the file     
            in_file.read((char*)p,3);              
          }
          else if (bitDepth==16)
          {
               int encodedColour=0;
            // 5 bits per RGB value needs to be expanded to full 8 bits  
            in_file.read((char*)&encodedColour,2);
             encodedColour = 
               ((encodedColour&0x1f)<<3) // blue
               |((encodedColour&0x3e0)<<6) // green
               |((encodedColour&0x7c00)<<9) // red
              ;
              (*p) = encodedColour;
          }
      }
      if (y==0) break;
      
      if (padding!=0)
         in_file.read(buffer,padding);
  }

   in_file.close();
   return 0;      
}

void bitmapImage::saveToBitmapFile(const char* filename) const
{
    saveToBitmapFile(filename,24); 
}

void bitmapImage::saveToBitmapFile(const char* filename,int bitDepth) const
{
  if (bitDepth!=16 && bitDepth!=24 && bitDepth!=32)
  {
     cout << "Unsupported bit depth: "<<bitDepth<<" must be 16,24 or 32.\n";                    
     cout << "bit depth assumed to be 24 for save to continue.\n";
     bitDepth = 24;                    
  }
  std::ofstream out_file;
  char paddingBuffer[4]={0,0,0,0};
  char headerData1[12]={0x00 ,0x00 ,0x00 ,0x00 ,0x36 ,0x00 ,0x00 
  ,0x00 ,0x28 ,0x00 ,0x00 ,0x00};
  char headerData2[2]={0x01,0x00};
  int compressionMethod = 0; // uncompressed
  
  int fileSize = 54+width*height*bitDepth/8;
  int bytesofPixelData = width*height*bitDepth/8;
  
   out_file.open(filename,ios::binary|ios::out);
  
  out_file.write("BM",2);
  // write some other bytes of data to the file

  out_file.write((char*)&fileSize,sizeof(int));
  
  out_file.write(headerData1,sizeof(headerData1)); 

  out_file.write((char*)&width,sizeof(int));
  out_file.write((char*)&height,sizeof(int));

  out_file.write(headerData2,sizeof(headerData2)); 
  out_file.write((char*)&bitDepth,sizeof(int)); 
  out_file.write((char*)&compressionMethod,2);    
  out_file.write((char*)&bytesofPixelData,sizeof(int));
  
  char c = '\0';  
  for (int i=0;i<16;i++)
      out_file.write(&c,sizeof(char));
      
    // each scanline or row of pixels must be a multiple of 4 bytes so a padding is used
   int padding=(width*bitDepth/8)%4;
   if (padding!=0)
      padding = 4-padding; 

    
  // loop through rows of pixels
  for (int y=height-1;y>=0;y--)
  {
      for (int x=0;x<width;x++)
      {
        int encodedPixel =  pixelData[x][y];
         if (bitDepth==32)
           // write each directly to the file     
           out_file.write((char*)&encodedPixel,4);         
         else if (bitDepth==24)
           // write each directly to the file     
           out_file.write((char*)&encodedPixel,3);
         else if (bitDepth==16)
         {
            encodedPixel = ((encodedPixel&0xf80000)>>9) // red
               | ((encodedPixel&0xf800)>>6) // green
               | ((encodedPixel&0xf8) >> 3);  // blue
           out_file.write((char*)&encodedPixel,2);
         }              
      }
      if (y==0)
         break;
         
      if (padding!=0) 
         out_file.write(paddingBuffer,padding);
         // doesn't matter what the values are so question marks are fine
  }

   out_file.close(); 
}

void bitmapImage::fillWith(int colour)
{
  for (int y=0;y<height;y++)
     for (int x=0;x<width;x++)
     {
        setPixel(x,y,colour);    
     }     
}

void bitmapImage::fillRect(int left,int top,int width,int height,int colour)
{
  if (width+left>this->width)   
     width = this->width-left;
     
  if (height+top>this->height)   
     height = this->height-top;
     
  for (int y=top+height;y>top;y--)  
   for (int x=left+width;x>left;x--)  
     setPixel(x,y,colour);
}

int bitmapImage::getRed(int colour) const
{
    return ((colour>>16) & 255);
}

int bitmapImage::getGreen(int colour) const
{
    return ((colour>>8) & 255);
}

int bitmapImage::getBlue(int colour) const
{
    return (colour & 255);
}

int bitmapImage::getColourForRGB(int red,int green,int blue) const
{
    if (red>255)
       red = 255;
    else if (red<0)
       red = 0;
       
    if (green>255)
       green = 255;
    else if (green<0)
       green = 0;
       
    if (blue>255)
       blue = 255;
    else if (blue<0)
       blue= 0;
       
   return ((red << 16) | (green << 8) | (blue));    
}

void bitmapImage::setPixelRGB(int x,int y,int red,int green,int blue)
{
   setPixel(x,y,getColourForRGB(red,green,blue));     
}


