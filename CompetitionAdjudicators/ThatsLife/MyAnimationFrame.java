

import java.awt.*;
import java.awt.event.*;

class MyAnimationFrame extends Frame
{
    MyAnimationPanel panel;

    public MyAnimationFrame(MyAnimationPanel i_p,String i_name)
    {
    super(i_name);
    panel = i_p;
    add(panel);

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
	panel.start();
    }
}


