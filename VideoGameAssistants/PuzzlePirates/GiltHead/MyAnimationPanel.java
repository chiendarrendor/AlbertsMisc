import java.awt.Dimension;
import java.awt.Image;
import java.awt.Graphics;
import java.awt.Panel;

// this class implements an awt Panel that has a private thread
// soley responsible for scheduling a redraw of this panel
// every i_cycletime seconds.
//
// during a redraw, a new off-screen image is created,
// colored solid with a rectangle of the Panel's background color,
// paint()ed with the Panel's paint() method, and then
// this off-screen image is painted onto the on-screen space.


public class MyAnimationPanel extends Panel implements Runnable
{
  private Dimension size;
  protected Image dbImage;
  protected Graphics dbg;
  private int m_cycletime;
  volatile boolean m_IsPaused;
  
  public MyAnimationPanel(int i_width,int i_height,int i_cycletime)
  {
    size = new Dimension(i_width,i_height);
    m_cycletime = i_cycletime;
    m_IsPaused = false;
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

  public void update(Graphics g)
  {
    if (dbImage == null)
    {
      dbImage = createImage(this.getSize().width,this.getSize().height);
      dbg=dbImage.getGraphics();
    }

    dbg.setColor(getBackground());
    dbg.fillRect(0,0,this.getSize().width,this.getSize().height);
    
    dbg.setColor(getForeground());
    paint(dbg);

    g.drawImage(dbImage,0,0,this);
  }

}

