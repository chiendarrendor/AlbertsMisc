import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.event.*;


public class NewGlyphPanel extends Box implements ActionListener
{


	private JTextField firstname = new MyTextField();
	private JTextField secondname = new MyTextField();
	private GlyphPanel gpanel = new GlyphPanel(300,400,50,20,false);
	private JButton okbutton = new JButton("OK");
	private JLabel errbox = new JLabel();
	private Corpus theCorpus;
	private DoneCall callback = null;

	
	public NewGlyphPanel(Corpus c)
	{
		super(BoxLayout.PAGE_AXIS);
		theCorpus = c;
	
		add(Box.createVerticalStrut(15));
		Box firstnamepanel=Box.createHorizontalBox();
		firstnamepanel.add(new JLabel("Primary Name"));
		firstnamepanel.add(firstname);
		firstnamepanel.add(Box.createHorizontalGlue());
		add(firstnamepanel);
		add(Box.createVerticalStrut(15));
		Box secondnamepanel=Box.createHorizontalBox();
		secondnamepanel.add(new JLabel("Secondary Name"));
		secondnamepanel.add(secondname);
		secondnamepanel.add(Box.createHorizontalGlue());
		add(secondnamepanel);
		
		add(Box.createVerticalStrut(5));
		add(gpanel);
		add(Box.createVerticalStrut(5));
		add(errbox);
		add(Box.createVerticalStrut(5));
		
		Box okpanel = Box.createHorizontalBox();
		okpanel.add(Box.createHorizontalGlue());
		okpanel.add(okbutton);
		add(okpanel);
		
		okbutton.addActionListener(this);
	}
	
	public void prepare(DoneCall dc)
	{
		firstname.setText("");
		secondname.setText("");
		gpanel.setCaptureMode();
		callback = dc;
		errbox.setText(" ");
	}
	
	public void actionPerformed(ActionEvent e)
	{
		if (firstname.getText().length() == 0) 
		{
			errbox.setText("primary name not set");
			return;
		}
		
		String n1 = firstname.getText();
		String n2 = null;
		if (secondname.getText().length() > 0) n2 = secondname.getText();
		if (gpanel.getGlyph() == null) 
		{
			errbox.setText("no glyph drawn");
			return;
		}
		GlyphInfo ngi = new GlyphInfo(n1,n2,gpanel.getGlyph());
		
		try
		{
				theCorpus.addGlyphInfo(ngi);
				theCorpus.Save();
				errbox.setText("Corpus Saved");
		}
		catch(RuntimeException re)
		{
			errbox.setText(re.getMessage());
		}
		if (callback != null) { callback.Done(); }
		
	}
	
}
