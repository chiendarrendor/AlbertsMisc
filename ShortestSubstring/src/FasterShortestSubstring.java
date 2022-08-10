import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeSet;

public class FasterShortestSubstring implements ShortestSubstring {

    @Override public StringPos shortestSubstring(String input, String charset) {
        StringPos result = new StringPos();
        Map<Character,Integer> cset = new HashMap<>();
        // O(m)
        for (char c : charset.toCharArray()) {
            cset.put(c,cset.getOrDefault(c,0) + 1);
        }

        List<Integer> indexes = new ArrayList<>();
        Map<Character,TreeSet<Integer>> locations = new HashMap<>();
        // O(n)
        for (int i = 0 ; i < input.length() ; ++i) {
            char c = input.charAt(i);
            if (cset.containsKey(c)) {
                indexes.add(i);
                if (!locations.containsKey(c)) {
                    locations.put(c,new TreeSet<Integer>());
                }
                // O(log n)
                locations.get(c).add(i);
            }
        }
        // Total: O(n log n)

        // O(n)
        for (int startindex : indexes) {
            char startc = input.charAt(startindex);
            int tailindex = startindex;

            // O(m) (for both loops 44 and 46)
            boolean missing = false;
            for (char tchar : locations.keySet()) {
                int tstart = startindex;
                for (int count = (tchar == startc ? 1 : 0) ; count < cset.get(tchar) ; ++count) {
                    Integer tailint = locations.get(tchar).ceiling(tstart+1); // O(log n)

                    if (tailint != null) {
                        int ti = tailint.intValue();
                        if (ti > tailindex) tailindex = ti;
                        tstart = ti;
                    } else {
                        missing = true;
                        break;
                    }
                }
            }
            if (!missing) {
                int len = tailindex - startindex + 1;
                if (len < result.length) {
                    result.length = len;
                    result.position = startindex;
                }
            }
        }
        // total: O( n * m * log n)




        return result;
    }
}
