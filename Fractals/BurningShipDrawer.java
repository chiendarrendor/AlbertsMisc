import java.awt.Color;

public class BurningShipDrawer extends FractalDrawerBase
{
  public BurningShipDrawer()
  {
    super(new DoubleRectangle(-2.0,-2.0,4.0,4.0));
  }

  private double abs(double d) { return (d < 0) ? -d : d; }

  public Color PixelColor(double x0,double y0)
  {
    int i = 0;
    Complex c = new Complex(x0,y0);
    Complex z = new Complex();

    while(z.getNorm() < 2 && i < 255)
    {
      Complex nz = new Complex(abs(z.getRe()),abs(z.getIm()));
      z = nz.mul(nz).add(c);
      i++;
    }

    return new Color(0xff-i,0xff-i,0xff-i);
  }
}
