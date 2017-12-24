

public class MandelPi
{
	public static void main(String[] args)
	{
		if (args.length != 1) throw new RuntimeException("bad command line");
		double epsilon = Double.parseDouble(args[0]);
		double base = 0.25;
		
		double c = epsilon + base;
		double cur = 0.0;
		int i = 0;
		while(cur < 2.0)
		{
			double nc = cur * cur + c;
			cur = nc;
			++i;
		}
		
		System.out.println("Iterations: " + i);
	}
}