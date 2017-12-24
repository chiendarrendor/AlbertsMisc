import java.io.*;

class NonocubeSolver
{
    public static void main(String[] argv)
    {
    	if (argv.length != 1)
    	{
    		System.out.println("bad command line");
    		return;
    	}
    	
    	TubeSet ts = new TubeSet(9);
    	ts.PrintTubes();
    	System.exit(1);
    	
    	
    	FaceFileParser ffp = null;
    	try
    	{
    		ffp = new FaceFileParser(argv[0]);
    	}
    	catch(FileNotFoundException fnfe)
    	{
    		System.out.println("file " + argv[0] + " not found: " + fnfe);
    		return;
    	}
    }
}