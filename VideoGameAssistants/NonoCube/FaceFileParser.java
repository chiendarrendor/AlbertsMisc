import java.util.*;
import java.io.*;


class FaceFileParser
{
    public FaceFileParser(String fname) throws FileNotFoundException
    {
	Scanner sc = new Scanner(new File(fname));
	List<String> lines = new ArrayList<String>();
	while(sc.hasNextLine())
	{
	    lines.add(sc.nextLine());
	}

	int first = 0;
	HashMap<String,FaceParser> faces = new HashMap<String,FaceParser>();

	do
	{
	    FaceParser nfp = new FaceParser(lines,first);
	    faces.put(nfp.GetName(),nfp);
	    first = nfp.GetNextIndex();
	} while(first != -1);

	if (faces.size() != 3)
	{
	    throw new RuntimeException("file has section problems");
	}




	PrintInfo(lines,faces);

    }


    private void PrintInfo(List<String> lines,HashMap<String,FaceParser> faces)
    {
	for (String s : lines)
	{
	    System.out.println(s);
	}

	for(String k : faces.keySet())
	{
	    System.out.println("Face: " + k);
	    FaceParser fp = faces.get(k);
	    System.out.println("  Width: " + fp.GetWidth());
	    System.out.println("  Height: " + fp.GetHeight());
	    for (int y = fp.GetHeight()-1 ; y >= 0 ; --y)
	    {
		for (int x = 0 ; x < fp.GetWidth() ; ++x)
		{
		    FaceTile ft = fp.GetTile(x,y);
		    if (ft.IsEmpty()) 
		    {
			System.out.print("   ");
			continue;
		    }
		    System.out.print(ft.GetNum());
		    switch(ft.GetType())
		    {
		    case SINGLE: System.out.print("  "); break;
		    case DOUBLE: System.out.print(". "); break;
		    case TRIPLEPLUS: System.out.print("* "); break;
		    }
		}
		System.out.println("");
	    }
	}
    }
}
