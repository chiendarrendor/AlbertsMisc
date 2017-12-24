import java.util.Vector;
import java.lang.Integer;

public class RainbowSalientProcessor implements BonusScoring.SalientProcessor
{
  String m_ScoreName;
  double m_Score;

  RainbowSalientProcessor(String i_ScoreName,double i_Score)
  {
    m_ScoreName = i_ScoreName;
    m_Score = i_Score;
  }

  private int IColor(int i_color)
  {
    if (i_color == WoodPiece.MAGENTA) return WoodPiece.RED;
    return i_color + 1;
  }

  private int DColor(int i_color)
  {
    if (i_color == WoodPiece.RED) return WoodPiece.MAGENTA;
    return i_color - 1;
  }


  public double ProcessSalients(Vector<Integer> i_salients,Vector<ScoringDescriptor> i_sdescriptor)
  {
    int i;
    System.out.println("Salients: ");
    for (i = 0 ; i < i_salients.size() ; ++i)
    {
      System.out.println("  " + i_salients.get(i));
    }

    boolean isinc;
    if (IColor(i_salients.get(0).intValue()) == i_salients.get(1).intValue()) isinc = true;
    else if (DColor(i_salients.get(0).intValue()) == i_salients.get(1).intValue()) isinc = false;
    else return 0.0;

    for (i = 1 ; i < i_salients.size() - 1; ++i)
    {
      int i1 = i_salients.get(i).intValue();
      int i2 = i_salients.get(i+1).intValue();
      if (isinc)
      {
        if (IColor(i1) != i2) return 0.0;
      }
      else
      {
        if (DColor(i1) != i2) return 0.0;
      }
    }
    i_sdescriptor.add(BasicScoringPolicy.makeScore(m_ScoreName,0,0));
    return m_Score;
  }
}


