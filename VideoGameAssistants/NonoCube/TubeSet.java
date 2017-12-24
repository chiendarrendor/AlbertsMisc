import java.util.HashMap;
import java.util.Vector;

public class TubeSet 
{
	public static class FaceKey
	{
		public int count;
		public CountType type;
		public FaceKey(int c,CountType t)
		{
			count = c;
			type = t;
		}
		public int hashCode()
		{
			return new Integer(count).hashCode() + type.hashCode();
		}
		public boolean equals(Object o)
		{
			if (o != null && o instanceof FaceKey)
			{
				FaceKey other = (FaceKey)o;
				return count == other.count && type == other.type;
			}
			return false;
		}
	}
	
	HashMap<FaceKey,Vector<Integer>> tubes = new HashMap<FaceKey,Vector<Integer>>();
	int size;
	
	
	public TubeSet(int size)
	{
		this.size = size;
		int lim = 1 << size;
		for (int i = 0 ; i < lim ; ++i )
		{
			// look at every bit in i
			// determine two things
			// a) count of 1 bits
			// b) number of separate blocks
			int count = 0;
			int numblocks = 0;
			boolean inblock = false;
			for (int j = 0 ; j < size ; ++j)
			{
				int bit = (i>>j)&1;
				if (bit == 1) ++count;
				if (bit == 1 && !inblock)
				{
					inblock = true;
					++numblocks;
				}
				if (bit == 0 && inblock)
				{
					inblock = false;
				}
			}
			CountType t = CountType.SINGLE;
			if (numblocks == 2) t = CountType.DOUBLE;
			if (numblocks > 2) t = CountType.TRIPLEPLUS;
			
			FaceKey fk = new FaceKey(count,t);
			if (!tubes.containsKey(fk))
			{
				tubes.put(fk, new Vector<Integer>());
			}
			tubes.get(fk).add(i);
		}
	}
	
	void PrintTubes()
	{
		for(FaceKey fk : tubes.keySet())
		{
			System.out.println("Key: " + fk.count + fk.type );
			for(int v : tubes.get(fk))
			{
				System.out.println("  " + PrintBinary(v));
			}
		}
	}
	
	String PrintBinary(int v)
	{
		StringBuilder sb = new StringBuilder();
		String unpadded = Integer.toBinaryString(v);
		for (int i = 0 ; i < size-unpadded.length() ; ++i) sb.append('0');
		sb.append(unpadded);
		return sb.toString();
	}
}
