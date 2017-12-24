

import java.util.Map;
import java.util.HashMap;

public class FolderSet
{
	private class Folder
	{
		public String name;
		public String parentid;
		public Folder(String name,String parentid) { this.name = name; this.parentid = parentid; }
	}

	private Map<String,Folder>  folders = new HashMap<String,Folder>();
	
	public FolderSet() {}
	
	public void AddFolder(String name, String id, String parentid)
	{
		Folder f = new Folder(name,parentid);
		folders.put(id,f);
	}
	
	String GetFullFolderName(String id)
	{
		StringBuffer sb = new StringBuffer();
		boolean first = true;
		
		while(id != null)
		{
			Folder f = folders.get(id);
			if (!first) sb.insert(0,'/');
			first = false;
			sb.insert(0,f.name);
			id = f.parentid;
		}
		return sb.toString();
	}
}
			