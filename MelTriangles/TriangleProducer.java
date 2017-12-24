
public class TriangleProducer
{
	private long triedge = 1;
	private long curtri = 1;
	
	private int TriBefore(long high)
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
	
	private long sqedge = 2;

	public int Next()
	{
		int tb = TriBefore(sqedge*sqedge);
		++sqedge;
		return tb;
	}
}