
import java.awt.*;
import java.awt.event.*;

public class FractalCanvas extends Panel implements MouseListener
{
  FractalDrawerBase canvasFD;
  private Image dbImage;
  private Graphics dbg;
  private Dimension lastSize = new Dimension();

  private int lastX;
  private int lastY;

  public FractalCanvas(FractalDrawerBase fd)
  {
    setForeground(Color.black);
    addMouseListener(this);
    canvasFD = fd;
  }

  public Dimension getPreferredSize()
  {
    return new Dimension(800,800);
  }

  public void mousePressed(MouseEvent e)
  {
    lastX = e.getX();
    lastY = e.getY();
  }

  public void mouseEntered(MouseEvent e) {}
  public void mouseExited(MouseEvent e) {}
  public void mouseClicked(MouseEvent e) {}

  private int min(int x,int y) { return (x < y) ? x : y; }
  private int max(int x,int y) { return (x > y) ? x : y; }
  private int abs(int x) { return (x < 0) ? -x : x; }

  public void mouseReleased(MouseEvent e)
  {
    canvasFD.ReBound(getSize(),
                     new Rectangle(min(lastX,e.getX()),
                                   min(lastY,e.getY()),
                                   abs(e.getX() - lastX),
                                   abs(e.getY() - lastY)));
    dbImage = null; // force redraw
    repaint();
  }

  public void paint(Graphics g)
  {
    if (dbImage == null || !this.getSize().equals(lastSize))
    {
      dbImage = createImage(this.getSize().width,this.getSize().height);
      dbg = dbImage.getGraphics();
      canvasFD.Draw(getSize(),dbg);
    }

    g.drawImage(dbImage,0,0,this);

    lastSize = this.getSize();
  }
}
