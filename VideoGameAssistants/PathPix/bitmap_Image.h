#ifndef BITMAP_IMAGE_HEADER_FILE
#define BITMAP_IMAGE_HEADER_FILE

class bitmapImage;

/**
A class for working with the Windows Bitmap File Format.
This supports bit depths of 16, 24, and 32 with uncompressed pixel data.

This does not support compressed bitmaps or bit depths of 1,4, or 8.  
 Compression is rarely used with this file format, though.
*/
class bitmapImage
{
   private:
     int width,height;
     int **pixelData;
     void freePixelData();
     
   public:
     bitmapImage();
     bitmapImage(const char* filename);
     bitmapImage(int w,int h);
     virtual ~bitmapImage();
     void setSize(int width,int height);
     
     /** loads uncompressed bitmaps with colour depths of 16,24, and 32 
     returns 0, if successfully loaded.
     */
     int loadFromBitmapFile(const char*filename);

     /** saves bitmaps using 24 bit colour depth */
     void saveToBitmapFile(const char* filename) const;
     
     /** saves using the specified depth of 16, 24, or 32 */
     void saveToBitmapFile(const char* filename,int bitDepth) const;
     int getHeight() const;
     int getWidth() const;
     int getRed(int colour) const;
     int getGreen(int colour) const;
     int getBlue(int colour) const;
     int getColourForRGB(int red,int green,int blue) const; 
     int getPixel(int x,int y) const;
     void setPixel(int x,int y,int colour);   
     void fillWith(int colour); 
     void fillRect(int left,int top,int width,int height,int colour);      
     void setPixelRGB(int x,int y,int red,int green,int blue);
};

#endif
