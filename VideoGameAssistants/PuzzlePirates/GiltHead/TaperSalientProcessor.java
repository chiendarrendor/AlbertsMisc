import java.util.Vector;
import java.lang.Integer;

public class TaperSalientProcessor implements BonusScoring.SalientProcessor
{
  private String m_basicstring;
  private double m_basicscore;
  private String m_perfectstring;
  private double m_perfectscore;
  private boolean m_incrementing;

  public TaperSalientProcessor(String i_basicstring,double i_basicscore,
                               String i_perfectstring,double i_perfectscore,
                               boolean i_incrementing)
  {
    m_basicstring = i_basicstring;
    m_basicscore = i_basicscore;
    m_perfectstring = i_perfectstring;
    m_perfectscore = i_perfectscore;
    m_incrementing = i_incrementing;
  }


  public double ProcessSalients(Vector<Integer> i_salients,Vector<ScoringDescriptor> i_sdescriptor)
  {
    boolean monotonic = true;
    boolean perfect = true;
    int numchanges = 0;
    double score;

    int i;

    for (i = 0 ; i < i_salients.size() - 1 ; ++i)
    {
      int sb = i_salients.get(i).intValue();
      int st = i_salients.get(i+1).intValue();

      if (sb != st) numchanges++;
      if (m_incrementing && sb > st) monotonic = false;
      if (!m_incrementing && sb < st) monotonic = false;
      if (m_incrementing && sb+1 != st) perfect = false;
      if (!m_incrementing && sb != st+1) perfect = false;
    }

    if (monotonic && perfect && numchanges == i_salients.size() - 1)
    {
      i_sdescriptor.add(BasicScoringPolicy.makeScore(m_perfectstring,0,0));
      score = m_perfectscore;
    }
    else if (monotonic && numchanges > 1)
    {
      i_sdescriptor.add(BasicScoringPolicy.makeScore(m_basicstring,0,0));
      score = m_basicscore;
    }
    else
    {
      score = 0.0;
    }

    return score;
  }
}

