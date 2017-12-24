import java.util.Vector;
import java.awt.Point;


public class DownRightPointBlock implements BonusScoring.PointBlockGenerator
{
  private Vector< Vector< Point > > m_downrightroyal;
  public DownRightPointBlock()
  {
    m_downrightroyal = new Vector<Vector<Point> >();
    int i;
    for (i = 0 ; i < 9 ; ++i)
    {
      m_downrightroyal.add(new Vector<Point>());
    }

    m_downrightroyal.get(0).add(new Point(0,5));
    m_downrightroyal.get(1).add(new Point(1,5));
    m_downrightroyal.get(1).add(new Point(0,4));
    m_downrightroyal.get(2).add(new Point(2,5));
    m_downrightroyal.get(2).add(new Point(1,4));
    m_downrightroyal.get(2).add(new Point(0,3));
    m_downrightroyal.get(3).add(new Point(3,5));
    m_downrightroyal.get(3).add(new Point(2,4));
    m_downrightroyal.get(3).add(new Point(1,3));
    m_downrightroyal.get(3).add(new Point(0,2));
    m_downrightroyal.get(4).add(new Point(3,4));
    m_downrightroyal.get(4).add(new Point(2,3));
    m_downrightroyal.get(4).add(new Point(1,2));
    m_downrightroyal.get(4).add(new Point(0,1));
    m_downrightroyal.get(5).add(new Point(3,3));
    m_downrightroyal.get(5).add(new Point(2,2));
    m_downrightroyal.get(5).add(new Point(1,1));
    m_downrightroyal.get(5).add(new Point(0,0));
    m_downrightroyal.get(6).add(new Point(3,2));
    m_downrightroyal.get(6).add(new Point(2,1));
    m_downrightroyal.get(6).add(new Point(1,0));
    m_downrightroyal.get(7).add(new Point(3,1));
    m_downrightroyal.get(7).add(new Point(2,0));
    m_downrightroyal.get(8).add(new Point(3,0));
  }

  public Vector<Vector<Point> > GetPointBlocks()
  {
    return m_downrightroyal;
  }
}
