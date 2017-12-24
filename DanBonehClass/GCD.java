

public class GCD
{

	// the extended Euclid algorithm on a,b produces 3 values
	// the gcd itself
	// and integers x,y such that ax + by = gcd(a,b)
	public static class GCDData
	{
		public int x;
		public int y;
		public int gcd;
		
		public GCDData(int x,int y,int gcd) { this.x = x; this.y = y ; this.gcd = gcd; }
	}


	public static GCDData GCD(int a,int b)
	{
		int roo = a;
		int ro = b;
		int soo = 1;
		int so = 0;
		int too = 0;
		int to = 1;
		
		while(ro != 0)
		{
			int q  = roo / ro;
			int nr = roo - q * ro;
			int ns = soo - q * so;
			int nt = too - q * to;
			
			System.out.println("Q: " + q);
			System.out.println("R: " + nr);
			System.out.println("S: " + ns);
			System.out.println("T: " + nt);
			System.out.println("----");
			
			roo = ro;
			soo = so;
			too = to;
			ro = nr;
			so = ns;
			to = nt;
		}
		return new GCDData(soo,too,roo);
	}
	
	public static void main(String[] args)
	{
		if (args.length != 2) 
		{
			System.out.println("bad command line");
			System.exit(1);
		}
		
		int a=0;
		int b=0;
		
		try
		{
			a = Integer.parseInt(args[0]);
		}
		catch(Exception e)
		{
			System.out.println("failure to parse " + args[0] + " as integer");
			System.exit(1);
		}
		
		try
		{
			b = Integer.parseInt(args[1]);
		}
		catch(Exception e)
		{
			System.out.println("failure to parse " + args[1] + " as integer");
			System.exit(1);
		}
		
		GCDData gcd = GCD(a,b);
		System.out.println("gcd: " + gcd.gcd);
		System.out.println("x: " + gcd.x);
		System.out.println("y: " + gcd.y);
		System.out.println("consistency check: " + (a*gcd.x + b*gcd.y));
	}
}
		
		