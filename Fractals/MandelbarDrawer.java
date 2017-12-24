import java.awt.Color;

public class MandelbarDrawer extends FractalDrawerBase
{
  public MandelbarDrawer()
  {
    super(new DoubleRectangle(-2.0,-2.0,4.0,4.0));
  }

  public Color PixelColor(double x0,double y0)
  {
    int i = 0;

    Complex c = new Complex(x0,y0);
    Complex z = new Complex();


    while(z.getNorm() < 2 && i < 254)
    {
      Complex nz = z.getConjugate();
      z = nz.mul(nz).add(c);
      i++;
    }

    return new Color(i,i,i);
  }
}
