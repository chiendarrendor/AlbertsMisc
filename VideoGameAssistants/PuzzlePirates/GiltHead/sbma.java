
private class SushiBarMouseAdapter extends MouseAdapter
{
  public void mousePressed(MouseEvent e)
  {
    synchronized(m_boats)
    {
      int i;
      for (i = 0 ; i < m_boats.size() ; ++i)
      {
        m_boats.get(i).setMouseDown(m_boats.get(i).isIn(e.getPoint()));
      }
    }
  }

  public void mouseReleased(MouseEvent e)
  {
    synchronized(m_boats)
    {
      if (!m_rulesengine.CanSelectNewPiece())
      {
        return;
      }

      int i;
      for (i = 0 ; i < m_boats.size() ; ++i)
      {
        if (!m_boats.get(i).isIn(e.getPoint())) continue;
        if (!m_boats.get(i).getMouseDown()) continue;

        if (m_boats.size() > 1 && i > 0)
        {
          if (i == m_boats.size() - 1)
          {
            m_boats.get(i-1).setNextBoat(null);
          }
          else
          {
            m_boats.get(i-1).setNextBoat(m_boats.get(i).getNextBoat());
          }
        }
        m_rulesengine.PieceToTransfer(m_boats.get(i).GetWoodPiece(),RulesEngine.PieceLocation.SUSHIBOAT);
        m_boats.remove(i);
      }
    }
  }
}
