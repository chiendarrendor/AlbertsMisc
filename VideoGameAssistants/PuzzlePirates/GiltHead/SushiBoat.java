import java.awt.Point;
import java.awt.Graphics;

class SushiBoat
{
  private int Y = GiltHeadConstants.SUSHI_BAR_Y_LOCATION 
    + (GiltHeadConstants.SUSHI_BAR_HEIGHT - GiltHeadConstants.PIECE_HEIGHT)/2;

  private int m_x;
  private int m_y;
  private int m_basey;
  private int m_phase;
  private SushiBoat m_nextBoat;
  private int m_velocity;

  private WoodPiece m_piece;

  public WoodPiece GetWoodPiece() { return m_piece; }


  public void setNextBoat(SushiBoat i_nextBoat)
  {
    m_nextBoat = i_nextBoat;
  }

  public SushiBoat getNextBoat()
  {
    return m_nextBoat;
  }

  public int getX()
  {
    return m_x;
  }

  public SushiBoat(WoodPiece i_piece,int i_velocity)
  {
    m_piece = i_piece;
    m_nextBoat = null;
    m_velocity = i_velocity;
    m_x = 0 - GiltHeadConstants.PIECE_WIDTH;
    m_y = Y;
    m_basey = Y + (MyRand.nextInt(GiltHeadConstants.SUSHI_BAR_HEIGHT_VARIATION)-
                   (GiltHeadConstants.SUSHI_BAR_HEIGHT_VARIATION/2)); 
    m_phase = MyRand.nextInt(GiltHeadConstants.SCREEN_WIDTH); // phase measured in distance to end
  }

  public void UpdateAndDraw(Graphics g,boolean i_holdHorizontal,boolean i_accelerate)
  {
    int dx = 0;

    if (m_nextBoat == null)
    {
      if (m_x + GiltHeadConstants.PIECE_WIDTH < GiltHeadConstants.SCREEN_WIDTH)
      {
        dx = m_velocity * 2;
      }
      else
      {
        dx = m_velocity;
      }
    }
    else
    {
      if (m_nextBoat.getX() - 
          GiltHeadConstants.SUSHI_SEPARATION - 
          GiltHeadConstants.PIECE_WIDTH
           > m_x)
      {
        dx = m_velocity * 2;
      }
      else
      {
        dx = m_velocity;
      }
    }

    if (i_holdHorizontal)
    {
      dx = 0;
    }

    if (i_accelerate)
    {
      dx *=2;
    }

    m_x += dx;

    m_y = m_basey + (int)(GiltHeadConstants.SUSHI_BAR_BOB_AMPLITUDE *
                          Math.sin(
                                   (m_x+m_phase) *
                                   2 *
                                   Math.PI *
                                   GiltHeadConstants.SUSHI_BAR_BOB_FREQUENCY /
                                   GiltHeadConstants.SCREEN_WIDTH
                                   )
                          );

    m_piece.Draw(g,m_x,m_y);
  }

  public boolean isIn(Point p)
  {
    return (p.x >= m_x && p.y >= m_y &&
            p.x < m_x+GiltHeadConstants.PIECE_WIDTH && p.y < m_y+GiltHeadConstants.PIECE_HEIGHT);
  }

}
