import java.util.Vector;
import java.awt.Graphics;

abstract class ChainingAnimationElement implements MyAnimationPanel.AnimationElement
{
  private boolean m_started;
  private boolean m_dochain;
  private Vector<ChainingAnimationElement> m_chains;

  public ChainingAnimationElement(boolean i_started)
  {
    m_started = i_started;
    m_dochain = false;
    m_chains = new Vector<ChainingAnimationElement>();
  }

  public void start()
  {
    m_started = true;
  }

  public void chain()
  {
    m_dochain = true;
  }

  public void AddChain(ChainingAnimationElement elem)
  {
    m_chains.add(elem);
  }

  abstract public void chainPaint(Graphics g);

  public void paint(Graphics g)
  {
    if (!m_started) return;
    chainPaint(g);
    if (m_dochain)
    {
      for(ChainingAnimationElement chainel : m_chains)
      {
        chainel.start();
      }
    }
  }
}

    
    
