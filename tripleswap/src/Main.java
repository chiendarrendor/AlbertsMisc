import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Main {
    private static Scanner input = new Scanner(System.in);

    public static void fill(String s,char[] ary ) { for (int i = 0 ; i < 5 ; ++i) ary[i] = s.charAt(i); }

    public static String stringify(char[] ary) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0 ; i < 5 ; ++i) sb.append(ary[i]);
        return sb.toString();
    }

    public static void swap(char[] ary, int c1, int c2) {
        char t = ary[c1];
        ary[c1] = ary[c2];
        ary[c2] = t;
    }

    public static void activate(char[] ary, Map<String,Integer> swaps,int site,String priors) {
        String key = "" + ary[site] + site;
        if (!swaps.containsKey(key)) {
            System.out.print("given " + priors + ", where does letter " + ary[site] + " on site " + site + " go? ");
            swaps.put(key,input.nextInt());
        }
        int dest = swaps.get(key);

        swap(ary,site,dest);
    }



    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Bad command line <startword> <dest word> [<dest word>...]");
            System.exit(1);
        }

        for (int i = 0 ; i < args.length ; ++i) {
            if (args[i].length() != 5) {
                System.out.println("Arg " + i + " is not 5 letters long");
                System.exit(1);
            }
        }


        Map<String,Integer> swaps = new HashMap<>();

        char[] cells = new char[5];
        for (int i = 0 ; i < 5 ; ++i ) {
            for (int j = 0 ; j < 5 ; ++j) {
                for (int k = 0 ; k < 5 ; ++k) {
                    fill(args[0],cells);

                    activate(cells,swaps,i,"-");
                    activate(cells,swaps,j,"" + i);
                    activate(cells,swaps,k,"" + i + " " + j);

                    String r = stringify(cells);
                    boolean matches = false;
                    for (int v = 1 ; v < args.length ; ++v) {
                        if (r.equals(args[v]))  matches = true;
                    }

                    System.out.print(i + " " + j + " " + k + " " + stringify(cells));
                    if (matches) System.out.print("   <- AHA");
                    System.out.println("");
                }
            }
        }


    }
}
