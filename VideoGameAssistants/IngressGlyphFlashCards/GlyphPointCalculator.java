

public class GlyphPointCalculator
{	
	double cos30;
	double sin30;
	
	double edgelen;
	double xoff;
	double yoff;
	double o;
	double a;
	
	public GlyphPointCalculator(double nominal_offset,double screen_width,double screen_height)
	{		
		cos30 = Math.cos(Math.toRadians(30.0));
		sin30 = Math.sin(Math.toRadians(30.0));
		
		double xbasededge = (screen_width - 2.0 * nominal_offset) / (2.0 * cos30);
		double ybasededge = (screen_height - 2.0 * nominal_offset) / 2.0;
		edgelen = Math.min(xbasededge,ybasededge);
		
		xoff = (screen_width - 2.0 * cos30 * edgelen) / 2.0;
		yoff = (screen_height - 2.0 * edgelen) / 2.0;
		o = edgelen * sin30;
		a = edgelen * cos30;
	}
	
	// using the same point numbering convention documented in Glyph.java
	// return the x coordinate for that point. 
	// throw an exception for an illegal point id.
	
	public double getX(int pointID)
	{
		switch(pointID)
		{
			case 2:
			case 9:
				return xoff;
			case 1:
			case 6:
			case 0xB:
				return xoff + a;
			case 3:
			case 0xA:
				return xoff + 2*a;
			case 4:
			case 7:
				return xoff+a/2.0;
			case 5:
			case 8:
				return xoff+3.0*a/2.0;
			default:
				throw new RuntimeException("Illegal point id " + pointID);
		}
	}
	
	public double getY(int pointID)
	{
		switch(pointID)
		{
			case 1:
				return yoff;
			case 2:
			case 3:
				return yoff+o;
			case 4:
			case 5:
				return yoff+o+edgelen/4.0;
			case 6:
				return yoff+o+edgelen/2.0;
			case 7:
			case 8:
				return yoff+o+3.0*edgelen/4.0;
			case 9:
			case 0xA:
				return yoff+o+edgelen;
			case 0xB:
				return yoff + 2.0*o + edgelen;
			default:
				throw new RuntimeException("Illegal point id " + pointID);
		}
	}
	
	public double distSquaredFromPoint(int x,int y,int point)
	{
		double dx = x - getX(point);
		double dy = y - getY(point);
		return dx*dx + dy*dy;
	}
	
	public int nearestPoint(int x,int y,int maxdist)
	{
		int shortest = 1;
		double dshort = distSquaredFromPoint(x,y,shortest);
		for (int i = 2 ; i <= 0xB ; ++i)
		{
			double t_dshort = distSquaredFromPoint(x,y,i);
			if (t_dshort < dshort)
			{
				dshort = t_dshort;
				shortest = i;
			}
		}
		if (dshort > maxdist) return 0;
		return shortest;
	}
}

		