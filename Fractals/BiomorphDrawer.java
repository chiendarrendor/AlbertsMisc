import java.awt.Color;

public class BiomorphDrawer extends FractalDrawerBase
{
  public BiomorphDrawer()
  {
    super(new DoubleRectangle(-10.0,-10.0,20.0,20.0));
  }

  private double abs(double d) { return (d < 0) ? -d : d; }

  public Color PixelColor(double x0,double y0)
  {
    Complex z = new Complex(x0,y0);
    Complex c = new Complex(0.5,0);
    int i;

    for (i = 0 ; i < 10 ; ++i)
    {
      z = z.mul(z).mul(z).mul(z).mul(z).add(c);
      if (abs(z.getRe()) > 10) break;
      if (abs(z.getIm()) > 10) break;
      if (z.getNorm() > 10) break;
    }

    if (abs(z.getRe()) < 10 ||
        abs(z.getIm()) < 10) return Color.black;
    return Color.white;
  }
}
