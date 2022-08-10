import java.util.HashMap;
import java.util.Map;

public class BackAndForthShortestSubstring implements ShortestSubstring {
    // algorithm:
    // maintain two points start and end, and a Map of <Character,Integer>
    // initialize Map with count of each char in charset
    // for end = each character in input that is a character in charset, subtract 1 from value in map
    //    when all entries in map are <= 0, the substring from (start=0) to (end) is matching
    // --> this is shortest substring starting at 0 and ending at end
    // for start = each character in input that is a character in charset, add 1 to value in map
    //    if all entries in map are still <= 0, the substring from k to end is matching
    //    --> each one of these is shortest substring starting at k and ending at end
    //    if any entry in map is >= 0 we are no longer matching
    //
    // at this point, we have found the shortest substring ending at end
    // we also know that no substring starting at some v < end can match (or end would have been earlier)
    // furthermore, we also know that we've found the shortest substring starting at each index r < start
    //
    // from here on, if we are not matching, increment end and add characters until we match again.
    // until we match, we know that there is not a matching substring ending at end that is smaller than what we've found
    // when we are matched again, increment start and remove characters until we don't match


    private class OpMap extends HashMap<Character,Integer> {
        private int keysmatched = 0;
        public OpMap(String s) {
            for (int i = 0 ; i < s.length() ; ++i) {
                char c = s.charAt(i);
                put(c,getOrDefault(c,0) + 1);
            }
        }

        public void addOne(char c) {
            if (!containsKey(c)) return;
            int oval = get(c);
            if (oval == 1) ++keysmatched;
            put(c,oval-1);
        }

        public void removeOne(char c) {
            if (!containsKey(c)) return;
            int oval = get(c);
            if (oval == 0) --keysmatched;
            put(c,oval+1);
        }

        public boolean isMatching() {
            return keysmatched == size();
        }
    }

    @Override public StringPos shortestSubstring(String input, String charset) {
        StringPos result = new StringPos();
        OpMap om = new OpMap(charset);

        int end = -1;
        int start = 0;

        while(true) {
            if (om.isMatching()) {
                result.update(start,end-start+1);
                om.removeOne(input.charAt(start));
                ++start;
            } else {
                ++end;
                if (end >= input.length()) break;
                om.addOne(input.charAt(end));
            }
        }



        return result;
    }
}
