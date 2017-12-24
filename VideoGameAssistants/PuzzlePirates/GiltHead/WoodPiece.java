import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;

public class WoodPiece
{
  // colors
  public static final int RED = 0;
  public static final int ORANGE = 1;
  public static final int YELLOW = 2;
  public static final int GREEN = 3;
  public static final int CYAN = 4;
  public static final int BLUE = 5;
  public static final int PURPLE = 6;
  public static final int MAGENTA = 7;
  public static final int CEDAR_COLOR = 8;
  public static final int FISH_COLOR = 9;
  // shapes
  public static final int THIN_INNIE = 0;
  public static final int THIN_STRAIGHT = 1;
  public static final int THIN_OUTIE = 2;
  public static final int MEDIUM_INNIE = 3;
  public static final int MEDIUM_STRAIGHT = 4;
  public static final int MEDIUM_OUTIE = 5;
  public static final int THICK_INNIE = 6;
  public static final int THICK_STRAIGHT = 7;
  public static final int THICK_OUTIE = 8;
  public static final int CEDAR_SHAPE = 9;
  public static final int FISH_SHAPE=10;
  public static final int NO_SHAPE = 100;

  private int m_colorvalue;
  private int m_shape;
  private int m_strength;
  private Image m_image;
  private boolean m_isknotted;

  public WoodPiece(int i_colorvalue,int i_shape,int i_strength,boolean i_isknotted,Image i_image)
  {
    m_colorvalue = i_colorvalue;
    m_shape = i_shape;
    m_strength = i_strength;
    m_image = i_image;
    m_isknotted = i_isknotted;
  }

  public int GetStrength()  {    return m_strength;  }
  public int GetShape()  {    return m_shape;  }
  public int GetColor()  {    return m_colorvalue;  }
  public boolean IsKnotted() { return m_isknotted; }

  public void Assign(WoodPiece i_right)
  {
    m_colorvalue = i_right.m_colorvalue;
    m_shape = i_right.m_shape;
    m_strength = i_right.m_strength;
    m_image = i_right.m_image;
    m_isknotted = i_right.m_isknotted;
  }

  public void Draw(Graphics i_g,int i_x,int i_y)
  {
    if (m_image != null)
    {
      i_g.drawImage(m_image,i_x,i_y,null);
    }
  }
}
