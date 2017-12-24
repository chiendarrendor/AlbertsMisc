import java.util.Vector;

public class BasicGameEndPolicy implements GameEndPolicyInterface
{
  private static String[] gWords = {"Booched :-(","Poor","Fine",
                                    "Good!","Excellent!!","Incredible!!!"};

  public ScoringDescriptor scoreEndGame(Vector<Double> i_boardscores)
  {
    int i;
    double sum = 0;
    for (i = 0 ; i < i_boardscores.size() ; ++i)
    {
      sum += i_boardscores.get(i).doubleValue();
    }
    
    double avg = sum / i_boardscores.size();

    ScoringDescriptor sd = new ScoringDescriptor();
    sd.m_type = 0;
    sd.m_String = gWords[getGrade(avg)];
    sd.m_isFinal = true;
    sd.m_pauseSeconds = 1;
    return sd;
  }

  public int getGrade(double i_score)
  {
    if (i_score == 0.0) return BOOCHED;
    if (i_score < 133.92) return POOR;
    if (i_score < 263.52) return FINE;
    if (i_score < 730.08) return GOOD;
    if (i_score < 2596.32) return EXCELLENT; 
    return INCREDIBLE;
  }
}
