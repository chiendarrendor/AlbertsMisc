import java.util.Vector;

public class WeightedRandom
{
  private class WeightInfo
  {
    public int m_Value;
    public int m_Parts;
    public int m_CumulativeParts;
  }
  
  private Vector<WeightInfo> m_Weights;

  public WeightedRandom()
  {
    m_Weights = new Vector<WeightInfo>();
  }

  public void AddWeight(int i_Value,int i_Parts)
  {
    WeightInfo wi = new WeightInfo();
    wi.m_Value = i_Value;
    wi.m_Parts = i_Parts;
    
    if (m_Weights.size() == 0)
    {
      wi.m_CumulativeParts = i_Parts;
    }
    else
    {
      wi.m_CumulativeParts = m_Weights.lastElement().m_CumulativeParts + i_Parts;
    }

    m_Weights.add(wi);
  }

  public int getRandom()
  {
    int dr = MyRand.nextInt(m_Weights.lastElement().m_CumulativeParts) + 1;
    int i;
    
    for (i = 0 ; i < m_Weights.size() ; ++i)
    {
      if (dr <= m_Weights.get(i).m_CumulativeParts)
      {
        return m_Weights.get(i).m_Value;
      }
    }
    throw new RuntimeException("Failure in WeightedRandom getRandom()");
  }
}


