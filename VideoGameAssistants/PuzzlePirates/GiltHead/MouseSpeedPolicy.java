
public class MouseSpeedPolicy implements MouseSpeedPolicyInterface
{
  int m_firstDelay;
  int m_secondDelay;
  int m_thirdDelay;
  
  public MouseSpeedPolicy(int i_firstDelay,int i_secondDelay,int i_thirdDelay)
  {
    m_firstDelay = i_firstDelay * 1000;
    m_secondDelay = i_secondDelay * 1000;
    m_thirdDelay = i_thirdDelay * 1000;
  }

  public int getFirstMouseDelay() { return m_firstDelay; }
  public int getSecondMouseDelay() { return m_secondDelay; }
  public int getThirdMouseDelay() { return m_thirdDelay; }
}
  
