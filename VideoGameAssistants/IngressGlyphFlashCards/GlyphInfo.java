import java.util.Vector;

public class GlyphInfo
{
	private Vector<String> names  = new Vector<String>();
	Glyph glyph;
	public int numsuccesses =0;
	public int numfailures = 0;
	
	public GlyphInfo()
	{
		names=new Vector<String>();
		glyph = new Glyph();
	}
	
	public String getName() { return names.elementAt(0); }
	public String getSecondName() 
	{
		if (names.size() == 1) return null;
		return names.elementAt(1);
	}
	public Glyph getGlyph() { return glyph; }
	
	public GlyphInfo(String s)
	{
		String[] parts = s.split(":");
		if (parts.length != 2) throw new RuntimeException("Bad GlyphInfo block: " + s);
		String[] namestrings = parts[0].split(",");
		for (String name : namestrings) names.add(name);
		glyph = new Glyph(parts[1]);
	}
	
	public GlyphInfo(String name1, String name2, Glyph theGlyph)
	{
		names.add(name1);
		if (name2 != null) names.add(name2);
		glyph = theGlyph;
	}
		
		
	
	
	@Override public String toString()
	{
		String comma = "";
		StringBuffer sb = new StringBuffer();
		for (String name : names)
		{
			sb.append(comma).append(name);
			comma = ",";
		}
		sb.append(":");
		sb.append(glyph.toString());
		return sb.toString();
	}
}
