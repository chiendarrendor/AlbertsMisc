class NonocubeBoard
{
    private int width;
    private int height;
    private int depth;
    
    public enum CubeType { UNKNOWN, ON, OFF };
    private CubeType[] cubes;

    public CubeType GetCube(int x,int y,int z)
    {
    	return cubes[z*width*height + y * width + x];
    }

    public NonocubeBoard(int w,int h,int d)
    {
    	width = w;
    	height = h;
    	depth = d;

    	int ncubes = w*h*d;
    	cubes = new CubeType[ncubes];
    	for (int i = 0 ; i < ncubes ; ++i) cubes[i] = CubeType.UNKNOWN;
    }
}
