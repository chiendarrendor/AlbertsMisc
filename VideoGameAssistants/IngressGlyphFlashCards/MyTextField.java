import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.event.*;
import javax.swing.text.*;

public class MyTextField extends JTextField
{
	private class UppercaseDocumentFilter extends DocumentFilter {
		public void insertString(DocumentFilter.FilterBypass fb, int offset,
				String text, AttributeSet attr) throws BadLocationException {

			fb.insertString(offset, text.toUpperCase(), attr);
		}

		public void replace(DocumentFilter.FilterBypass fb, int offset, int length,
				String text, AttributeSet attrs) throws BadLocationException {

			fb.replace(offset, length, text.toUpperCase(), attrs);
		}
	}

	private static int NUMCOLUMNS = 15;
	public MyTextField()
	{
		setColumns(NUMCOLUMNS);
		Font font = new Font("Coda",Font.BOLD,30);
		setFont(font);
		setMaximumSize(this.getPreferredSize());
		setMinimumSize(this.getPreferredSize());
		((AbstractDocument)getDocument()).setDocumentFilter(new UppercaseDocumentFilter());
		
	}
}
