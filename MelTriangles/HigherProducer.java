public class HigherProducer
{
	TriangleProducer tp = new TriangleProducer();
	
	int Next()
	{
		int onecount = 0;
		int prevnumber = -1;
		
		while(true)
		{
			int nt = tp.Next();
			if (nt == 1)
			{
				if (prevnumber == 1)
				{
					return onecount - 1;
				}
				else
				{
					++onecount;
				}
			}
			prevnumber = nt;
		}
	}
}