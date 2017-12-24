import java.awt.Dimension;
import java.awt.Image;
import java.awt.Graphics;
import java.awt.Panel;
import java.util.Vector;

// this class implements an awt Panel that has a private thread
// soley responsible for scheduling a redraw of this panel
// every i_cycletime seconds.
//
// during a redraw, a new off-screen image is created,
// colored solid with a rectangle of the Panel's background color,
// and paint() called on every AnimationElement added to
// the Panel, and then this off-screen image is painted onto the on-screen space.


public class MyAnimationPanel extends Panel implements Runnable
{
  public interface AnimationElement
  {
    // called each cycle...draws a particular cell of the animation
    public void paint(Graphics g);
  }

  private Dimension size;
  private Image dbImage;
  private int m_cycletime;
  volatile boolean m_IsPaused;
  private Vector<AnimationElement> m_elements;

  
  public MyAnimationPanel(int i_width,int i_height,int i_cycletime)
  {
    size = new Dimension(i_width,i_height);
    m_cycletime = i_cycletime;
    m_IsPaused = false;
    m_elements = new Vector<AnimationElement>();
  }

  public Dimension getMinimumSize() { return size; }
  public Dimension getPreferredSize() { return size; }
  public Dimension getMaximumSize() { return size; }

  public void start()
  {
    Thread th = new Thread(this);
    th.start();
  }

  public void pause()
  {
    synchronized(size) { m_IsPaused = true; }
  }

  public void unpause()
  {
    synchronized(size) { m_IsPaused = false; }
  }

  public void run()
  {
    while(true)
    {

      synchronized(size)
      {
        if (!m_IsPaused)
        {
          repaint();
        }
      }

      try
      {
        Thread.sleep(m_cycletime);
      }
      catch(InterruptedException ex)
      {
      }
    }
  }

  public void AddAnimationElement(AnimationElement elem)
  {
    m_elements.add(elem);
  }

  public void Display()
  {
    for(int i = 0 ; i < m_elements.size() ; ++i)
    {
      System.out.println("Index " + i + ": " + m_elements.elementAt(i).toString());
    }
  }      

  public void paint(Graphics g)
  {
    for(AnimationElement ae : m_elements)
    {
      ae.paint(g);
    }
  }

  public void update(Graphics g)
  {
    Graphics dbg;
    if (dbImage == null)
    {
      dbImage = createImage(this.getSize().width,this.getSize().height);
    }
    
    dbg=dbImage.getGraphics();
    dbg.setColor(getBackground());
    dbg.fillRect(0,0,this.getSize().width,this.getSize().height);
    
    dbg.setColor(getForeground());
    paint(dbg);

    g.drawImage(dbImage,0,0,this);
  }

}

