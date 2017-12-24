
import java.awt.*;
import java.awt.event.*;

class LightCycleFrame extends Frame
{
  LightCyclePanel lcp;

  public LightCycleFrame(GameInfo gi,int boardsize)
  {
    super("Light Cycles");
    lcp = new LightCyclePanel(gi,boardsize);
    add(lcp);
    addWindowListener(new WindowAdapter() 
      { 
        public void windowClosing(WindowEvent we) 
        { 
          System.exit(0) ;
        }
      } );
  }

  public void start()
  {
    lcp.start();
  }
}


