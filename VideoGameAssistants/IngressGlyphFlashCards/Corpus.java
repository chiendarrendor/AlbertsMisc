
import java.util.*;
import java.io.*;


public class Corpus
{
	public SortedMap<String,GlyphInfo> glyphs = new TreeMap<String,GlyphInfo>();
	private String filename;
	boolean writable;
	
	public Corpus(String filename)
	{
		this.filename = filename;
		try
		{		
			File file = new File(filename);
			BufferedReader br;
			if (file.exists())
			{
				FileReader fileReader = new FileReader(file);
				br = new BufferedReader(fileReader);
				writable = true;
			}
			else
			{
				InputStream is = getClass().getResourceAsStream(filename);
				if (is == null) throw new RuntimeException("filename exists as neither file nor resource");
				br = new BufferedReader(new InputStreamReader(is));
				writable = false;
			}
				
			String line;
			while((line=br.readLine()) != null)
			{
				GlyphInfo gi = new GlyphInfo(line);
				addGlyphInfo(gi);
			}
		}		
		catch (IOException e)
		{
			throw new RuntimeException("Can't load corpus",e);
		}
	}
	
	public boolean isWritable() { return writable; }
	
	public void Save()
	{
		try 
		{
			PrintWriter writer = new PrintWriter(filename);
			for (Map.Entry<String,GlyphInfo> entry : glyphs.entrySet())
			{
				writer.println(entry.getValue().toString());
			}
			writer.flush();
			writer.close();
		}
		catch (IOException e)
		{
			throw new RuntimeException("Can't save corpus",e);
		}
	}
	
	public void addGlyphInfo(GlyphInfo newg)
	{
		if (glyphs.containsKey(newg.getName()))
		{
			throw new RuntimeException("Duplicate name");
		}
		glyphs.put(newg.getName(),newg);
	}
}

			