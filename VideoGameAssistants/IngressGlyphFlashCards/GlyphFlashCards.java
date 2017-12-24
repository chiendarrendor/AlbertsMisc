
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.event.*;

public class GlyphFlashCards
{

    private static void createAndShowGUI() {
		new GlyphFlashCardsGUI();
    }

	public static void main(String args[])
	{
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                createAndShowGUI();
            }
        });
	}
}

