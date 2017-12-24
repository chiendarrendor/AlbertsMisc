class BasicGameStartPolicy implements GameStartPolicyInterface
{
  GameStartInfo m_gsi;

  public BasicGameStartPolicy(int i_weight,int i_height)
  {
    m_gsi = new GameStartInfo();
    m_gsi.weightClass = i_weight;
    m_gsi.legHeight = i_height;
  }

  public GameStartInfo GetGameStart()
  {
    return m_gsi;
  }
}
