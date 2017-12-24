import java.awt.Color;

class Utilities
{
  static public Color interpolateColor(Color c1,Color c2,int pct)
  {
    double dp = (double)pct;
    int red = (int)(c1.getRed() * (100.0 - dp)/100.0 + c2.getRed() * dp / 100.0);
    int green = (int)(c1.getGreen() * (100.0 - dp)/100.0 + c2.getGreen() * dp / 100.0);
    int blue = (int)(c1.getBlue() * (100.0 - dp)/100.0 + c2.getBlue() * dp / 100.0);

    if (red < 0) red = 0;
    if (red > 255) red = 255;
    if (green < 0) green = 0;
    if (green > 255) green = 255;
    if (blue < 0) blue = 0;
    if (blue > 255) blue = 255;
    return new Color(red,green,blue);
  }
}
