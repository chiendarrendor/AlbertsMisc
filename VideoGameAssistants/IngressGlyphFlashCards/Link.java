
public class Link
{
	public int lowdot;
	public int highdot;
	public Link(int d1,int d2) { lowdot = Math.min(d1,d2) ; highdot = Math.max(d1,d2); }
	@Override public int hashCode() { return lowdot*31 + highdot*79;}
	@Override public boolean equals(Object right)
	{
		if (right == null) return false;
		if (! (right instanceof Link)) return false;
		Link rl=(Link)right;
		if (lowdot != rl.lowdot) return false;
		if (highdot != rl.highdot) return false;
		return true;
	}
	
	@Override public String toString()
	{
		StringBuffer sb = new StringBuffer();
		sb.append(Integer.toHexString(lowdot));
		sb.append(Integer.toHexString(highdot));
		return sb.toString();
	}
}