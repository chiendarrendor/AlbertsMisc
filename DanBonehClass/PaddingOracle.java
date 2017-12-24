import java.net.*;
import java.io.*;
import java.util.*;

public class PaddingOracle
{
	private static String ORACLEBASE="http://crypto-class.appspot.com/po?er=";
	private static String CIPHERTEXT="f20bdba6ff29eed7b046d1df9fb7000058b1ffb4210a580f748b4ac714c001bd4a61044426fb515dad3f21f18aa577c0bdf302936266926ff37dbf7035d5eeb4";
	private static int AESLEN = 16;
	
	// returns 200 if message is valid 
	// returns 403 -- invalid pad
	// returns 404 -- invalid MAC
	private static int SendMessage(String message)
	{
		int result = -1;
		try
		{
//			System.out.println("Sending: " + message);
			URL url = new URL(ORACLEBASE + message);
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();
			conn.setRequestMethod("GET");
			result =  conn.getResponseCode();
		}
		catch(Exception ex)
		{
			System.out.println("Caught exception " + ex + " now is ded.");
			System.exit(1);
		}
		return result;
	}
	
	public static void main(String []args)
	{
//		System.out.println("Valid Message response code: " + SendMessage(CIPHERTEXT));
//		System.exit(0);
		
//		System.out.println("invalid message response code: " + SendMessage("deadbeef"));
		
//		byte[] b = ByteUtilities.HexToBytes(CIPHERTEXT);
//		System.out.println("CT: " + ByteUtilities.BytesToHex(b));

		// assume that other side is using AES cipher
		byte[][] blocks = ByteUtilities.Blockify(ByteUtilities.HexToBytes(CIPHERTEXT),AESLEN);
		byte[][] plaintexts = new byte[blocks.length][];
		System.out.println("Original ciphertext blocks:");
		for (int i = 0 ; i < blocks.length ; ++i)
		{
			System.out.println(ByteUtilities.BytesToHex(blocks[i]));
		}
		
		int startblock = 3;
		for (int decblocknum = startblock ; decblocknum < blocks.length ; ++decblocknum)
		{
//			System.out.print("Block " + decblocknum);
			plaintexts[decblocknum] = new byte[AESLEN];
			for (byte idx = 15 ; idx >= 0 ; --idx)
			{
//				System.out.print(".");
				byte padval = (byte)(16 - idx);
				byte[] modblock = (byte[])blocks[decblocknum-1].clone();
				// all the bytes of modblock above idx must be set to the proper value
				for (int knownpadidx = idx+1 ; knownpadidx < 16 ; ++knownpadidx)
				{
					modblock[knownpadidx] = (byte)(modblock[knownpadidx] ^ plaintexts[decblocknum][knownpadidx] ^ padval);
				}
				
				// save the original value of the byte whose plaintext we are guessing
				byte origbyte = modblock[idx];
				int numfound = 0;
				int theguess = -1;
				Set<Byte> bv = new HashSet<Byte>();
				for (int guess = 0 ; guess < 256 ; ++guess)
				{
					System.out.println("block " + decblocknum + " idx  " + idx + " guess " + guess + " origbyte " + origbyte + " padval " + padval);
					modblock[idx] = (byte)(origbyte ^ guess ^ padval);
					bv.add(modblock[idx]);
					String toSend = "";
					System.out.print("Sending: ");
					for (int i = 0 ; i <= decblocknum ; ++i)
					{
						String curSend;
						String type;
						
						if (i == decblocknum-1) 
						{ 
							curSend = ByteUtilities.BytesToHex(modblock); 
							type = "M";
						}
						else 
						{
							curSend = ByteUtilities.BytesToHex(blocks[i]);
							type = "O";
						}
						
						System.out.print(curSend + "(" + type + ") ");
						toSend += curSend;
					}
					
					int result = SendMessage(toSend);
//					System.out.println("  Send Result: " + result);
					if (result != 403)
					{
						++numfound;
						theguess = guess;
						System.out.println(" guess was right: " + theguess);
//						break;
					}
					System.out.println("num guesses:" + bv.size());
				}
				
				if (numfound > 1)
				{
					System.out.println("Promise Failed...multiple guesses are right!");
//					System.exit(1);
				}				
				
				if (numfound == 0 )
				{
					System.out.println("Promise Failed...one of these guesses should have been right!");
					System.exit(1);
				}
				
				// if we are here, guess is the one that made the 200
				plaintexts[decblocknum][idx] = (byte)theguess;
			}
			System.out.println("");
			System.out.println("Plaintext for block #" + decblocknum + " is " + ByteUtilities.BytesToHex(plaintexts[decblocknum]));
			
		}
	}
					

}