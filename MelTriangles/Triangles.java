

public class Triangles
{
	public static long triedge = 1;
	public static long curtri = 1;
	public static int TriBetween(long low,long high)
	{
		int count = 1;
		while(true)
		{
			++triedge;
			curtri += triedge;
			if (curtri >= high)
			{
				break;
			}
			else
			{
				++count;
			}
		}
		return count;
	}

	private static void ProveSqrt2()
	{
		long squedge;
		long presq = 1;
		double count = 0;
		double sum = 0;
		double sq2 = Math.sqrt(2.0);
		
		for (squedge = 2 ; squedge < 100000 ; ++squedge)
		{
			long cursq = squedge * squedge;
			int tb = TriBetween(presq,cursq);
			++count;
			sum += tb;
			
			
			System.out.println(tb + " " + (sum/count) + " " + (sum/count - sq2));
			presq = cursq;
		}
	}	
	
	private static void ProveHigher()
	{
		long squedge;
		long presq = 1;
		
		int onecount = 0;
		int prevbetween = -1;
		
		
		for (squedge = 2 ; squedge < 100000 ; ++squedge)
		{
			long cursq = squedge * squedge;
			int tb = TriBetween(presq,cursq);

			System.out.println(tb);

			
			if (tb == 1)
			{
				if (prevbetween == 1)
				{
					System.out.println("\t"+(onecount-1));
					onecount = 0;
				}
				else
				{
					++onecount;
				}
			}
			
			prevbetween = tb;
			presq = cursq;
		}
	}
	
	public static void main(String[] args)
	{
		TriangleProducer tp = new TriangleProducer();
		HigherProducer hp = new HigherProducer();
		hp.Next();
		
		for (int i = 0 ; i < 10000000000L ; ++i)
		{
			int tn = tp.Next();
			int hn = hp.Next();
			
			if (tn != hn)
			{
				System.out.println("BLAH! " + i + " " + tn + " " + hn);
				throw new RuntimeException();
			}
			if (i % 100000 == 0) System.out.print(".");
		}
			
	}
	
	
	
}
