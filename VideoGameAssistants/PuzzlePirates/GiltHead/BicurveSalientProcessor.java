import java.util.Vector;
import java.awt.Point;


public class BicurveSalientProcessor implements BonusScoring.SalientProcessor
{
  String m_simplename;
  double m_simplescore;
  String m_perfectname;
  double m_perfectscore;
  boolean m_isInward;

  public BicurveSalientProcessor(String i_simplename,double i_simplescore,
                                 String i_perfectname,double i_perfectscore,
                                 boolean i_isInward)
  {
    m_simplename = i_simplename;
    m_simplescore = i_simplescore;
    m_perfectname = i_perfectname;
    m_perfectscore = i_perfectscore;
    m_isInward = i_isInward;
  }

  private boolean IsInward(int i_0,int i_1,int i_2)
  {
    // all the same is not inward.
    if (i_0 == i_1 && i_1 == i_2) return false;
    // if any of them go outward, is bad.
    if (i_0 < i_1 || i_1 < i_2) return false;
    return true;
  }


  public double ProcessSalients(Vector<Integer> i_salients,Vector<ScoringDescriptor> i_sdescriptor)
  {

    int s0 = i_salients.get(0).intValue();
    int s1 = i_salients.get(1).intValue();
    int s2 = i_salients.get(2).intValue();
    int s3 = i_salients.get(3).intValue();
    int s4 = i_salients.get(4).intValue();
    int s5 = i_salients.get(5).intValue();

    // make sure that shapes for 2 and 3 are identical
    if (s2 != s3) return 0.0;

    if (m_isInward)
    {
      if (!IsInward(s0,s1,s2) || !IsInward(s5,s4,s3))
      {
        return 0.0;
      }
    }
    else
    {
      if (!IsInward(s2,s1,s0) || !IsInward(s3,s4,s5))
      {
        return 0.0;
      }
    }

    // it is perfect if it is top-bottom symmetrical and consists of 3 different pieces.
    boolean perfect = ((s1 == s4) && (s0 == s5) && (s0 != s1) && (s1 != s2));

    if (perfect)
    {
      i_sdescriptor.add(BasicScoringPolicy.makeScore(m_perfectname,0,0));
      return m_perfectscore;
    }

    i_sdescriptor.add(BasicScoringPolicy.makeScore(m_simplename,0,0));
    return m_simplescore;
  }
}
