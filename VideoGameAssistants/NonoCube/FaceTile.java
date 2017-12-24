class FaceTile
{
    private boolean isEmpty = false;
    private int num = -1;
    private CountType type = CountType.SINGLE;

    public boolean IsEmpty() { return isEmpty; }
    public int GetNum() { return num; }
    public CountType GetType() { return type; }

    public FaceTile(String s)
    {
	if (s.length() == 1 && s.charAt(0) == '#')
	{    
	    isEmpty = true;
	    return;
	}
	if (s.length() == 1 && s.charAt(0) >= '0' && s.charAt(0) <= '9')
	{
	    num = (int)(s.charAt(0) - '0');
	    return;
	}
	if (s.length() == 2 && s.charAt(0) >= '0' && s.charAt(0) <= '9' &&
	    s.charAt(1) == '.')
	{
	    num = (int)(s.charAt(0) - '0');
	    type = CountType.DOUBLE;
	    return;
	}
	if (s.length() == 2 && s.charAt(0) >= '0' && s.charAt(0) <= '9' &&
	    s.charAt(1) == '*')
	{
	    num = (int)(s.charAt(0) - '0');
	    type = CountType.TRIPLEPLUS;
	    return;
	}
	throw new RuntimeException("invalid marker " + s);
    }
}