import java.awt.Color;

public class MyFractalDrawer extends FractalDrawerBase
{
  public MyFractalDrawer()
  {
    super(new DoubleRectangle(-1.0,-1.0,3.0,2.0));
  }

  public Color PixelColor(double x0,double y0)
  {
    int i = 0;

    Complex c = new Complex(x0,y0);
    Complex z = new Complex();
    Complex one = new Complex(1.0,0);


    while(z.getNorm() < 2 && i < 260)
    {
      Complex nz = one.sub(z);
      z = z.mul(nz).add(c);
      i++;
    }

    if (i > 0xff) return Color.black;
    return new Color(0xff-i,0,0xff);
  }
}
