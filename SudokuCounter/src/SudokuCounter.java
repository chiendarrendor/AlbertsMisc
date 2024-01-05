import java.util.*;

public class SudokuCounter {
    private static boolean binaryOf(int num, int idx) {
        int mask = 1 << idx;
        int tgt = num & mask;

        return tgt != 0;
    }

    private static int sumOf(int num) {
        int result = 0;
        for (int i = 0 ; i < 9 ; ++i) {
            if (binaryOf(num,i)) result+=i+1;
        }
        return result;
    }

    private static String numbersOf(int num ) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0 ; i < 9 ; ++i) {
            if (binaryOf(num,i)) sb.append("-").append(i+1);
        }
        return sb.toString();
    }

    private static int countOf(int num) {
        int result = 0;
        for (int i = 0 ; i < 9 ; ++i) {
            if (binaryOf(num,i)) result++;
        }
        return result;
    }

    public static void main(String[] args) {
        int largest = 0b111111111;

        Map<Integer, List<String>> numbers = new TreeMap<>();

        for (int i = 0 ; i <= largest ; ++i) {
            int key = sumOf(i);
            if (!numbers.containsKey(key)) numbers.put(key,new ArrayList<>());
            numbers.get(key).add(numbersOf(i));
        }
        for (int key : numbers.keySet()) {
            System.out.print(""+key + ":");
            Collections.sort(numbers.get(key),new Comparator<String>() {
                @Override
                public int compare(String a, String b) {
                    if (a.length() != b.length()) return Integer.compare(a.length(),b.length());
                    return a.compareTo(b);
                }
            });
            for (String s : numbers.get(key)) {
                System.out.print(" " + s);
            }
            System.out.println("");
        }
    }
}
