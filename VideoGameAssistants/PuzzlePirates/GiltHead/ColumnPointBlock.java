import java.util.Vector;
import java.awt.Point;

// to be used when one element from each row is a salient.
public class ColumnPointBlock implements BonusScoring.PointBlockGenerator
{
  private Vector< Vector< Point > > m_blocks;

  public ColumnPointBlock()
  {
    m_blocks = new Vector< Vector< Point > > ();
    int i,j;
    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      Vector < Point > vp = new Vector < Point >();
      m_blocks.add(vp);
      
      for (j = 0 ; j < GiltHeadConstants.BLUEPRINT_MAX_HEIGHT ; ++j)
      {
        vp.add(new Point(i,j));
      }
    }
  }

  public Vector<Vector<Point> > GetPointBlocks()
  {
    return m_blocks;
  }
}
