import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.event.*;
import java.util.*;

public class GlyphToNameQuiz extends QuizPanel
{
	public GlyphToNameQuiz(Corpus c) { super(c); }


	public void newQuestion()
	{
		showstate = false;
		errbox.setForeground(Color.BLACK);
		++numguesses;
		
		errbox.setText("(" + theGlyphs.size() + "/" + numguesses + ") WHAT IS THIS GLYPH? ");
		guessfield.setText("");

		if (theGlyphs.size() == 0)
		{
			donecall.Done();
			return;
		}
		
		int rn = rand.nextInt(theGlyphs.size());
		questionGlyph = theGlyphs.elementAt(rn);
		gpanel.setDisplayMode(questionGlyph.getGlyph());
	}

	public void actionPerformed(ActionEvent e)
	{
		if (showstate == true)
		{
			newQuestion();
			return;
		}
		
		showstate = true;
		
		String guess = guessfield.getText();
		if (!guess.equals(questionGlyph.getName()) && !guess.equals(questionGlyph.getSecondName()))
		{
			errbox.setForeground(Color.RED);
			StringBuffer sb = new StringBuffer();
			sb.append("WRONG: ");
			sb.append(questionGlyph.getName());
			if (questionGlyph.getSecondName() != null)
			{
				sb.append("(");
				sb.append(questionGlyph.getSecondName());
				sb.append(")");
			}
			errbox.setText(sb.toString());
			questionGlyph.numfailures++;
		}
		else
		{
			errbox.setForeground(Color.GREEN);
			errbox.setText("RIGHT!");
			questionGlyph.numsuccesses++;
			
			if ((questionGlyph.numsuccesses - questionGlyph.numfailures) >= CORRECTDELTA)
			{
				theGlyphs.remove(questionGlyph);
			}
		}
	}
}
		
		

	