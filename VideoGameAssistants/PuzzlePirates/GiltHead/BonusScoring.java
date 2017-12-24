import java.util.Vector;
import java.awt.Point;




public class BonusScoring
{
  public interface PointBlockGenerator
  {
    public Vector<Vector<Point> > GetPointBlocks();
  }

  public interface SalientRetriever
  {
    public int GetSalient(WoodPiece i_woodpiece);
  }

  public interface SalientProcessor
  {
    public double ProcessSalients(Vector<Integer> i_salients,Vector<ScoringDescriptor> i_sdescriptor);
  }

  PointBlockGenerator m_pbg;
  SalientRetriever m_sr;
  SalientProcessor m_sp;
  private boolean m_exact;
  
  BonusScoring(PointBlockGenerator i_pbg,SalientRetriever i_sr,SalientProcessor i_sp,boolean i_exact)
  {
    m_pbg = i_pbg;
    m_sr = i_sr;
    m_sp = i_sp;
    m_exact = i_exact;
  }

  double Score(BlueprintGrid i_blueprint,
               int i_ActualHeight,
               Vector<ScoringDescriptor> i_sdescriptor)
  {
    Vector<Vector<Point> > pointblocks = m_pbg.GetPointBlocks();
    Vector<Integer> salients = new Vector<Integer>();

    // 1. make sure that all of the salients in each pointblock match
    //    if m_exact is true, they must match
    //    if m_exact is false, there must be at least two matching, the rest can be gilthead.
    //    regardless, empty spaces and iron fish are non-matching.
    int i,j;

    for (i = 0 ; i < pointblocks.size() ; ++i)
    {
      Vector<Point> pointblock = pointblocks.get(i);
      int gcount = 0;
      int salient = -1;
      System.out.println("Point Block " + i);
      
      for (j = 0 ; j < pointblock.size() ; ++j)
      {
        Point p = pointblock.get(j);
        System.out.println(" Point " + p);
        WoodPiece wp = i_blueprint.GetPiece(p.x,p.y);
        if (wp == null) 
        {
          System.out.println("No Piece there.");
          return 0.0;
        }
        if (wp.GetColor() == WoodPiece.FISH_COLOR)
        {
          System.out.println("Fish there.");
          return 0.0;
        }

        if (wp.GetColor() == WoodPiece.CEDAR_COLOR && m_exact) 
        {
          System.out.println("Cedar when looking for exact match");
          return 0.0;
        }
        if (wp.GetColor() == WoodPiece.CEDAR_COLOR) 
        {
          System.out.println("cedar when not looking for exact match");
          gcount++;
          continue;
        }

        // if we get here, it's a normal piece.
        int cursalient = m_sr.GetSalient(wp);
        System.out.println("Salient is: " + cursalient);
        if (salient == -1)
        {
          System.out.println("New Salient.");
          salient = cursalient;
        }
        else if (salient != cursalient) 
        {
          System.out.println("Nonmatching salient.");
          return 0.0;
        }
        else
        {
          System.out.println("Matching Salient.");
        }
      }

      if (salient == -1) 
      {
        System.out.println("No Salient found for this pointblock");
        return 0.0;
      }

      if (pointblock.size() > 1)
      {
        System.out.println("pointblock of size at least 2");
        if (pointblock.size() - gcount < 2) 
        {
          System.out.println("too many cedars in pointblock");
          return 0.0;
        }
        else
        {
          System.out.println("enough real pieces in pointblock");
        }
      }

      salients.add(new Integer(salient));
    }

    // now we have a list of the salients.  Ask the Salient Processor what to do.
    return m_sp.ProcessSalients(salients,i_sdescriptor);
  }
}


          
    

  
