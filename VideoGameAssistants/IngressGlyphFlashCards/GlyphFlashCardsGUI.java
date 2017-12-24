import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.event.*;

public class GlyphFlashCardsGUI
{
	// card panel things
	private final static String NEWGLYPH="New Glyph Card";
	private final static String SHOWGLYPHS="Show Glyphs";
	private final static String GLYPHQUIZ="Glyph to English";
	private final static String ENGLISHQUIZ="English to Glyph";
	private JPanel cardpanel;
	private CardLayout flipper;
	
	// Glyph things
	private final static String CORPUSNAME="corpus.txt";
	private Corpus corpus;
	
	// Glyph GUI things;
	private NewGlyphPanel newGlyphPanel;
	private ShowGlyphsPanel showGlyphsPanel;
	private GlyphToNameQuiz glyphQuizPanel;
	private NameToGlyphQuiz englishQuizPanel;
	
	// listeners
	private class SwitchBack implements DoneCall,ActionListener
	{
		public void Done()
		{
			flipper.show(cardpanel,SHOWGLYPHS);
			showGlyphsPanel.rebuildList();
		}
		
		public void actionPerformed(ActionEvent e)
		{
			Done();
		}
	}
	
	private SwitchBack theSwitchBack = new SwitchBack();
	
	private class NewAction implements ActionListener
	{
		public void actionPerformed(ActionEvent e)
		{
			flipper.show(cardpanel,NEWGLYPH);
			newGlyphPanel.prepare(theSwitchBack);
		}
	}
	
	private class GlyphQuizAction implements ActionListener
	{
		public void actionPerformed(ActionEvent e)
		{
			flipper.show(cardpanel,GLYPHQUIZ);
			glyphQuizPanel.startQuiz(theSwitchBack);
		}
	}
	
	private class EnglishQuizAction implements ActionListener
	{
		public void actionPerformed(ActionEvent e)
		{
			flipper.show(cardpanel,ENGLISHQUIZ);
			englishQuizPanel.startQuiz(theSwitchBack);
		}
	}	
	

	public GlyphFlashCardsGUI()
	{
		// frame
		JFrame frame = new JFrame("Ingress Glyph Flash Cards");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		// card panel
		flipper = new CardLayout();
		cardpanel = new JPanel(flipper);
		frame.getContentPane().add(cardpanel);
		cardpanel.setPreferredSize(new Dimension(700,700));
		
		// Glyph things
		corpus = new Corpus(CORPUSNAME);
		newGlyphPanel = new NewGlyphPanel(corpus);
		showGlyphsPanel = new ShowGlyphsPanel(corpus);
		glyphQuizPanel = new GlyphToNameQuiz(corpus);
		englishQuizPanel = new NameToGlyphQuiz(corpus);
		
		cardpanel.add(newGlyphPanel,NEWGLYPH);
		cardpanel.add(showGlyphsPanel,SHOWGLYPHS);
		cardpanel.add(glyphQuizPanel,GLYPHQUIZ);
		cardpanel.add(englishQuizPanel,ENGLISHQUIZ);
		flipper.show(cardpanel,SHOWGLYPHS);
		
		// Menu
		JMenuBar mbar = new JMenuBar();
		JMenu fileMenu = new JMenu("File");
		JMenuItem newGlyph = new JMenuItem("New Glyph");
		newGlyph.addActionListener(new NewAction());
		
		JMenuItem glyphQuiz = new JMenuItem("Glyph to English Quiz");
		glyphQuiz.addActionListener(new GlyphQuizAction());
		JMenuItem englishQuiz = new JMenuItem("English to Glyph Quiz");
		englishQuiz.addActionListener(new EnglishQuizAction());
		JMenuItem giveUp = new JMenuItem("Give up on Quiz");
		giveUp.addActionListener(theSwitchBack);
		
		mbar.add(fileMenu);
		
		if (corpus.isWritable()) fileMenu.add(newGlyph);
		fileMenu.add(glyphQuiz);
		fileMenu.add(englishQuiz);
		fileMenu.add(giveUp);
		frame.setJMenuBar(mbar);
		
		// startup stuff
		frame.pack();
		frame.setVisible(true);
	}
}
		
		
		
