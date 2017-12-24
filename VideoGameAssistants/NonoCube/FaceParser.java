import java.util.*;

// this class, given an array of line strings and a starting
// index, do the following:
// a) ensure the first line is 'red','green' or 'blue'
// b) at least one following line consists of repeats
//    of ([0-9][.@]?|#)
// c) determine NextIndex either by
//    1) the index of the next 'red','green' or 'blue' after a)
//    2) or that there is none prior to the end (NextIndex = -1)
// d) all lines of form b) between [start,NextIndex) should
//    have the same number of repeat units (count defines 'width')
// e) the number of lines of form b) defines the 'height'
// f) create an organize a FaceTile for each such unit
//    where 0 <= x < width (x=0 is leftmost)
//    and  0 <= y < height (y=0 is bottommost, i.e. furthest in the file)


class FaceParser
{
    private int nextIndex = -1;
    private int width = -1;
    private int height = 0;
    private String name;
    private Vector<FaceTile> tiles = new Vector<FaceTile>();

    public int GetNextIndex() { return nextIndex; }
    public int GetWidth() { return width; }
    public int GetHeight() { return height; }
    public String GetName() { return name; }
    public FaceTile GetTile(int x,int y)
    {
	if (x < 0 || y < 0 || x >= width || y >= height)
	{
	    throw new RuntimeException("Illegal coordinate ("+x+","+y+")");
	}
	return tiles.get(y*width + x);
    }

    private boolean IsTerminal(String s)
    {
        return s.equals("red") ||
	       s.equals("blue") ||
	       s.equals("green");
    }


    public FaceParser(List<String> lines,int startline)
    {
	if (startline < 0 || startline >= lines.size()-1)
	{
	    throw new RuntimeException("illegal start line " + startline);
	}
	if (!IsTerminal(lines.get(startline)))
	{
	    throw new RuntimeException("block does not start with terminal, but: " + lines.get(startline));
	}

	name = lines.get(startline);
	++startline;
	
	while(startline < lines.size())
	{
	    if (IsTerminal(lines.get(startline))) break;
	    ++height;
	    String[] items = lines.get(startline).split("\\s+");
	    if (width == -1)
	    {
		width = items.length;
	    }
	    else if (width != items.length)
	    {
		throw new RuntimeException("inconsistent width in block " + name);
	    }
	    Vector<FaceTile> tv = new Vector<FaceTile>();
	    for (int i = 0 ; i < items.length ; ++i)
	    {
		tv.add(new FaceTile(items[i]));
	    }
	    tv.addAll(tiles);
	    tiles = tv;
	    ++startline;
	}
	
	if (height == 0)
	{ 
	    throw new RuntimeException("no lines in block " + name);
	}

	if (width < 1)
	{
	    throw new RuntimeException("only empty lines in block " + name);
	}

	if (startline < lines.size())
	{
	    nextIndex = startline;
	}
    }
}
