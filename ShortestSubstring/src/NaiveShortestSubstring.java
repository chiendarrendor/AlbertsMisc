import java.util.HashMap;
import java.util.Map;

public class NaiveShortestSubstring implements ShortestSubstring{
    private static void subDown(Map<Character,Integer> map,char c) {
        if (map.containsKey(c)) {
            map.put(c,map.get(c)-1);
            if (map.get(c) == 0) {
                map.remove(c);
            }
        }
    }

    @Override public StringPos shortestSubstring(String input, String charset) {
        StringPos result = new StringPos();

        for (int i = 0 ; i < input.length() ; ++i) {
            Map<Character,Integer> curchars = new HashMap<>();
            for (char c : charset.toCharArray()) {
                curchars.put(c,curchars.getOrDefault(c,0) + 1);
            }

            for (int j = i ; j < input.length() ; ++j) {
                char c = input.charAt(j);
                subDown(curchars,c);

                if (curchars.isEmpty()) {
                    int newlen = j - i + 1;
                    if (newlen < result.length) {
                        result.length = newlen;
                        result.position = i;
                    }
                    break;
                }
            }
        }


        return result;
    }
}
