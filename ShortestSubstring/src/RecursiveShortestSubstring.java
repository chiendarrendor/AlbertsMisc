import com.google.common.collect.HashMultiset;
import com.google.common.collect.Multiset;

public class RecursiveShortestSubstring implements  ShortestSubstring {


    private StringPos recursiveShortestSubstring(String input,Multiset<Character> cset) {
        StringPos result = new StringPos();
        if (cset.size() == 0) return result;

        for (int i = 0 ; i < input.length() ; ++i) {
            char curc = input.charAt(i);
            if (cset.contains(curc)) {
                if (cset.size() == 1) {
                    result.length = 1;
                    result.position = i;
                    return result;
                }

                cset.remove(curc);
                StringPos sub = recursiveShortestSubstring(input.substring(i+1),cset);

                if (sub.position != -1) {
                    int newlen = 1 + sub.position + sub.length;
                    if (newlen < result.length) {
                        result.length = newlen;
                        result.position = i;
                    }
                }
                cset.add(curc);
            }
        }
        return result;
    }


    @Override public StringPos shortestSubstring(String input, String charset) {
        if (input == null || charset == null) throw new RuntimeException("Null Arguments to shortestSubstring");

        Multiset<Character> cset = HashMultiset.create();
        for(char c : charset.toCharArray()) cset.add(c);

        return recursiveShortestSubstring(input,cset);
    }
}
