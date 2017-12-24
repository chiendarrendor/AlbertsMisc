import java.math.*;
import java.util.*;

public class RSABreak
{
	public static BigInteger N1 = new BigInteger("179769313486231590772930519078902473361797697894230657273430081157732675805505620686985379449212982959585501387537164015710139858647833778606925583497541085196591615128057575940752635007475935288710823649949940771895617054361149474865046711015101563940680527540071584560878577663743040086340742855278549092581");
	public static BigInteger N2 = new BigInteger("648455842808071669662824265346772278726343720706976263060439070378797308618081116462714015276061417569195587321840254520655424906719892428844841839353281972988531310511738648965962582821502504990264452100885281673303711142296421027840289307657458645233683357077834689715838646088239640236866252211790085787877");
	public static BigInteger N3 = new BigInteger("720062263747350425279564435525583738338084451473999841826653057981916355690188337790423408664187663938485175264994017897083524079135686877441155132015188279331812309091996246361896836573643119174094961348524639707885238799396839230364676670221627018353299443241192173812729276147530748597302192751375739387929");
	public static BigInteger C4 = new BigInteger("22096451867410381776306561134883418017410069787892831071731839143676135600120538004282329650473509424343946219751512256465839967942889460764542040581564748988013734864120452325229320176487916666402997509188729971690526083222067771600019329260870009579993724077458967773697817571267229951148662959627934791540");
		
	public static BigDecimal sqrt(BigDecimal in, int scale)
	{
		BigDecimal sqrt = new BigDecimal(1);
		sqrt.setScale(scale + 3, RoundingMode.FLOOR);
		BigDecimal store = new BigDecimal(in.toString());
		boolean first = true;
		do{
			if (!first){
				store = new BigDecimal(sqrt.toString());
			}
			else first = false;
			store.setScale(scale + 3, RoundingMode.FLOOR);
			sqrt = in.divide(store, scale + 3, RoundingMode.FLOOR).add(store).divide(
					BigDecimal.valueOf(2), scale + 3, RoundingMode.FLOOR);
		}while (!store.equals(sqrt));
		return sqrt.setScale(scale, RoundingMode.FLOOR);
	}

	
	public static BigInteger sqrtCeil(BigInteger x)
	{
		BigDecimal bx = new BigDecimal(x);
		BigDecimal sq  = sqrt(bx,200);
		BigDecimal squ = sq.setScale(0,RoundingMode.CEILING);
		return squ.toBigIntegerExact();		
	}
	
	public static class BiPair { BigInteger p; BigInteger q; }
	
	public static BiPair nearFactors(BigInteger center,BigInteger num)
	{
		BigInteger x = sqrtCeil(center.multiply(center).subtract(num));
		BiPair result = new BiPair();
		result.p = center.subtract(x);
		result.q = center.add(x);
		BigInteger rt = result.p.multiply(result.q);
		if (rt.equals(num)) return result;
		return null;
	}
	
	public static BiPair ProblemOne()
	{
		BigInteger A = sqrtCeil(N1);
		BiPair f2 = nearFactors(A,N1);
		if (f2 == null)
		{
			System.out.println("No Factor Problem #1");
			System.exit(1);
		}
		System.out.println("Problem 1 p: " + f2.p);
		return f2;
	}
	
	public static void ProblemTwo()
	{
		BigInteger A = sqrtCeil(N2);
		BiPair f2 = null;
		// to repeat this fast, start idx off around 72,000
		int idx = 72000;
		
		while(true)
		{
			BigInteger nA = A.add(new BigInteger(Integer.toString(idx)));
			f2 = nearFactors(nA,N2);
			if (f2 != null) break;
			++idx;
			if (idx % 1000 == 0) System.out.println("Idx: " + idx);
		}
		System.out.println("Problem 2 p: " + f2.p);
	}
	
	public static BigInteger bii(int x)
	{
		return new BigInteger(Integer.toString(x));
	}
	

	public static void ProblemThree()
	{
		System.out.println("Problem 3");
		BigInteger A = sqrtCeil(N3.multiply(bii(6)));
		
		for (int i = -10000 ; i < 10000 ; ++ i)
		{
			BigInteger Aprime = A.add(bii(i));
			
			BigInteger x = sqrtCeil(Aprime.multiply(Aprime).subtract(N3));
			BiPair result = new BiPair();
			
			for (int j = -5 ; j < 5 ; ++j)
			{
				result.p = Aprime.subtract(x).add(bii(j)).divide(bii(3));
				
				for (int k = -5 ; k < 5 ; ++k)
				{
					result.q = Aprime.add(x).add(bii(k)).divide(bii(2));
					BigInteger rt = result.p.multiply(result.q);
					if (rt.equals(N3)) System.out.println("EQUAL!");
				}
			}	
		}
		System.out.println("Problem 3 end");
	}
	
	
	
	public static void main(String[] args)
	{
		BiPair factors = ProblemOne();
		ProblemTwo();
		ProblemThree();
		
		
		// problem 4
		BigInteger N = N1;
		BigInteger p = factors.p;
		BigInteger q = factors.q;
		BigInteger phi = N.subtract(p).subtract(q).add(BigInteger.ONE);
		BigInteger e = new BigInteger(Integer.toString(65537));
		BigInteger d = e.modInverse(phi);
		BigInteger m = C4.modPow(d,N);
		byte[] bar = m.toByteArray();
		
		if (bar[0] != 0x02) {
			System.out.println("Not PKCS1 encoded!");
			System.exit(1);
		}
		
		int zeroi = -1;
		for (int i = 0 ; i < bar.length ; ++i)
		{
			if (bar[i] == 0x00)
			{
				zeroi = i;
				break;
			}
		}
		if (zeroi == -1)
		{
			System.out.println("No zero byte!");
			System.exit(1);
		}
		
		byte fbar[] = new byte[bar.length - zeroi - 1];
		for (int i = 0 ; i < bar.length-zeroi-1 ; ++i) { fbar[i] = bar[i+zeroi + 1]; }
		
		
		System.out.println(ByteUtilities.BytesToHex(fbar));
		System.out.println(ByteUtilities.BytesToAscii(fbar));
		
		
		
		

		
	}
}
		