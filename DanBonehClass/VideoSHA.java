import java.io.File;
import java.io.FileInputStream;
import java.security.MessageDigest;


public class VideoSHA
{

	

	

	
	
	
	public static byte[] sha256(byte[] bytes)
	{
		byte[] result = null;
		
		try
		{
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			result = digest.digest(bytes);
		} catch (Exception ex)
		{
			System.out.println("Digesting Message: " + ex);
			System.exit(1);
		}				
		return result;
	}
	
	public static void main(String args[])
	{
		if (args.length != 1)
		{
			System.out.println("Bad Command Line");
			System.exit(1);
		}
		String fname = args[0];
		byte[] contents = null;
		
		try
		{
			File file=new File(fname);
			long size=file.length();
			contents=new byte[(int)size];
			FileInputStream in=new FileInputStream(fname);
			in.read(contents);
			in.close();
		} catch (Exception ex)
		{
			System.out.println("Exception caught on load: " + ex);
			System.exit(1);
		}
		
		byte[][] blocks = Blockify(contents,1024);
		for (int i = blocks.length - 1; i >= 1 ; --i)
		{
			blocks[i-1] = append(blocks[i-1],sha256(blocks[i]));
		}
		
		System.out.println("SHA-256 hash: " + BytesToHex(sha256(blocks[0])));
		
	}
}
