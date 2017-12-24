// This class is designed to contain the construct of an Ingress Glyph
// Which is one or more lines between a hexagonal grid of dots,
// in the following shape:
//
//             1
//      2             3
//          4      5
//             6
//          7      8
//      9             10(A)
//             11(B)

import java.util.Set;
import java.util.HashSet;
import java.util.Iterator;
import java.lang.StringBuffer;

public class Glyph implements Iterable<Link>
{
	private Set<Link> links = new HashSet<Link>();
	
	public Glyph()
	{
	}
	
	public Glyph(String instr)
	{
		String[] lines = instr.split(" ");
		for (String link : lines)
		{
			if (link.length() != 2) throw new RuntimeException("Illegal Glyph Link " + link);
			int i1 = Integer.parseInt(link.substring(0,1),16);
			int i2 = Integer.parseInt(link.substring(1,2),16);
			addLink(i1,i2);
		}
	}
	
	public void addLink(int i1,int i2) { links.add(new Link(i1,i2));}
	public void removeLink(int i1, int i2)
	{
		Link doomed = new Link(i1,i2);
		links.remove(doomed);
	}
	
	public Iterator<Link> iterator() { return links.iterator(); }
	public int size() { return links.size(); }
	@Override public boolean equals(Object right)
	{
		if (right == null) return false;
		if (! (right instanceof Glyph)) return false;
		Glyph gr = (Glyph)right;
		if (links.size() != gr.links.size()) return false;
		
		for (Link lnk : links)
		{
			if (!gr.links.contains(lnk)) return false;
		}
		return true;
	}
	
	@Override public String toString()
	{
		StringBuffer sb = new StringBuffer();
		String sep = "";
		for(Link l : this)
		{
			sb.append(sep).append(l.toString());
			sep = " ";
		}
		return sb.toString();
	}
}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	