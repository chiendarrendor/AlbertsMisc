import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.event.*;


public class GlyphPanel extends JPanel
{
	private int width;
	private int height;
	private int offset;
	private int cirsize;
	
	private static final int CIRDETECT = 300;
	
	private Glyph currentGlyph;
	int lastPoint;
	int cursorX;
	int cursorY;

	private class DrawListener extends MouseInputAdapter
	{
		public void mousePressed(MouseEvent e)
		{
			currentGlyph = new Glyph();
			lastPoint = 0;
			mouseDragged(e);
		}
		
		public void mouseDragged(MouseEvent e)
		{
			cursorX = e.getX();
			cursorY = e.getY();
			GlyphPointCalculator gpc = new GlyphPointCalculator(offset,getWidth(),getHeight());
			int nearPoint = gpc.nearestPoint(cursorX,cursorY,CIRDETECT);
			if (nearPoint > 0)
			{
				if (nearPoint != lastPoint)
				{
					if (lastPoint != 0)
					{
						currentGlyph.addLink(lastPoint,nearPoint);
					}
					lastPoint = nearPoint;
				}
			}
			repaint();
		}
		
		public void mouseReleased(MouseEvent e)
		{
			lastPoint = 0;
			repaint();
		}
	}	
	
	
	DrawListener listener = new DrawListener();
	
	public GlyphPanel(int width,int height,int offset,int cirsize,boolean lockSize)
	{
		this.width = width;
		this.height = height;
		this.offset = offset;
		this.cirsize = cirsize;
	
		setPreferredSize(new Dimension(width,height));
		if (lockSize)
		{
			setMinimumSize(getPreferredSize());
			setMaximumSize(getPreferredSize());
		}
		setOpaque(true);	

		currentGlyph = null;
	}
	
	private void drawCircle(Graphics g,double x,double y)
	{
		int ix = (int)(x-cirsize/2.0);
		int iy = (int)(y-cirsize/2.0);
		g.drawOval(ix,iy,cirsize,cirsize);
	}
	
	public void drawGlyph(Graphics g,GlyphPointCalculator gpc,Glyph glyph)
	{
		for (Link lk : glyph)
		{
			g.drawLine((int)gpc.getX(lk.lowdot),(int)gpc.getY(lk.lowdot),
					   (int)gpc.getX(lk.highdot),(int)gpc.getY(lk.highdot));
		}
	}
	
	public void setDisplayMode(Glyph g)
	{
		currentGlyph = g;
		removeMouseListener(listener);
		removeMouseMotionListener(listener);
		repaint();
	}
	
	public void setCaptureMode()
	{
		currentGlyph = null;
		addMouseListener(listener);
		addMouseMotionListener(listener);
		repaint();
	}
	
	public Glyph getGlyph() { return currentGlyph; }
	
	
	
	
	
	
	
	
	public void paint(Graphics g)
	{
		Graphics2D g2d = (Graphics2D)g;
		GlyphPointCalculator gpc = new GlyphPointCalculator(offset,getWidth(),getHeight());	
	
		g.setColor(Color.BLACK);
		g.fillRect(0, 0, getWidth(), getHeight());
		
		g.setColor(Color.GREEN);
		Stroke olds = g2d.getStroke();
		g2d.setStroke(new BasicStroke(cirsize/2,BasicStroke.CAP_ROUND,BasicStroke.JOIN_BEVEL));
		if (currentGlyph != null) drawGlyph(g,gpc,currentGlyph);
		
		if (lastPoint != 0) g.drawLine(cursorX,cursorY,(int)gpc.getX(lastPoint),(int)gpc.getY(lastPoint));
		
		g.setColor(Color.RED);
		g2d.setStroke(olds);
		
		for (int i = 1 ; i <= 11 ; ++i)
		{
			drawCircle(g,gpc.getX(i),gpc.getY(i));
		}
		
		
	}
	
	
}
