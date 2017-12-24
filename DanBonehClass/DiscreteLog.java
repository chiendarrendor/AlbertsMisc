import java.math.BigInteger;
import java.util.*;

public class DiscreteLog
{
	static BigInteger p = new BigInteger("13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858186486050853753882811946569946433649006084171");
	static BigInteger g = new BigInteger("11717829880366207009516117596335367088558084999998952205599979459063929499736583746670572176471460312928594829675428279466566527115212748467589894601965568");
	static BigInteger h = new BigInteger("3239475104050450443565264378728065788649097520952449527834792452971981976143292558073856937958553180532878928001494706097394108577585732452307673444020333");
	static BigInteger B = new BigInteger("2").pow(20);
	// Goal:  Find x such that g^x = h in Zp
	// method:  given that our p,g,h are ~ 2^40, x < 2^20 
	//          we define putative x0,x1 such that x = x0 * B + x1
	// and by refactoring, we get h/(g^x1) = g^B^x0
	// given that we know that x0 and x1 are in the range [0,2^20]
	// we can make a table of all value of h/(g^x1) and see if there is an equal 
	

	public static void main(String[] args)
	{
		Map<BigInteger,BigInteger> lhsmap = new HashMap<BigInteger,BigInteger>();
		
		BigInteger idx = BigInteger.ZERO;
		
		for ( ; !idx.equals(B) ; idx = idx.add(BigInteger.ONE))
		{
			BigInteger lhs  = g.modPow(idx,p).modInverse(p).multiply(h).mod(p);
			lhsmap.put(lhs,idx);
		}
		
		System.out.println("LHS calculated...");
		
		idx = BigInteger.ZERO;
		for ( ; !idx.equals(B) ; idx = idx.add(BigInteger.ONE))
		{
			BigInteger rhs = g.modPow(B,p).modPow(idx,p);
			if (lhsmap.containsKey(rhs))
			{
				BigInteger x1 = lhsmap.get(rhs);
				BigInteger x0 = idx;
				BigInteger x = x0.multiply(B).add(x1);
				System.out.println("Result: " + x);
				break;
			}
		}
				
		
		
	}
}
