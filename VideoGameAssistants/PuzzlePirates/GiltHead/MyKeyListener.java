import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.Component;

public class MyKeyListener
{
  static private class MyListener implements KeyListener
  {
    String m_mystring;
    public MyListener(String i_ms)
    {
      m_mystring = i_ms;
    }

    public void keyReleased(KeyEvent e) {}
    public void keyPressed(KeyEvent e) {}


    public void keyTyped(KeyEvent e)
    {
      if (e.getKeyChar() == KeyEvent.VK_ESCAPE)
      {
        System.out.println("Escape typed: " + m_mystring);
      }
    }
  }

  


  public static void listen(Component c,String s)
  {
    c.addKeyListener(new MyListener(s));
  }
}
