import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.event.*;
import java.util.*;

public abstract class QuizPanel extends Box implements ActionListener
{
	protected static final int CORRECTDELTA = 2;

	protected JTextField guessfield = new MyTextField();
	protected GlyphPanel gpanel = new GlyphPanel(300,400,50,20,false);
	private JButton okbutton = new JButton("OK");
	protected JLabel errbox = new JLabel();
	protected Corpus theCorpus;
	protected DoneCall donecall = null;
	protected Random rand;
	protected boolean showstate; // true if player has guessed....wait until next ok to show next question
	protected int numguesses;

	protected Vector<GlyphInfo> theGlyphs = new Vector<GlyphInfo>();
	protected GlyphInfo questionGlyph;
	
	public QuizPanel(Corpus c)
	{
		super(BoxLayout.PAGE_AXIS);
		
		rand = new Random(System.currentTimeMillis());
		
		theCorpus = c;
		add(Box.createVerticalStrut(15));
		add(gpanel);
		add(Box.createVerticalStrut(15));
		Box errpanel = Box.createHorizontalBox();
		errpanel.add(errbox);
		errpanel.add(Box.createHorizontalGlue());
		add(errpanel);
		add(Box.createVerticalStrut(5));
		add(guessfield);
		guessfield.addActionListener(this);

		Font font = new Font("Coda",Font.BOLD,30);
		errbox.setFont(font);
		add(Box.createVerticalStrut(5));
		
		Box okpanel = Box.createHorizontalBox();
		okpanel.add(Box.createHorizontalGlue());
		okpanel.add(okbutton);
		okbutton.addActionListener(this);
		add(okpanel);
	}
	
	public void startQuiz(DoneCall ondone)
	{
		donecall = ondone;
		numguesses = 0;
		theGlyphs.clear();
		
		for (Map.Entry<String,GlyphInfo> entry : theCorpus.glyphs.entrySet())
		{
			GlyphInfo gi = entry.getValue();
			gi.numsuccesses = 0;
			gi.numfailures = 0;
			theGlyphs.add(gi);
		}
		
		newQuestion();
	}
	
	
	public abstract void newQuestion();
	public abstract void actionPerformed(ActionEvent e);
}
		
		

	