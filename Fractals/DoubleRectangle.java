import java.awt.Rectangle;

public class DoubleRectangle
{
  public double x;
  public double y;
  public double width;
  public double height;

  public DoubleRectangle(double mx,double my,double mw,double mh)
  {
    x = mx;
    y = my;
    width = mw;
    height = mh;
  }

  public DoubleRectangle(Rectangle r)
  {
    x = (double)r.x;
    y = (double)r.y;
    width = (double)r.width;
    height = (double)r.height;
  }
}
