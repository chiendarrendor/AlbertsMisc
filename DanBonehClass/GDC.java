

public class GCD
{

	// the extended Euclid algorithm on a,b produces 3 values
	// the gcd itself
	// and integers x,y such that ax + by = gcd(a,b)
	public static struct GCDData
	{
		int x;
		int y;
		int gcd;
		
		public GCDData(int x,int y,int gcd) { this.x = x; this.y = y ; this.gcd = gcd; }
	}


	public static int GCD(int a,int b)
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
			roo = ro;
			soo = so;
			too = to;
			ro = nr;
			so = ns;
			to = nt;
		}
		return new GCDData(roo,soo,too);
	}
	
	public static void main(String[] args)
	{
		if (args.length != 2) 
		{
			System.out.println("bad command line");
			System.exit(1);
		}
		
		int a,b;
		
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
		
		GCData gcd = GCD(a,b);
		System.out.println("gcd: " + gcd.gcd);
		System.out.println("x: " + gcd.x);
		System.out.println("y: " + gcd.y);
		System.out.println("consistency check: " + (a*x + b*y));
	}
}
		
		