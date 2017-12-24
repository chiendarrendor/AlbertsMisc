
public class ByteUtilities
{
	// this function takes an array of bytes, and outputs a string where each byte is two characters in the string
	// those two characters being the ascii represention of the hex value of the byte.
	public static String BytesToHex(byte[] bytes)
	{
		StringBuilder sb = new StringBuilder();
		for (byte b: bytes) { sb.append(String.format("%02x",b)); }
		return sb.toString();
	}	
	
	public static String BytesToAscii(byte[] bytes)
	{
		StringBuilder sb = new StringBuilder();
		for (byte b: bytes) { sb.append(String.format("%c",b)); }
		return sb.toString();
	}	
	
	
	// the opposite of BytesToHex:  this function takes an array of characters assumed to be
	// ascii representions of hex digits, and assumes that each pair of them are one byte, and creates an
	// array of bytes accordingly.
	public static byte[] HexToBytes(String input)
	{
		if (input == null) return null;
		int ilen = input.length();
		if (ilen % 2 != 0) throw new RuntimeException("invalid Hex string length");
		byte[] result = new byte[ilen/2];
		for (int i = 0 ; i < ilen/2; ++ i)
		{
			result[i] = (byte) ( (Character.digit(input.charAt(2*i) , 16 ) << 4) +
								 (Character.digit(input.charAt(2*i+1) , 16 ) ) );
		}
		return result;
	}
	
	
	// takes an array of bytes, and a blocksize.  returns an array of arrays of bytes, where
	// the input array has been broken up into length/blocksize arrays of bytes, each of which are blocksize in length 
	// except perhaps the last.
	public static byte[][] Blockify(byte[] bytes,int blocksize)
	{
		int numblocks = bytes.length / blocksize;
		int lastblocksize = bytes.length % blocksize;
		if (lastblocksize != 0) ++numblocks;
		
		byte[][] result = new byte[numblocks][];
		for (int blocknum = 0 ; blocknum < numblocks ; ++blocknum)
		{
			int offset = blocksize * blocknum;
			int len = blocksize;
			if (blocknum == (numblocks-1) && lastblocksize != 0) { len = lastblocksize; }
			result[blocknum] = new byte[len];
			for (int idx = 0 ; idx < len ; ++idx)
			{
				result[blocknum][idx] = bytes[idx+offset];
			}
		}
		return result;
	}
	
	
	// returns a byte[] containing all the bytes of head, followed by all the bytes of tail
	public static byte[] append(byte[] head, byte[] tail)
	{
		byte[] result = new byte[head.length+tail.length];
		for (int i = 0 ; i < head.length ; ++ i) { result[i] = head[i]; }
		for (int i = 0 ; i < tail.length ; ++ i) { result[i+head.length] = tail[i]; }
		return result;
	}
}