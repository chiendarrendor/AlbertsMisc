import java.awt.*;
import java.awt.event.*;

public class Fractal
{
  public static void main(String[] args)
  {
    Frame f = new Frame("Fractals");
    f.addWindowListener(new WindowAdapter()
      {
        public void windowClosing(WindowEvent e)
        {
          System.exit(0);
        }
      });
    
    FractalDrawerBase fdb;
    //fdb = new MyFractalDrawer();
    //fdb = new MandelbrotDrawer();
    fdb = new BurningShipDrawer();
    //fdb = new MandelbarDrawer();
    //fdb = new BiomorphDrawer();
    

    f.add(new FractalCanvas(fdb),BorderLayout.CENTER);
    f.pack();
    f.setVisible(true);
  }
}
