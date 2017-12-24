import java.awt.*;

public abstract class FractalDrawerBase 
{
  DoubleRectangle _drawarea;

  public FractalDrawerBase(DoubleRectangle drawarea)
  {
    _drawarea = drawarea;
  }

  // given a Rectangle inside the Dimension, and the current 
  // draw area (which is the drawing area of said rectangle)
  // calculate the new drawing area (the part of draw area that
  // is bounding)

  public void ReBound(Dimension sSize, Rectangle bounding)
  {
    double w = (double)sSize.width;
    double h = (double)sSize.height;
    DoubleRectangle dBounding = new DoubleRectangle(bounding);

    DoubleRectangle result = 
      new DoubleRectangle(
                          _drawarea.x + dBounding.x / w * _drawarea.width,
                          _drawarea.y + dBounding.y / h * _drawarea.height,
                          dBounding.width / w * _drawarea.width,
                          dBounding.height / h * _drawarea.height);
    _drawarea = result;
  }

  abstract public Color PixelColor(double x,double y);

  public void Draw(Dimension screenDim,Graphics g)
  {
    int i,j;
    double x,y;

    for (i = 0 ; i < screenDim.width ; ++i)
    {
      // i = 0 -> _drawarea.width
      // i = screenDim.width -> _drawarea.x + _drawarea.width
      x = _drawarea.x + i * ((double)_drawarea.width/(double)screenDim.width);
      for (j = 0 ; j < screenDim.height ; ++j)
      {
        y = _drawarea.y + j * ((double)_drawarea.height/(double)screenDim.height);
        Color c = PixelColor(x,y);
        g.setColor(c);
        g.fillRect(i,j,1,1);
      }
    }
  }
}
