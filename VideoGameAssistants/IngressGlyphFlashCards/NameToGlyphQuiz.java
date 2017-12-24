import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.event.*;
import java.util.*;

public class NameToGlyphQuiz extends QuizPanel
{
	public NameToGlyphQuiz(Corpus c) { super(c); guessfield.setEditable(false); }


	public void newQuestion()
	{
		showstate = false;
		errbox.setForeground(Color.BLACK);
		++numguesses;
		
		if (theGlyphs.size() == 0)
		{
			donecall.Done();
			return;
		}
		
		int rn = rand.nextInt(theGlyphs.size());
		questionGlyph = theGlyphs.elementAt(rn);
		
		gpanel.setCaptureMode();
		
		errbox.setText("(" + theGlyphs.size() + "/" + numguesses + ") GLYPH THIS WORD: ");
		guessfield.setText(questionGlyph.getName());	
		
		
		
	}

	public void actionPerformed(ActionEvent e)
	{
		if (showstate == true)
		{
			newQuestion();
			return;
		}
		
		showstate = true;
		
		Glyph guess = gpanel.getGlyph();
		gpanel.setDisplayMode(questionGlyph.getGlyph());
		if (guess == null || !guess.equals(questionGlyph.getGlyph()))
		{
			errbox.setForeground(Color.RED);
			errbox.setText("WRONG");
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
		

		

	