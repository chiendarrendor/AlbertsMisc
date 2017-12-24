import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.event.*;
import java.util.*;

public class ShowGlyphsPanel extends JScrollPane
{
	Box dataPanel = Box.createVerticalBox();
	Corpus corpus;
	Font font = new Font("Coda",Font.BOLD,30);

	private class GlyphItem extends Box
	{
		public GlyphItem(GlyphInfo gi)
		{
			super(BoxLayout.X_AXIS);
			StringBuffer sb = new StringBuffer();
			sb.append("(");
			sb.append(gi.numfailures);
			sb.append(")");
			sb.append(gi.getName());
			if (gi.getSecondName() != null) sb.append("(").append(gi.getSecondName()).append(")");
			JLabel jl = new JLabel(sb.toString());
			jl.setFont(font);
			add(jl);
			add(Box.createHorizontalGlue());
			GlyphPanel gp = new GlyphPanel(50,50,5,4,true);
			gp.setDisplayMode(gi.getGlyph());
			add(gp);
		}
	}


	public ShowGlyphsPanel(Corpus corp)
	{
		setViewportView(dataPanel);
		corpus = corp;
		rebuildList();
	}
	
	private class sorter implements Comparator<GlyphInfo>
	{
		public int compare(GlyphInfo o1,GlyphInfo o2)
		{
			int d = o2.numfailures - o1.numfailures;
			if (d != 0) return d;
			return o1.getName().compareTo(o2.getName());
		}
		
		public boolean equals(Object obj)
		{
			return false;
		}
	}
	
	
	public void rebuildList()
	{
		dataPanel.removeAll();
		GlyphInfo[] glyphs = corpus.glyphs.values().toArray(new GlyphInfo[0]);
		Arrays.sort(glyphs,0,glyphs.length,new sorter());
		for (GlyphInfo gi : glyphs)
		{
			dataPanel.add(new GlyphItem(gi));
			dataPanel.add(Box.createVerticalStrut(1));
		}
	}
}