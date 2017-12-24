import java.awt.Graphics;
import java.awt.Color;
import java.util.Vector;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.Point;

class SushiBar 
{
  private RulesEngine m_rulesengine;
  private Vector<SushiBoat> m_boats;
  private WoodPieceChanger m_wpc;

  public SushiBar(RulesEngine i_rulesengine,WoodPieceChanger i_wpc)
  {
    m_rulesengine = i_rulesengine;
    m_boats = new Vector<SushiBoat>();
    m_wpc = i_wpc;
  }


  public void mousePressed(MouseEvent e)
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
        // if we get here, boat i was clicked on.

        if (e.getButton() == MouseEvent.BUTTON3)
        {
          if (m_wpc != null)
          {
            m_wpc.ChangeWoodPiece(m_boats.get(i).GetWoodPiece());
          }
          continue;
        }

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

  public void paint(Graphics g)
  {
    g.drawImage(ImageManager.getImage("SushiWater.png"),
                0,GiltHeadConstants.SUSHI_BAR_Y_LOCATION,null);


    synchronized(m_boats)
    {

      // figure out if we need a new boat.
      if (m_boats.size() == 0 || m_boats.get(0).getX() > GiltHeadConstants.SUSHI_SEPARATION)
      {
        SushiBoat sb = new SushiBoat(m_rulesengine.GetNewWoodPiece(),m_rulesengine.GetSushiBarVelocity());
        if (m_boats.size() > 0)
        {
          sb.setNextBoat(m_boats.get(0));
        }
        m_boats.add(0,sb);
      }

      // figure out if the last boat is off the screen
      SushiBoat lastboat = m_boats.get(m_boats.size()-1);

      if (lastboat.getX() > GiltHeadConstants.SCREEN_WIDTH)
      {
        m_rulesengine.ReturnWoodPiece(lastboat.GetWoodPiece());
        m_boats.remove(m_boats.size()-1);
      }

      // update boat positions and draw them
      int i;
      for (i = 0 ; i < m_boats.size() ; ++i)
      {
        m_boats.get(i).UpdateAndDraw(g,m_rulesengine.IsScoring(),m_rulesengine.GetAccelerate());
      }
    }
  }
}
